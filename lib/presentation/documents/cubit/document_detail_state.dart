import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';

part 'document_detail_state.freezed.dart';

@freezed
sealed class DocumentDetailState with _$DocumentDetailState {
  const factory DocumentDetailState.initial() = _Initial;
  const factory DocumentDetailState.loading() = _Loading;
  const factory DocumentDetailState.success({
    required DocumentDetail document,
    @Default({}) Map<String, JobStatusEnum> pageStitchingStatus,
  }) = _Success;
  const factory DocumentDetailState.failure({required String message}) = _Failure;
}