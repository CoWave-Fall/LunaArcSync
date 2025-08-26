// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
part 'job_models.freezed.dart';
part 'job_models.g.dart';

// 定义任务状态的枚举
enum JobStatusEnum { Queued, Processing, Completed, Failed }

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

// 用于 GET /api/jobs/{jobId} 返回的模型
@freezed
abstract class Job with _$Job {
  const factory Job({
    required String jobId,
    required JobStatusEnum status,
    String? errorMessage,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}