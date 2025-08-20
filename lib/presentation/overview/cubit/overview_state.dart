import 'package:freezed_annotation/freezed_annotation.dart';

part 'overview_state.freezed.dart';

@freezed
sealed class OverviewState with _$OverviewState {
  const factory OverviewState.initial() = _Initial;
  const factory OverviewState.loading() = _Loading;
  const factory OverviewState.success({
    required int userCount,
    required int pageCount,
    required int documentCount,
  }) = _Success;
  const factory OverviewState.failure({required String message}) = _Failure;
}
