import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/search_models.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.success(List<SearchResultItem> results) = _Success;
  const factory SearchState.failure(String error) = _Failure;
}
