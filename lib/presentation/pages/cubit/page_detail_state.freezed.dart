// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PageDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PageDetailState()';
}


}

/// @nodoc
class $PageDetailStateCopyWith<$Res>  {
$PageDetailStateCopyWith(PageDetailState _, $Res Function(PageDetailState) __);
}


/// Adds pattern-matching-related methods to [PageDetailState].
extension PageDetailStatePatterns on PageDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PageDetail page,  JobStatusEnum ocrStatus,  String? ocrErrorMessage,  String searchQuery,  List<Bbox> highlightedBboxes)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.page,_that.ocrStatus,_that.ocrErrorMessage,_that.searchQuery,_that.highlightedBboxes);case _Failure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PageDetail page,  JobStatusEnum ocrStatus,  String? ocrErrorMessage,  String searchQuery,  List<Bbox> highlightedBboxes)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.page,_that.ocrStatus,_that.ocrErrorMessage,_that.searchQuery,_that.highlightedBboxes);case _Failure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PageDetail page,  JobStatusEnum ocrStatus,  String? ocrErrorMessage,  String searchQuery,  List<Bbox> highlightedBboxes)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.page,_that.ocrStatus,_that.ocrErrorMessage,_that.searchQuery,_that.highlightedBboxes);case _Failure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements PageDetailState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PageDetailState.initial()';
}


}




/// @nodoc


class _Loading implements PageDetailState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PageDetailState.loading()';
}


}




/// @nodoc


class _Success implements PageDetailState {
  const _Success({required this.page, this.ocrStatus = JobStatusEnum.Completed, this.ocrErrorMessage, this.searchQuery = '', final  List<Bbox> highlightedBboxes = const []}): _highlightedBboxes = highlightedBboxes;
  

 final  PageDetail page;
@JsonKey() final  JobStatusEnum ocrStatus;
 final  String? ocrErrorMessage;
// --- START: NEW SEARCH FIELDS ---
// The current search query entered by the user.
@JsonKey() final  String searchQuery;
// A list of all bounding boxes that match the search query.
 final  List<Bbox> _highlightedBboxes;
// A list of all bounding boxes that match the search query.
@JsonKey() List<Bbox> get highlightedBboxes {
  if (_highlightedBboxes is EqualUnmodifiableListView) return _highlightedBboxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlightedBboxes);
}


/// Create a copy of PageDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.page, page) || other.page == page)&&(identical(other.ocrStatus, ocrStatus) || other.ocrStatus == ocrStatus)&&(identical(other.ocrErrorMessage, ocrErrorMessage) || other.ocrErrorMessage == ocrErrorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._highlightedBboxes, _highlightedBboxes));
}


@override
int get hashCode => Object.hash(runtimeType,page,ocrStatus,ocrErrorMessage,searchQuery,const DeepCollectionEquality().hash(_highlightedBboxes));

@override
String toString() {
  return 'PageDetailState.success(page: $page, ocrStatus: $ocrStatus, ocrErrorMessage: $ocrErrorMessage, searchQuery: $searchQuery, highlightedBboxes: $highlightedBboxes)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $PageDetailStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 PageDetail page, JobStatusEnum ocrStatus, String? ocrErrorMessage, String searchQuery, List<Bbox> highlightedBboxes
});


$PageDetailCopyWith<$Res> get page;

}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of PageDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? page = null,Object? ocrStatus = null,Object? ocrErrorMessage = freezed,Object? searchQuery = null,Object? highlightedBboxes = null,}) {
  return _then(_Success(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as PageDetail,ocrStatus: null == ocrStatus ? _self.ocrStatus : ocrStatus // ignore: cast_nullable_to_non_nullable
as JobStatusEnum,ocrErrorMessage: freezed == ocrErrorMessage ? _self.ocrErrorMessage : ocrErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,highlightedBboxes: null == highlightedBboxes ? _self._highlightedBboxes : highlightedBboxes // ignore: cast_nullable_to_non_nullable
as List<Bbox>,
  ));
}

/// Create a copy of PageDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageDetailCopyWith<$Res> get page {
  
  return $PageDetailCopyWith<$Res>(_self.page, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

/// @nodoc


class _Failure implements PageDetailState {
  const _Failure({required this.message});
  

 final  String message;

/// Create a copy of PageDetailState
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
  return 'PageDetailState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $PageDetailStateCopyWith<$Res> {
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

/// Create a copy of PageDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
