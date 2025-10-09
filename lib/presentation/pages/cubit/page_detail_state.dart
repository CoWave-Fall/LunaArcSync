import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';

part 'page_detail_state.freezed.dart';

@freezed
sealed class PageDetailState with _$PageDetailState {
  const factory PageDetailState.initial() = _Initial;
  const factory PageDetailState.loading() = _Loading;
  const factory PageDetailState.success({
    required PageDetail page,
    @Default(JobStatusEnum.Completed) JobStatusEnum ocrStatus,
    String? ocrErrorMessage,
    
    // --- START: NEW SEARCH FIELDS ---

    // The current search query entered by the user.
    @Default('') String searchQuery,
    
    // A list of all bounding boxes that match the search query.
    @Default([]) List<Bbox> highlightedBboxes,

    // --- END: NEW SEARCH FIELDS ---

  }) = _Success;
  const factory PageDetailState.failure({required String message}) = _Failure;
}