// 文件路径: lib/presentation/documents/cubit/document_detail_cubit.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;
import 'package:luna_arc_sync/data/repositories/document_repository.dart'
    as doc_repo;
import 'package:luna_arc_sync/data/repositories/job_repository.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart'
    as page_repo;
import 'document_detail_state.dart';

@injectable
class DocumentDetailCubit extends Cubit<DocumentDetailState> {
  final doc_repo.IDocumentRepository _documentRepository;
  final page_repo.IPageRepository _pageRepository;
  final IJobRepository _jobRepository;
  final ApiClient _apiClient; // NEW: Inject ApiClient

  String? _currentDocumentId;

  DocumentDetailCubit(
    this._documentRepository,
    this._pageRepository,
    this._jobRepository,
    this._apiClient, // NEW
  ) : super(const DocumentDetailState.initial());

  Future<void> fetchDocument(String documentId) async {
    _currentDocumentId = documentId;
    emit(const DocumentDetailState.loading());
    try {
      final document = await _documentRepository.getDocumentById(documentId);
      emit(DocumentDetailState.success(document: document));
    } catch (e) {
      emit(DocumentDetailState.failure(message: e.toString()));
    }
  }

  // NEW: Method to enrich pages with thumbnail URLs
  Future<void> enrichPagesWithThumbnails() async {
    await state.mapOrNull(
      success: (successState) async {
        final document = successState.document;
        final pages = document.pages;

        if (pages.isEmpty) return;

        try {
          final pageDetailsFutures = pages
              .map((page) => _pageRepository.getPageById(page.pageId))
              .toList();
          final pageDetailsResults = await Future.wait(pageDetailsFutures);

          final baseUrl = _apiClient.getBaseUrl();
          final pageDetailsMap = {
            for (var detail in pageDetailsResults) detail.pageId: detail
          };

          final enrichedPages = pages.map((page) {
            final detail = pageDetailsMap[page.pageId];
            if (detail == null) return page;

            final thumbnailUrl =
                '$baseUrl/images/${detail.currentVersion.versionId}';
            return page.copyWith(thumbnailUrl: thumbnailUrl);
          }).toList();

          final enrichedDocument = document.copyWith(pages: enrichedPages);

          // Emit a new success state with the updated document
          if (!isClosed) {
            emit(successState.copyWith(document: enrichedDocument));
          }
        } catch (e) {
          print('Error enriching pages with thumbnails: $e');
        }
      },
    );
  }

  Future<void> updateDocument(
      {required String title, required List<String> tags}) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.updateDocument(
        documentId: _currentDocumentId!,
        title: title,
        tags: tags,
      );
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPageToDocument(String pageId) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.addPageToDocument(
        documentId: _currentDocumentId!,
        pageId: pageId,
      );
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePage(String pageId) async {
    if (_currentDocumentId == null) return;
    try {
      await _pageRepository.deletePage(pageId);
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePageTitle(String pageId, String newTitle) async {
    if (_currentDocumentId == null) return;
    try {
      await _pageRepository.updatePage(pageId, {'title': newTitle});
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reorderPages(List<Map<String, dynamic>> pageOrders) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.reorderPages(_currentDocumentId!, pageOrders);
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertPage(String pageId, int newOrder) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.insertPage(_currentDocumentId!, pageId, newOrder);
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPageAndAddToDocument({
    required String title,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    if (_currentDocumentId == null) return;
    try {
      final newPage = await _pageRepository.createPage(
        title: title,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      await addPageToDocument(newPage.pageId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPageByStitching({
    required String title,
    required List<PlatformFile> files,
  }) async {
    if (files.isEmpty) return;

    try {
      final firstFile = files.first;
      final newPage = await _pageRepository.createPage(
        title: title,
        fileBytes: firstFile.bytes!,
        fileName: firstFile.name,
      );

      await addPageToDocument(newPage.pageId);

      final pageDetail = await _pageRepository.getPageById(newPage.pageId);
      final String initialVersionId = pageDetail.currentVersion.versionId;

      final List<String> sourceVersionIds = [initialVersionId];

      for (int i = 1; i < files.length; i++) {
        final file = files[i];
        final newVersion = await _pageRepository.addVersionToPage(
          pageId: newPage.pageId,
          fileBytes: file.bytes!,
          fileName: file.name,
        );
        sourceVersionIds.add(newVersion.versionId);
      }

      final job = await _pageRepository.startStitchJob(
        pageId: newPage.pageId,
        sourceVersionIds: sourceVersionIds,
      );

      _startPolling(job.jobId, newPage.pageId);

      state.mapOrNull(success: (successState) {
        final newStatus =
            Map<String, JobStatusEnum>.from(successState.pageStitchingStatus);
        newStatus[newPage.pageId] = JobStatusEnum.Processing;
        emit(successState.copyWith(pageStitchingStatus: newStatus));
      });
    } catch (e) {
      rethrow;
    }
  }

  void _startPolling(String jobId, String pageId) {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (isClosed) {
        timer.cancel();
        return;
      }

      try {
        final job = await _jobRepository.getJobStatus(jobId);

        if (job.status == JobStatusEnum.Completed) {
          timer.cancel();
          await state.whenOrNull(success: (doc, status) async {
            if (_currentDocumentId != null) {
              final updatedDoc = await _documentRepository.getDocumentById(_currentDocumentId!);
              final newStatus = Map<String, JobStatusEnum>.from(status);
              newStatus.remove(pageId);
              emit(DocumentDetailState.success(document: updatedDoc, pageStitchingStatus: newStatus));
            }
          });
        } else if (job.status == JobStatusEnum.Failed) {
          timer.cancel();
          state.whenOrNull(
            success: (doc, status) {
              if (!isClosed) {
                final newStatus = Map<String, JobStatusEnum>.from(status);
                newStatus[pageId] = JobStatusEnum.Failed;
                emit(DocumentDetailState.success(document: doc, pageStitchingStatus: newStatus));
              }
            },
          );
        }
      } catch (e) {
        timer.cancel();
        state.whenOrNull(
          success: (doc, status) {
            if (!isClosed) {
              final newStatus = Map<String, JobStatusEnum>.from(status);
              newStatus[pageId] = JobStatusEnum.Failed;
              emit(DocumentDetailState.success(document: doc, pageStitchingStatus: newStatus));
            }
          },
        );
      }
    });
  }
}
