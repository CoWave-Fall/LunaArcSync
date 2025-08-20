// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobQueuedResponse _$JobQueuedResponseFromJson(Map<String, dynamic> json) {
  return _JobQueuedResponse.fromJson(json);
}

/// @nodoc
mixin _$JobQueuedResponse {
  String get jobId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this JobQueuedResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobQueuedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobQueuedResponseCopyWith<JobQueuedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobQueuedResponseCopyWith<$Res> {
  factory $JobQueuedResponseCopyWith(
    JobQueuedResponse value,
    $Res Function(JobQueuedResponse) then,
  ) = _$JobQueuedResponseCopyWithImpl<$Res, JobQueuedResponse>;
  @useResult
  $Res call({String jobId, String message});
}

/// @nodoc
class _$JobQueuedResponseCopyWithImpl<$Res, $Val extends JobQueuedResponse>
    implements $JobQueuedResponseCopyWith<$Res> {
  _$JobQueuedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobQueuedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? jobId = null, Object? message = null}) {
    return _then(
      _value.copyWith(
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobQueuedResponseImplCopyWith<$Res>
    implements $JobQueuedResponseCopyWith<$Res> {
  factory _$$JobQueuedResponseImplCopyWith(
    _$JobQueuedResponseImpl value,
    $Res Function(_$JobQueuedResponseImpl) then,
  ) = __$$JobQueuedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String jobId, String message});
}

/// @nodoc
class __$$JobQueuedResponseImplCopyWithImpl<$Res>
    extends _$JobQueuedResponseCopyWithImpl<$Res, _$JobQueuedResponseImpl>
    implements _$$JobQueuedResponseImplCopyWith<$Res> {
  __$$JobQueuedResponseImplCopyWithImpl(
    _$JobQueuedResponseImpl _value,
    $Res Function(_$JobQueuedResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobQueuedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? jobId = null, Object? message = null}) {
    return _then(
      _$JobQueuedResponseImpl(
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobQueuedResponseImpl implements _JobQueuedResponse {
  const _$JobQueuedResponseImpl({required this.jobId, required this.message});

  factory _$JobQueuedResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobQueuedResponseImplFromJson(json);

  @override
  final String jobId;
  @override
  final String message;

  @override
  String toString() {
    return 'JobQueuedResponse(jobId: $jobId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobQueuedResponseImpl &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jobId, message);

  /// Create a copy of JobQueuedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobQueuedResponseImplCopyWith<_$JobQueuedResponseImpl> get copyWith =>
      __$$JobQueuedResponseImplCopyWithImpl<_$JobQueuedResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobQueuedResponseImplToJson(this);
  }
}

abstract class _JobQueuedResponse implements JobQueuedResponse {
  const factory _JobQueuedResponse({
    required final String jobId,
    required final String message,
  }) = _$JobQueuedResponseImpl;

  factory _JobQueuedResponse.fromJson(Map<String, dynamic> json) =
      _$JobQueuedResponseImpl.fromJson;

  @override
  String get jobId;
  @override
  String get message;

  /// Create a copy of JobQueuedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobQueuedResponseImplCopyWith<_$JobQueuedResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Job _$JobFromJson(Map<String, dynamic> json) {
  return _Job.fromJson(json);
}

/// @nodoc
mixin _$Job {
  String get jobId => throw _privateConstructorUsedError;
  JobStatusEnum get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobCopyWith<Job> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobCopyWith<$Res> {
  factory $JobCopyWith(Job value, $Res Function(Job) then) =
      _$JobCopyWithImpl<$Res, Job>;
  @useResult
  $Res call({String jobId, JobStatusEnum status, String? errorMessage});
}

/// @nodoc
class _$JobCopyWithImpl<$Res, $Val extends Job> implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as JobStatusEnum,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobImplCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$$JobImplCopyWith(_$JobImpl value, $Res Function(_$JobImpl) then) =
      __$$JobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String jobId, JobStatusEnum status, String? errorMessage});
}

/// @nodoc
class __$$JobImplCopyWithImpl<$Res> extends _$JobCopyWithImpl<$Res, _$JobImpl>
    implements _$$JobImplCopyWith<$Res> {
  __$$JobImplCopyWithImpl(_$JobImpl _value, $Res Function(_$JobImpl) _then)
    : super(_value, _then);

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$JobImpl(
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as JobStatusEnum,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobImpl implements _Job {
  const _$JobImpl({
    required this.jobId,
    required this.status,
    this.errorMessage,
  });

  factory _$JobImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobImplFromJson(json);

  @override
  final String jobId;
  @override
  final JobStatusEnum status;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'Job(jobId: $jobId, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobImpl &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jobId, status, errorMessage);

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      __$$JobImplCopyWithImpl<_$JobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobImplToJson(this);
  }
}

abstract class _Job implements Job {
  const factory _Job({
    required final String jobId,
    required final JobStatusEnum status,
    final String? errorMessage,
  }) = _$JobImpl;

  factory _Job.fromJson(Map<String, dynamic> json) = _$JobImpl.fromJson;

  @override
  String get jobId;
  @override
  JobStatusEnum get status;
  @override
  String? get errorMessage;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
