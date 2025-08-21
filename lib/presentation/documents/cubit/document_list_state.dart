import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';

part 'document_list_state.freezed.dart';

enum DocumentListStatus { initial, loading, success, failure, loadingMore }
enum SortBy {  updatedAt,  title,  pageCount,}
enum SortOrder {  asc,  desc,}

@freezed
class DocumentListState with _$DocumentListState {
  const factory DocumentListState({
    @Default(DocumentListStatus.initial) DocumentListStatus status,
    @Default([]) List<Document> documents,
    @Default(1) int pageNumber,
    @Default(false) bool hasReachedMax,
    String? errorMessage,

    @Default(SortBy.updatedAt) SortBy sortBy,
    @Default(SortOrder.desc) SortOrder sortOrder,
    @Default([]) List<String> filterTags,

  }) = _DocumentListState;
}