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
  status: $enumDecode(_$JobStatusEnumEnumMap, json['status']),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'jobId': instance.jobId,
  'status': _$JobStatusEnumEnumMap[instance.status]!,
  'errorMessage': instance.errorMessage,
};

const _$JobStatusEnumEnumMap = {
  JobStatusEnum.Queued: 'Queued',
  JobStatusEnum.Processing: 'Processing',
  JobStatusEnum.Completed: 'Completed',
  JobStatusEnum.Failed: 'Failed',
};
