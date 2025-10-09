import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';

part 'page_list_state.freezed.dart';

// Enum to represent the different statuses of the list
enum PageListStatus { initial, loading, success, failure, loadingMore }

@freezed
abstract class PageListState with _$PageListState {
  const factory PageListState({
    @Default(PageListStatus.initial) PageListStatus status,
    @Default([]) List<Page> pages,
    @Default(1) int pageNumber,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _PageListState;
}