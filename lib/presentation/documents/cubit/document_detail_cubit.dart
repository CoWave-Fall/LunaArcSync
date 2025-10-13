import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:luna_arc_sync/data/repositories/document_repository.dart'
    as doc_repo;
import 'package:luna_arc_sync/data/repositories/page_repository.dart'
    as page_repo;
import 'document_detail_state.dart';

const _pageSize = 10;

@injectable
class DocumentDetailCubit extends Cubit<DocumentDetailState> {
  final doc_repo.IDocumentRepository _documentRepository;
  final page_repo.IPageRepository _pageRepository;

  String? _currentDocumentId;
  int _currentPage = 1;
  
  // 添加请求管理，防止并发请求导致顺序错误
  final Set<int> _loadingPages = {};
  int _expectedNextPage = 1;

  DocumentDetailCubit(
    this._documentRepository,
    this._pageRepository,
    ) : super(const DocumentDetailState.initial());

  Future<void> fetchDocument(String documentId) async {
    _currentDocumentId = documentId;
    _currentPage = 1;
    
    // 重置分页状态
    _loadingPages.clear();
    _expectedNextPage = 1;
    
    emit(const DocumentDetailState.loading());
    try {
      // 1. Fetch document metadata
      final document = await _documentRepository.getDocumentById(documentId);

      // 2. Fetch the first page of page results
      final pageResult = await _documentRepository.getPagesForDocument(
        documentId,
        page: _currentPage,
        limit: _pageSize,
      );

      // 3. Emit success with the first batch of pages
      emit(DocumentDetailState.success(
        document: document.copyWith(pages: pageResult.items),
        hasReachedMax: !pageResult.hasNextPage,
        totalPageCount: pageResult.totalCount, // Save total page count
      ));
      _currentPage++; // Increment for the next fetch
      _expectedNextPage = 2; // 设置期望的下一页
    } catch (e) {
      emit(DocumentDetailState.failure(message: e.toString()));
    }
  }

  Future<void> fetchMorePages() async {
    // Ensure we are in a success state and haven't reached the end
    state.mapOrNull(
      success: (currentState) async {
        if (currentState.hasReachedMax) return;

        final nextPage = _expectedNextPage;
        
        // 防止重复请求同一页
        if (_loadingPages.contains(nextPage)) return;
        
        _loadingPages.add(nextPage);

        try {
          // Fetch the next page of results
          final pageResult = await _documentRepository.getPagesForDocument(
            _currentDocumentId!,
            page: nextPage,
            limit: _pageSize,
          );

          // 检查请求的页面是否仍然是期望的下一页，防止顺序错误
          if (nextPage == _expectedNextPage) {
            // Append new pages to the existing list
            final updatedPages = List.of(currentState.document.pages)..addAll(pageResult.items);

            emit(currentState.copyWith(
              document: currentState.document.copyWith(pages: updatedPages),
              hasReachedMax: !pageResult.hasNextPage,
            ));

            _currentPage = nextPage + 1;
            _expectedNextPage = nextPage + 1; // 更新期望的下一页
          }
          // 如果请求的页面不是期望的下一页，则忽略结果，避免顺序错误
        } catch (e) {
          // Optionally, handle fetch more errors differently
          // For now, we just print it
          if (kDebugMode) {
            print('Failed to fetch more pages: $e');
          }
        } finally {
          _loadingPages.remove(nextPage);
        }
      },
    );
  }

