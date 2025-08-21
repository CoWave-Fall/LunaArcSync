// lib/presentation/documents/cubit/document_list_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'document_list_state.dart';
import 'package:intl/intl.dart';

@injectable
class DocumentListCubit extends Cubit<DocumentListState> {
  final IDocumentRepository _documentRepository;

  DocumentListCubit(this._documentRepository) : super(const DocumentListState());

  Future<void> fetchDocuments({bool refresh = false}) async {
    if (state.status == DocumentListStatus.loading && !refresh) return;

    emit(state.copyWith(
      status: refresh ? DocumentListStatus.loading : DocumentListStatus.initial,
      documents: refresh ? [] : state.documents,
      pageNumber: refresh ? 1 : state.pageNumber,
      hasReachedMax: refresh ? false : state.hasReachedMax,
    ));
    
    try {
      final result = await _documentRepository.getDocuments(
        pageNumber: 1,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
        filterTags: state.filterTags,
      );
      emit(state.copyWith(
        status: DocumentListStatus.success,
        documents: result.items,
        pageNumber: 1,
        hasReachedMax: !result.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(status: DocumentListStatus.failure, errorMessage: e.toString()));
    }
  }
  
  Future<void> fetchNextPage() async {
    if (state.hasReachedMax || state.status == DocumentListStatus.loadingMore) return;

    emit(state.copyWith(status: DocumentListStatus.loadingMore));
    try {
      final nextPage = state.pageNumber + 1;
      final result = await _documentRepository.getDocuments(
        pageNumber: nextPage,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
        filterTags: state.filterTags,
      );
      emit(state.copyWith(
        status: DocumentListStatus.success,
        documents: List.of(state.documents)..addAll(result.items),
        pageNumber: nextPage,
        hasReachedMax: !result.hasNextPage,
      ));
    } catch (e) {
      // 保持现有文档，只显示错误
      emit(state.copyWith(status: DocumentListStatus.success, errorMessage: e.toString()));
    }
  }
  
  String getAutoTagForCreation() {
    final now = DateTime.now();
    final year = now.year;
    // 使用 'ww' 来获取 ISO 标准的周数
    final week = DateFormat('ww').format(now);
    return '${year}年${week}周';
  }

  Future<void> createDocument({required String title, required List<String> tags}) async {
    try {
      await _documentRepository.createDocument(title: title, tags: tags);
      await fetchDocuments(refresh: true); // 创建成功后刷新列表
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDocument({
    required String documentId,
    required String title,
    required List<String> tags,
  }) async {
    try {
      await _documentRepository.updateDocument(
        documentId: documentId,
        title: title,
        tags: tags,
      );
      // 优化：本地更新状态，避免网络请求
      final documents = List<Document>.from(state.documents);
      final index = documents.indexWhere((doc) => doc.documentId == documentId);
      if (index != -1) {
        // 创建一个新的 Document 实例来更新列表
        documents[index] = documents[index].copyWith(title: title, tags: tags);
        emit(state.copyWith(documents: documents));
      }
    } catch (e) {
      // 在这里可以发射一个带有错误信息的状态，让 UI 显示 SnackBar
       emit(state.copyWith(errorMessage: 'Failed to update document: $e'));
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await _documentRepository.deleteDocument(documentId);
      // 优化：本地删除，避免网络请求
      final documents = List<Document>.from(state.documents)
        ..removeWhere((doc) => doc.documentId == documentId);
      emit(state.copyWith(documents: documents));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeSorting(SortBy sortBy) async {
    SortOrder newOrder;
    if (state.sortBy == sortBy) {
      newOrder = state.sortOrder == SortOrder.desc ? SortOrder.asc : SortOrder.desc;
    } else {
      newOrder = SortOrder.desc;
    }
    emit(state.copyWith(sortBy: sortBy, sortOrder: newOrder));
    await fetchDocuments(refresh: true);
  }

  Future<void> filterByTags(List<String> tags) async {
    emit(state.copyWith(filterTags: tags));
    await fetchDocuments(refresh: true);
  }
}