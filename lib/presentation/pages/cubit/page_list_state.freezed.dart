// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PageListState {

 PageListStatus get status; List<Page> get pages; int get pageNumber; bool get hasReachedMax; String? get errorMessage;
/// Create a copy of PageListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageListStateCopyWith<PageListState> get copyWith => _$PageListStateCopyWithImpl<PageListState>(this as PageListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(pages),pageNumber,hasReachedMax,errorMessage);

@override
String toString() {
  return 'PageListState(status: $status, pages: $pages, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PageListStateCopyWith<$Res>  {
  factory $PageListStateCopyWith(PageListState value, $Res Function(PageListState) _then) = _$PageListStateCopyWithImpl;
@useResult
$Res call({
 PageListStatus status, List<Page> pages, int pageNumber, bool hasReachedMax, String? errorMessage
});




}
/// @nodoc
class _$PageListStateCopyWithImpl<$Res>
    implements $PageListStateCopyWith<$Res> {
  _$PageListStateCopyWithImpl(this._self, this._then);

  final PageListState _self;
  final $Res Function(PageListState) _then;

/// Create a copy of PageListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? pages = null,Object? pageNumber = null,Object? hasReachedMax = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PageListStatus,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<Page>,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PageListState].
extension PageListStatePatterns on PageListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageListState value)  $default,){
final _that = this;
switch (_that) {
case _PageListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageListState value)?  $default,){
final _that = this;
switch (_that) {
case _PageListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PageListStatus status,  List<Page> pages,  int pageNumber,  bool hasReachedMax,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageListState() when $default != null:
return $default(_that.status,_that.pages,_that.pageNumber,_that.hasReachedMax,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PageListStatus status,  List<Page> pages,  int pageNumber,  bool hasReachedMax,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PageListState():
return $default(_that.status,_that.pages,_that.pageNumber,_that.hasReachedMax,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PageListStatus status,  List<Page> pages,  int pageNumber,  bool hasReachedMax,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PageListState() when $default != null:
return $default(_that.status,_that.pages,_that.pageNumber,_that.hasReachedMax,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PageListState implements PageListState {
  const _PageListState({this.status = PageListStatus.initial, final  List<Page> pages = const [], this.pageNumber = 1, this.hasReachedMax = false, this.errorMessage}): _pages = pages;
  

@override@JsonKey() final  PageListStatus status;
 final  List<Page> _pages;
@override@JsonKey() List<Page> get pages {
  if (_pages is EqualUnmodifiableListView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pages);
}

@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  bool hasReachedMax;
@override final  String? errorMessage;

/// Create a copy of PageListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageListStateCopyWith<_PageListState> get copyWith => __$PageListStateCopyWithImpl<_PageListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._pages, _pages)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_pages),pageNumber,hasReachedMax,errorMessage);

@override
String toString() {
  return 'PageListState(status: $status, pages: $pages, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PageListStateCopyWith<$Res> implements $PageListStateCopyWith<$Res> {
  factory _$PageListStateCopyWith(_PageListState value, $Res Function(_PageListState) _then) = __$PageListStateCopyWithImpl;
@override @useResult
$Res call({
 PageListStatus status, List<Page> pages, int pageNumber, bool hasReachedMax, String? errorMessage
});




}
/// @nodoc
class __$PageListStateCopyWithImpl<$Res>
    implements _$PageListStateCopyWith<$Res> {
  __$PageListStateCopyWithImpl(this._self, this._then);

  final _PageListState _self;
  final $Res Function(_PageListState) _then;

/// Create a copy of PageListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? pages = null,Object? pageNumber = null,Object? hasReachedMax = null,Object? errorMessage = freezed,}) {
  return _then(_PageListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PageListStatus,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as List<Page>,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