  // 优雅地刷新文档，保持当前状态但重新获取数据
  Future<void> refreshDocument() async {
    if (_currentDocumentId == null) return;
    
    // 如果当前是成功状态，保持成功状态但显示加载指示器
    state.mapOrNull(
      success: (currentState) {
        emit(currentState.copyWith(isRefreshing: true));
      },
    );
    
    try {
      // 重置分页状态
      _currentPage = 1;
      _loadingPages.clear();
      _expectedNextPage = 1;
      
      // 重新获取文档和第一页数据
      final document = await _documentRepository.getDocumentById(_currentDocumentId!);
      final pageResult = await _documentRepository.getPagesForDocument(
        _currentDocumentId!,
        page: _currentPage,
        limit: _pageSize,
      );

      // 发出成功状态，包含所有页面数据
      emit(DocumentDetailState.success(
        document: document.copyWith(pages: pageResult.items),
        hasReachedMax: !pageResult.hasNextPage,
        isRefreshing: false,
        totalPageCount: pageResult.totalCount, // Save total page count
      ));
      
      _currentPage++; // 为下次获取准备
      _expectedNextPage = 2; // 设置期望的下一页
    } catch (e) {
      // 如果刷新失败，恢复到之前的状态
      state.mapOrNull(
        success: (currentState) {
          emit(currentState.copyWith(isRefreshing: false));
        },
      );
      // 可以选择发出错误状态或保持当前状态
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
      await refreshDocument();
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
      await refreshDocument();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePage(String pageId) async {
    if (_currentDocumentId == null) return;
    try {
      await _pageRepository.deletePage(pageId);
      // Instead of full refresh, remove page locally for better UX
      state.mapOrNull(success: (currentState) {
        final updatedPages = currentState.document.pages.where((p) => p.pageId != pageId).toList();
        emit(currentState.copyWith(
          document: currentState.document.copyWith(pages: updatedPages),
        ));
      });
    } catch (e) {
      // If fails, refresh to get consistent state
      await refreshDocument();
      rethrow;
    }
  }

  Future<void> updatePageTitle(String pageId, String newTitle) async {
    if (_currentDocumentId == null) return;
    try {
      await _pageRepository.updatePage(pageId, {'title': newTitle});
      // Update locally for better UX
      state.mapOrNull(success: (currentState) {
        final updatedPages = currentState.document.pages.map((p) {
          if (p.pageId == pageId) {
            return p.copyWith(title: newTitle);
          }
          return p;
        }).toList();
        emit(currentState.copyWith(
          document: currentState.document.copyWith(pages: updatedPages),
        ));
      });
    } catch (e) {
      await refreshDocument();
      rethrow;
    }
  }

  Future<void> reorderPages(List<Map<String, dynamic>> pageOrders) async {
    if (_currentDocumentId == null) return;
    try {
      await _documentRepository.reorderPages(_currentDocumentId!, pageOrders);
      await refreshDocument();
    } catch (e) {
      rethrow;
    }
  }

  // NEW: Method for interactive insertion sort
  Future<void> movePage(String pageId, int newOrder) async {
    if (_currentDocumentId == null) return;
    try {
      // Assumes repository has this new method matching the user's API spec
      await _documentRepository.insertPage(
        _currentDocumentId!,
        pageId,
        newOrder,
      );
      // After a major reorder, a full refresh is the safest way to ensure UI consistency
      await refreshDocument();
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

  Future<void> createPagesFromPdf({
    required String filePath, // Changed to filePath
    required String fileName,
  }) async {
    if (_currentDocumentId == null) return;
    try {
      // This API call should now be non-blocking and maybe return a job ID
      await _documentRepository.createPagesFromPdf(
        documentId: _currentDocumentId!,
        filePath: filePath, // Pass path instead of bytes
        fileName: fileName,
      );
      // The UI will show a snackbar. A websocket or periodic refresh
      // would be needed to show new pages without manual refresh.
      // For now, we rely on the user to pull-to-refresh or we can trigger a delayed refresh.
      Future.delayed(const Duration(seconds: 5), () => refreshDocument());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadPages({
    required String documentId,
    required List<String> filePaths,
  }) async {
    if (_currentDocumentId == null || _currentDocumentId != documentId) return;

    try {
      for (final filePath in filePaths) {
        final file = File(filePath);
        final fileName = p.basename(filePath);


        // For now, we upload one by one based on existing repository methods.
        final newPage = await _pageRepository.createPage(
          title: fileName,
          fileBytes: await file.readAsBytes(),
          fileName: fileName,
        );
        await _documentRepository.addPageToDocument(
          documentId: documentId,
          pageId: newPage.pageId,
        );
      }
    } catch (e) {
      // The calling UI is responsible for catching this and showing an error.
      rethrow;
    }
  }

  Future<String> startPdfExportJob() async {
    if (_currentDocumentId == null) {
      throw Exception('文档ID为空，无法导出PDF');
    }

    try {
      // 启动PDF导出任务，返回jobId
      final jobId = await _documentRepository.startPdfExportJob(_currentDocumentId!);
      return jobId;
    } catch (e) {
      rethrow;
    }
  }
  
  // Other methods like createPageByStitching, _startPolling would need similar adjustments
  // to work with the paginated state, likely involving a refresh.
  // For brevity, they are omitted here but should be considered in a full implementation.
}

