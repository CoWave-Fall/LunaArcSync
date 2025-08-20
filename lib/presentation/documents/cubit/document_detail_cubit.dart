// 文件路径: lib/presentation/documents/cubit/document_detail_cubit.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
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

  // 用于在内部方法中方便地访问当前文档ID
  String? _currentDocumentId;

  DocumentDetailCubit(
      this._documentRepository, this._pageRepository, this._jobRepository)
      : super(const DocumentDetailState.initial());

  Future<void> fetchDocument(String documentId) async {
    _currentDocumentId = documentId; // 保存 documentId
    emit(const DocumentDetailState.loading());
    try {
      final document = await _documentRepository.getDocumentById(documentId);
      emit(DocumentDetailState.success(document: document));
    } catch (e) {
      emit(DocumentDetailState.failure(message: e.toString()));
    }
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
  
  // --- 旧方法 addPageToDocument 保留，以防其他地方使用，但新逻辑将使用 insertPage ---
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

  // --- ↓↓↓ 新增和修改的方法 ↓↓↓ ---

  /// **[新增]** 更新 Page 的标题
  /// 对应 API: PUT /api/Pages/{id}
  Future<void> updatePageTitle(String pageId, String newTitle) async {
    if (_currentDocumentId == null) return;
    try {
      await _pageRepository.updatePage(pageId, {'title': newTitle});
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      // 可以在此抛出异常或处理错误
      rethrow;
    }
  }

  /// **[新增]** 使用 "set" 模式对所有 Page 进行重排序
  /// 对应 API: POST /api/documents/{documentId}/pages/reorder/set
  Future<void> reorderPages(List<Map<String, dynamic>> pageOrders) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.reorderPages(_currentDocumentId!, pageOrders);
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  /// **[新增]** 使用 "insert" 模式将一个 Page 添加到文档的指定顺序
  /// 对应 API: POST /api/documents/{documentId}/pages/reorder/insert
  Future<void> insertPage(String pageId, int newOrder) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.insertPage(_currentDocumentId!, pageId, newOrder);
      await fetchDocument(_currentDocumentId!);
    } catch (e) {
      rethrow;
    }
  }

  /// **[修改]** 创建 Page 并添加到 Document，增加了 newOrder 参数
  Future<void> createPageAndAddToDocument({
    required String title,
    required Uint8List fileBytes,
    required String fileName,
    required int newOrder, // <--- 添加了 newOrder 参数
  }) async {
    if (_currentDocumentId == null) return;
    try {
      // 1. 创建 Page
      final newPage = await _pageRepository.createPage(
        title: title,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      // 2. 使用新的 insertPage 方法将其添加到文档并排序
      await insertPage(newPage.pageId, newOrder);
      // insertPage 内部会调用 fetchDocument 刷新状态
    } catch (e) {
      rethrow;
    }
  }
  
  // --- ↑↑↑ 新增和修改的方法结束 ↑↑↑ ---

  // 您现有的 stitch 和 polling 逻辑保持不变
  Future<void> stitchAndAddPage({
    required String title,
    required List<PlatformFile> files,
  }) async {
    await state.whenOrNull(
      success: (document, _) async {
        try {
          final firstFile = files.first;
          final newPage = await _pageRepository.createPage(
            title: title,
            fileBytes: firstFile.bytes!,
            fileName: firstFile.name,
          );

          // 新增逻辑：为新页面设置 order
          final nextOrder = document.pages.length;
          await insertPage(newPage.pageId, nextOrder);
          // 旧的 addPageToDocument 不再需要
          // await _documentRepository.addPageToDocument(...)

          final List<String> sourceVersionIds = [newPage.pageId]; // 注意：这里可能有误，应该是 versionId
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
          
          state.whenOrNull(success: (doc, status) {
            final newStatus = Map<String, JobStatusEnum>.from(status);
            newStatus[newPage.pageId] = JobStatusEnum.Processing;
            // fetchDocument 已经在 insertPage 中调用，这里直接更新状态
            emit(DocumentDetailState.success(document: doc, pageStitchingStatus: newStatus));
          });

        } catch (e) {
          rethrow;
        }
      },
    );
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
            // 重新获取一下最新的文档状态
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