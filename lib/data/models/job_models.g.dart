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
  submittedAt: const UnixTimestampConverter().fromJson(json['submittedAt']),
  startedAt: const UnixTimestampConverter().fromJson(json['startedAt']),
  completedAt: const UnixTimestampConverter().fromJson(json['completedAt']),
  errorMessage: json['errorMessage'] as String?,
  resultUrl: json['resultUrl'] as String?,
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'jobId': instance.jobId,
  'type': instance.type,
  'status': instance.status,
  'associatedPageId': instance.associatedPageId,
  'submittedAt': const UnixTimestampConverter().toJson(instance.submittedAt),
  'startedAt': _$JsonConverterToJson<dynamic, DateTime>(
    instance.startedAt,
    const UnixTimestampConverter().toJson,
  ),
  'completedAt': _$JsonConverterToJson<dynamic, DateTime>(
    instance.completedAt,
    const UnixTimestampConverter().toJson,
  ),
  'errorMessage': instance.errorMessage,
  'resultUrl': instance.resultUrl,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
