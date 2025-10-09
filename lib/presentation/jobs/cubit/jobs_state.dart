import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';

part 'jobs_state.freezed.dart';

@freezed
abstract class JobsState with _$JobsState {
  const factory JobsState.initial() = _Initial;
  const factory JobsState.loading() = _Loading;
  const factory JobsState.success(List<Job> jobs) = _Success;
  const factory JobsState.failure(String message) = _Failure;
  const factory JobsState.jobStatusChanged(List<Job> changedJobs) = _JobStatusChanged;
}
