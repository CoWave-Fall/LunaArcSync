import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'package:luna_arc_sync/data/repositories/user_repository.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'document_list_state.dart';

@injectable
class DocumentListCubit extends Cubit<DocumentListState> {
  final IDocumentRepository _documentRepository;
  final IUserRepository _userRepository;
  final SecureStorageService _secureStorageService;
  
  // 添加请求管理，防止并发请求导致顺序错误
  final Set<int> _loadingPages = {};

  DocumentListCubit(
    this._documentRepository,
    this._userRepository,
    this._secureStorageService,
  ) : super(const DocumentListState());

  Future<void> fetchDocuments({bool isRefresh = false}) async {
    if (state.isLoading) return;

    // 重置分页状态
    _loadingPages.clear();

    if (!isClosed) {
      emit(state.copyWith(isLoading: true, error: null));
    }

    try {
      // 直接获取所有文档，不再使用分页
      final allDocuments = await _documentRepository.getAllDocuments(
        sortBy: state.sortOption.apiValue,
        tags: state.selectedTags.isNotEmpty ? state.selectedTags : null,
      );

      if (!isClosed) {
        emit(state.copyWith(
          documents: allDocuments,
          pageNumber: 1,
          hasReachedMax: true, // 已经获取了所有数据
          isLoading: false,
        ));
        
        // 如果是admin，获取所有文档属主的用户信息
        await _fetchOwnerInfoForDocuments(allDocuments);
      }
    } on DioException catch (e) {
      if (!isClosed) {
        if (e.response?.statusCode == 503) {
          emit(state.copyWith(
            isLoading: false,
            error: 'Service is temporarily unavailable. Please try again later.',
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            error: e.message ?? e.toString(),
          ));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    }
  }

  Future<void> fetchAllTags() async {
    if (!isClosed) {
      emit(state.copyWith(areTagsLoading: true, tagsError: null));
    }
    try {
      final tags = await _documentRepository.getAllTags();
      if (!isClosed) {
        emit(state.copyWith(allTags: tags, areTagsLoading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(tagsError: e.toString(), areTagsLoading: false));
      }
    }
  }

  Future<void> changeSort(SortOption sortOption) async {
    if (state.sortOption == sortOption) return;
    if (!isClosed) {
      emit(state.copyWith(sortOption: sortOption));
    }
    await fetchDocuments(isRefresh: true);
  }

  Future<void> applyTagFilter(List<String> tags) async {
    if (!isClosed) {
      emit(state.copyWith(selectedTags: tags));
    }
    await fetchDocuments(isRefresh: true);
  }

  Future<void> createDocument(String title) async {
    try {
      // 1. Create the document with the title
      final newDocument = await _documentRepository.createDocument(title);

      // 2. Calculate the default tag
      final now = DateTime.now();
      final year = now.year;
      // Calculate the week of the year manually
      final dayOfYear = now.difference(DateTime(year, 1, 1)).inDays + 1;
      final week = (dayOfYear / 7).ceil();
      final defaultTag = '$year年$week周';

      // 3. Update the newly created document with the default tag
      await _documentRepository.updateDocument(
        documentId: newDocument.documentId,
        title: newDocument.title, // Pass the original title back
        tags: [defaultTag], // Set the tags list with the default tag
      );

      // 4. After creating and updating, refresh the list to show the new document
      await fetchDocuments(isRefresh: true);
    } catch (e) {
      // Optionally, emit a specific error state for creation failure
      if (!isClosed) {
        emit(state.copyWith(error: 'Failed to create document: ${e.toString()}'));
      }
    }
  }

  void refresh() {
    fetchDocuments(isRefresh: true);
  }


  Future<String> startBatchExportJob(List<String> documentIds) async {
    if (documentIds.isEmpty) {
      throw Exception('文档ID列表为空，无法开始批量导出');
    }

    try {
      // 启动批量导出任务，返回jobId
      final jobId = await _documentRepository.startBatchExportJob(documentIds);
      return jobId;
    } catch (e) {
      rethrow;
    }
  }

  /// 获取文档属主的用户信息（仅admin可见）
  Future<void> _fetchOwnerInfoForDocuments(List<dynamic> documents) async {
    // 检查是否是admin
    final isAdmin = await _secureStorageService.getIsAdmin();
    if (isAdmin != true) {
      return; // 不是admin，不需要获取用户信息
    }

    // 提取所有不重复的ownerUserId
    final ownerUserIds = documents
        .map((doc) => doc.ownerUserId)
        .whereType<String>()
        .toSet();

    if (ownerUserIds.isEmpty) {
      return;
    }

    // 创建新的用户信息缓存
    final newCache = Map<String, UserDto>.from(state.userInfoCache);

    // 批量获取用户信息
    for (final userId in ownerUserIds) {
      // 如果缓存中已有，跳过
      if (newCache.containsKey(userId)) {
        continue;
      }

      try {
        final userDto = await _userRepository.getUserById(userId);
        newCache[userId] = userDto;
      } catch (e) {
        // 获取失败时，记录错误但继续处理其他用户
        debugPrint('Failed to fetch user info for $userId: $e');
      }
    }

    // 更新状态
    if (!isClosed && newCache.length > state.userInfoCache.length) {
      emit(state.copyWith(userInfoCache: newCache));
    }
  }
}
