// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobQueuedResponse _$JobQueuedResponseFromJson(Map<String, dynamic> json) =>
    _JobQueuedResponse(
      jobId: json['jobId'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$JobQueuedResponseToJson(_JobQueuedResponse instance) =>
    <String, dynamic>{'jobId': instance.jobId, 'message': instance.message};

_Job _$JobFromJson(Map<String, dynamic> json) => _Job(
  jobId: json['jobId'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  associatedPageId: json['associatedPageId'] as String?,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  errorMessage: json['errorMessage'] as String?,
  resultUrl: json['resultUrl'] as String?,
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'jobId': instance.jobId,
  'type': instance.type,
  'status': instance.status,
  'associatedPageId': instance.associatedPageId,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'errorMessage': instance.errorMessage,
  'resultUrl': instance.resultUrl,
};
