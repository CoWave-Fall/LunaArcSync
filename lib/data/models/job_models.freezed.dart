// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobQueuedResponse {

 String get jobId; String get message;
/// Create a copy of JobQueuedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobQueuedResponseCopyWith<JobQueuedResponse> get copyWith => _$JobQueuedResponseCopyWithImpl<JobQueuedResponse>(this as JobQueuedResponse, _$identity);

  /// Serializes this JobQueuedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobQueuedResponse&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,message);

@override
String toString() {
  return 'JobQueuedResponse(jobId: $jobId, message: $message)';
}


}

/// @nodoc
abstract mixin class $JobQueuedResponseCopyWith<$Res>  {
  factory $JobQueuedResponseCopyWith(JobQueuedResponse value, $Res Function(JobQueuedResponse) _then) = _$JobQueuedResponseCopyWithImpl;
@useResult
$Res call({
 String jobId, String message
});




}
/// @nodoc
class _$JobQueuedResponseCopyWithImpl<$Res>
    implements $JobQueuedResponseCopyWith<$Res> {
  _$JobQueuedResponseCopyWithImpl(this._self, this._then);

  final JobQueuedResponse _self;
  final $Res Function(JobQueuedResponse) _then;

/// Create a copy of JobQueuedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = null,Object? message = null,}) {
  return _then(_self.copyWith(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JobQueuedResponse].
extension JobQueuedResponsePatterns on JobQueuedResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobQueuedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobQueuedResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobQueuedResponse value)  $default,){
final _that = this;
switch (_that) {
case _JobQueuedResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobQueuedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JobQueuedResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobId,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobQueuedResponse() when $default != null:
return $default(_that.jobId,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobId,  String message)  $default,) {final _that = this;
switch (_that) {
case _JobQueuedResponse():
return $default(_that.jobId,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobId,  String message)?  $default,) {final _that = this;
switch (_that) {
case _JobQueuedResponse() when $default != null:
return $default(_that.jobId,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobQueuedResponse implements JobQueuedResponse {
  const _JobQueuedResponse({required this.jobId, required this.message});
  factory _JobQueuedResponse.fromJson(Map<String, dynamic> json) => _$JobQueuedResponseFromJson(json);

@override final  String jobId;
@override final  String message;

/// Create a copy of JobQueuedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobQueuedResponseCopyWith<_JobQueuedResponse> get copyWith => __$JobQueuedResponseCopyWithImpl<_JobQueuedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobQueuedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobQueuedResponse&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,message);

@override
String toString() {
  return 'JobQueuedResponse(jobId: $jobId, message: $message)';
}


}

/// @nodoc
abstract mixin class _$JobQueuedResponseCopyWith<$Res> implements $JobQueuedResponseCopyWith<$Res> {
  factory _$JobQueuedResponseCopyWith(_JobQueuedResponse value, $Res Function(_JobQueuedResponse) _then) = __$JobQueuedResponseCopyWithImpl;
@override @useResult
$Res call({
 String jobId, String message
});




}
/// @nodoc
class __$JobQueuedResponseCopyWithImpl<$Res>
    implements _$JobQueuedResponseCopyWith<$Res> {
  __$JobQueuedResponseCopyWithImpl(this._self, this._then);

  final _JobQueuedResponse _self;
  final $Res Function(_JobQueuedResponse) _then;

/// Create a copy of JobQueuedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = null,Object? message = null,}) {
  return _then(_JobQueuedResponse(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Job {

 String get jobId; String get type; String get status; String? get associatedPageId;@UnixTimestampConverter() DateTime get submittedAt;@UnixTimestampConverter() DateTime? get startedAt;@UnixTimestampConverter() DateTime? get completedAt; String? get errorMessage; String? get resultUrl;
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCopyWith<Job> get copyWith => _$JobCopyWithImpl<Job>(this as Job, _$identity);

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Job&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.associatedPageId, associatedPageId) || other.associatedPageId == associatedPageId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.resultUrl, resultUrl) || other.resultUrl == resultUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,type,status,associatedPageId,submittedAt,startedAt,completedAt,errorMessage,resultUrl);

@override
String toString() {
  return 'Job(jobId: $jobId, type: $type, status: $status, associatedPageId: $associatedPageId, submittedAt: $submittedAt, startedAt: $startedAt, completedAt: $completedAt, errorMessage: $errorMessage, resultUrl: $resultUrl)';
}


}

/// @nodoc
abstract mixin class $JobCopyWith<$Res>  {
  factory $JobCopyWith(Job value, $Res Function(Job) _then) = _$JobCopyWithImpl;
@useResult
$Res call({
 String jobId, String type, String status, String? associatedPageId,@UnixTimestampConverter() DateTime submittedAt,@UnixTimestampConverter() DateTime? startedAt,@UnixTimestampConverter() DateTime? completedAt, String? errorMessage, String? resultUrl
});




}
/// @nodoc
class _$JobCopyWithImpl<$Res>
    implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._self, this._then);

  final Job _self;
  final $Res Function(Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = null,Object? type = null,Object? status = null,Object? associatedPageId = freezed,Object? submittedAt = null,Object? startedAt = freezed,Object? completedAt = freezed,Object? errorMessage = freezed,Object? resultUrl = freezed,}) {
  return _then(_self.copyWith(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,associatedPageId: freezed == associatedPageId ? _self.associatedPageId : associatedPageId // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,resultUrl: freezed == resultUrl ? _self.resultUrl : resultUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Job].
extension JobPatterns on Job {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Job value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Job value)  $default,){
final _that = this;
switch (_that) {
case _Job():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Job value)?  $default,){
final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobId,  String type,  String status,  String? associatedPageId, @UnixTimestampConverter()  DateTime submittedAt, @UnixTimestampConverter()  DateTime? startedAt, @UnixTimestampConverter()  DateTime? completedAt,  String? errorMessage,  String? resultUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.jobId,_that.type,_that.status,_that.associatedPageId,_that.submittedAt,_that.startedAt,_that.completedAt,_that.errorMessage,_that.resultUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobId,  String type,  String status,  String? associatedPageId, @UnixTimestampConverter()  DateTime submittedAt, @UnixTimestampConverter()  DateTime? startedAt, @UnixTimestampConverter()  DateTime? completedAt,  String? errorMessage,  String? resultUrl)  $default,) {final _that = this;
switch (_that) {
case _Job():
return $default(_that.jobId,_that.type,_that.status,_that.associatedPageId,_that.submittedAt,_that.startedAt,_that.completedAt,_that.errorMessage,_that.resultUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobId,  String type,  String status,  String? associatedPageId, @UnixTimestampConverter()  DateTime submittedAt, @UnixTimestampConverter()  DateTime? startedAt, @UnixTimestampConverter()  DateTime? completedAt,  String? errorMessage,  String? resultUrl)?  $default,) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.jobId,_that.type,_that.status,_that.associatedPageId,_that.submittedAt,_that.startedAt,_that.completedAt,_that.errorMessage,_that.resultUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Job implements Job {
  const _Job({required this.jobId, required this.type, required this.status, this.associatedPageId, @UnixTimestampConverter() required this.submittedAt, @UnixTimestampConverter() this.startedAt, @UnixTimestampConverter() this.completedAt, this.errorMessage, this.resultUrl});
  factory _Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

@override final  String jobId;
@override final  String type;
@override final  String status;
@override final  String? associatedPageId;
@override@UnixTimestampConverter() final  DateTime submittedAt;
@override@UnixTimestampConverter() final  DateTime? startedAt;
@override@UnixTimestampConverter() final  DateTime? completedAt;
@override final  String? errorMessage;
@override final  String? resultUrl;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCopyWith<_Job> get copyWith => __$JobCopyWithImpl<_Job>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Job&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.associatedPageId, associatedPageId) || other.associatedPageId == associatedPageId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.resultUrl, resultUrl) || other.resultUrl == resultUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,type,status,associatedPageId,submittedAt,startedAt,completedAt,errorMessage,resultUrl);

@override
String toString() {
  return 'Job(jobId: $jobId, type: $type, status: $status, associatedPageId: $associatedPageId, submittedAt: $submittedAt, startedAt: $startedAt, completedAt: $completedAt, errorMessage: $errorMessage, resultUrl: $resultUrl)';
}


}

/// @nodoc
abstract mixin class _$JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$JobCopyWith(_Job value, $Res Function(_Job) _then) = __$JobCopyWithImpl;
@override @useResult
$Res call({
 String jobId, String type, String status, String? associatedPageId,@UnixTimestampConverter() DateTime submittedAt,@UnixTimestampConverter() DateTime? startedAt,@UnixTimestampConverter() DateTime? completedAt, String? errorMessage, String? resultUrl
});




}
/// @nodoc
class __$JobCopyWithImpl<$Res>
    implements _$JobCopyWith<$Res> {
  __$JobCopyWithImpl(this._self, this._then);

  final _Job _self;
  final $Res Function(_Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = null,Object? type = null,Object? status = null,Object? associatedPageId = freezed,Object? submittedAt = null,Object? startedAt = freezed,Object? completedAt = freezed,Object? errorMessage = freezed,Object? resultUrl = freezed,}) {
  return _then(_Job(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,associatedPageId: freezed == associatedPageId ? _self.associatedPageId : associatedPageId // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,resultUrl: freezed == resultUrl ? _self.resultUrl : resultUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
