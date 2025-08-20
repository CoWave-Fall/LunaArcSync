import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart'; // 我们很快会创建它
import 'document_list_state.dart';
import 'package:intl/intl.dart'; // 导入 intl 来格式化周数

@injectable
class DocumentListCubit extends Cubit<DocumentListState> {
  final IDocumentRepository _documentRepository;

  DocumentListCubit(this._documentRepository) : super(const DocumentListState());

  Future<void> fetchDocuments() async {
    if (state.status == DocumentListStatus.loading) return;

    emit(state.copyWith(status: DocumentListStatus.loading));
    try {
      final result = await _documentRepository.getDocuments(pageNumber: 1);
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
      final result = await _documentRepository.getDocuments(pageNumber: nextPage);
      emit(state.copyWith(
        status: DocumentListStatus.success,
        documents: List.of(state.documents)..addAll(result.items),
        pageNumber: nextPage,
        hasReachedMax: !result.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(status: DocumentListStatus.success, errorMessage: e.toString()));
    }
  }

  Future<void> createDocument({required String title, List<String>? tags}) async {
    try {
      final defaultTag = _getDefaultWeekTag();
      final allTags = (tags ?? [])..add(defaultTag);
      
      await _documentRepository.createDocument(title: title, tags: allTags);
      await fetchDocuments(); // 创建成功后刷新列表
    } catch (e) {
      rethrow;
    }
  }

  String _getDefaultWeekTag() {
    final now = DateTime.now();
    // weekOfYear 的计算可能需要一个辅助库或自定义实现，这里用一个简化版
    // 专业的做法是使用 `package:week_of_year`
    final weekNumber = (now.day / 7).ceil(); 
    final year = DateFormat('yyyy').format(now);
    return '${year}年第${weekNumber}周';
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await _documentRepository.deleteDocument(documentId);
      await fetchDocuments(); // Refresh the list after deleting
    } catch (e) {
      rethrow;
    }
  }
}