// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jobs_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobsState()';
}


}

/// @nodoc
class $JobsStateCopyWith<$Res>  {
$JobsStateCopyWith(JobsState _, $Res Function(JobsState) __);
}


/// Adds pattern-matching-related methods to [JobsState].
extension JobsStatePatterns on JobsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,TResult Function( _JobStatusChanged value)?  jobStatusChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _JobStatusChanged() when jobStatusChanged != null:
return jobStatusChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,required TResult Function( _JobStatusChanged value)  jobStatusChanged,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);case _JobStatusChanged():
return jobStatusChanged(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,TResult? Function( _JobStatusChanged value)?  jobStatusChanged,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _JobStatusChanged() when jobStatusChanged != null:
return jobStatusChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Job> jobs)?  success,TResult Function( String message)?  failure,TResult Function( List<Job> changedJobs)?  jobStatusChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.jobs);case _Failure() when failure != null:
return failure(_that.message);case _JobStatusChanged() when jobStatusChanged != null:
return jobStatusChanged(_that.changedJobs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Job> jobs)  success,required TResult Function( String message)  failure,required TResult Function( List<Job> changedJobs)  jobStatusChanged,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.jobs);case _Failure():
return failure(_that.message);case _JobStatusChanged():
return jobStatusChanged(_that.changedJobs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Job> jobs)?  success,TResult? Function( String message)?  failure,TResult? Function( List<Job> changedJobs)?  jobStatusChanged,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.jobs);case _Failure() when failure != null:
return failure(_that.message);case _JobStatusChanged() when jobStatusChanged != null:
return jobStatusChanged(_that.changedJobs);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements JobsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobsState.initial()';
}


}




/// @nodoc


class _Loading implements JobsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobsState.loading()';
}


}




/// @nodoc


class _Success implements JobsState {
  const _Success(final  List<Job> jobs): _jobs = jobs;
  

 final  List<Job> _jobs;
 List<Job> get jobs {
  if (_jobs is EqualUnmodifiableListView) return _jobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jobs);
}


/// Create a copy of JobsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&const DeepCollectionEquality().equals(other._jobs, _jobs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jobs));

@override
String toString() {
  return 'JobsState.success(jobs: $jobs)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $JobsStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 List<Job> jobs
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of JobsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? jobs = null,}) {
  return _then(_Success(
null == jobs ? _self._jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<Job>,
  ));
}


}

/// @nodoc


class _Failure implements JobsState {
  const _Failure(this.message);
  

 final  String message;

/// Create a copy of JobsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JobsState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $JobsStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of JobsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _JobStatusChanged implements JobsState {
  const _JobStatusChanged(final  List<Job> changedJobs): _changedJobs = changedJobs;
  

 final  List<Job> _changedJobs;
 List<Job> get changedJobs {
  if (_changedJobs is EqualUnmodifiableListView) return _changedJobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changedJobs);
}


/// Create a copy of JobsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobStatusChangedCopyWith<_JobStatusChanged> get copyWith => __$JobStatusChangedCopyWithImpl<_JobStatusChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobStatusChanged&&const DeepCollectionEquality().equals(other._changedJobs, _changedJobs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_changedJobs));

@override
String toString() {
  return 'JobsState.jobStatusChanged(changedJobs: $changedJobs)';
}


}

/// @nodoc
abstract mixin class _$JobStatusChangedCopyWith<$Res> implements $JobsStateCopyWith<$Res> {
  factory _$JobStatusChangedCopyWith(_JobStatusChanged value, $Res Function(_JobStatusChanged) _then) = __$JobStatusChangedCopyWithImpl;
@useResult
$Res call({
 List<Job> changedJobs
});




}
/// @nodoc
class __$JobStatusChangedCopyWithImpl<$Res>
    implements _$JobStatusChangedCopyWith<$Res> {
  __$JobStatusChangedCopyWithImpl(this._self, this._then);

  final _JobStatusChanged _self;
  final $Res Function(_JobStatusChanged) _then;

/// Create a copy of JobsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? changedJobs = null,}) {
  return _then(_JobStatusChanged(
null == changedJobs ? _self._changedJobs : changedJobs // ignore: cast_nullable_to_non_nullable
as List<Job>,
  ));
}


}

// dart format on
