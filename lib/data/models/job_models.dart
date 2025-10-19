// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/api/json_converters.dart';
part 'job_models.freezed.dart';
part 'job_models.g.dart';

// 定义任务状态的枚举
enum JobStatusEnum { 
  Queued, 
  Processing, 
  Completed, 
  Failed,
  // 添加更多可能的状态
  Pending,
  Running,
  Success,
  Error,
  Cancelled
}

// 扩展方法用于状态转换
extension JobStatusEnumExtension on String {
  JobStatusEnum toJobStatusEnum() {
    switch (toLowerCase()) {
      case 'queued':
        return JobStatusEnum.Queued;
      case 'processing':
      case 'running':
        return JobStatusEnum.Processing;
      case 'completed':
      case 'success':
        return JobStatusEnum.Completed;
      case 'failed':
      case 'error':
        return JobStatusEnum.Failed;
      case 'pending':
        return JobStatusEnum.Pending;
      case 'cancelled':
        return JobStatusEnum.Cancelled;
      default:
        return JobStatusEnum.Queued;
    }
  }
}

// 用于 POST /api/jobs/... 成功后返回的模型
@freezed
abstract class JobQueuedResponse with _$JobQueuedResponse {
  const factory JobQueuedResponse({
    required String jobId,
    required String message,
  }) = _JobQueuedResponse;

  factory JobQueuedResponse.fromJson(Map<String, dynamic> json) =>
      _$JobQueuedResponseFromJson(json);
}

// 用于 GET /api/jobs/my-active 返回的模型
@freezed
abstract class Job with _$Job {
  const factory Job({
    required String jobId,
    required String type,
    required String status,
    String? associatedPageId,
    @UnixTimestampConverter()
    required DateTime submittedAt,
    @UnixTimestampConverter()
    DateTime? startedAt,
    @UnixTimestampConverter()
    DateTime? completedAt,
    String? errorMessage,
    String? resultUrl,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}