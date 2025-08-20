// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobQueuedResponseImpl _$$JobQueuedResponseImplFromJson(
  Map<String, dynamic> json,
) => _$JobQueuedResponseImpl(
  jobId: json['jobId'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$$JobQueuedResponseImplToJson(
  _$JobQueuedResponseImpl instance,
) => <String, dynamic>{'jobId': instance.jobId, 'message': instance.message};

_$JobImpl _$$JobImplFromJson(Map<String, dynamic> json) => _$JobImpl(
  jobId: json['jobId'] as String,
  status: $enumDecode(_$JobStatusEnumEnumMap, json['status']),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$JobImplToJson(_$JobImpl instance) => <String, dynamic>{
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
