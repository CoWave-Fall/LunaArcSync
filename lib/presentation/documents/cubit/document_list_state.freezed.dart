// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentListState {

// Core list properties
 List<Document> get documents; bool get isLoading; String? get error; int get pageNumber; bool get hasReachedMax;// --- START: NEW SORTING AND FILTERING STATE ---
// Sorting
 SortOption get sortOption;// Tag Filtering
 List<String> get selectedTags; List<String> get allTags; bool get areTagsLoading; String? get tagsError;// --- END: NEW SORTING AND FILTERING STATE ---
// --- START: USER INFO CACHE FOR ADMIN ---
// 用户信息缓存（userId -> UserDto）
 Map<String, UserDto> get userInfoCache;
/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentListStateCopyWith<DocumentListState> get copyWith => _$DocumentListStateCopyWithImpl<DocumentListState>(this as DocumentListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentListState&&const DeepCollectionEquality().equals(other.documents, documents)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption)&&const DeepCollectionEquality().equals(other.selectedTags, selectedTags)&&const DeepCollectionEquality().equals(other.allTags, allTags)&&(identical(other.areTagsLoading, areTagsLoading) || other.areTagsLoading == areTagsLoading)&&(identical(other.tagsError, tagsError) || other.tagsError == tagsError)&&const DeepCollectionEquality().equals(other.userInfoCache, userInfoCache));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(documents),isLoading,error,pageNumber,hasReachedMax,sortOption,const DeepCollectionEquality().hash(selectedTags),const DeepCollectionEquality().hash(allTags),areTagsLoading,tagsError,const DeepCollectionEquality().hash(userInfoCache));

@override
String toString() {
  return 'DocumentListState(documents: $documents, isLoading: $isLoading, error: $error, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, sortOption: $sortOption, selectedTags: $selectedTags, allTags: $allTags, areTagsLoading: $areTagsLoading, tagsError: $tagsError, userInfoCache: $userInfoCache)';
}


}

/// @nodoc
abstract mixin class $DocumentListStateCopyWith<$Res>  {
  factory $DocumentListStateCopyWith(DocumentListState value, $Res Function(DocumentListState) _then) = _$DocumentListStateCopyWithImpl;
@useResult
$Res call({
 List<Document> documents, bool isLoading, String? error, int pageNumber, bool hasReachedMax, SortOption sortOption, List<String> selectedTags, List<String> allTags, bool areTagsLoading, String? tagsError, Map<String, UserDto> userInfoCache
});




}
/// @nodoc
class _$DocumentListStateCopyWithImpl<$Res>
    implements $DocumentListStateCopyWith<$Res> {
  _$DocumentListStateCopyWithImpl(this._self, this._then);

  final DocumentListState _self;
  final $Res Function(DocumentListState) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documents = null,Object? isLoading = null,Object? error = freezed,Object? pageNumber = null,Object? hasReachedMax = null,Object? sortOption = null,Object? selectedTags = null,Object? allTags = null,Object? areTagsLoading = null,Object? tagsError = freezed,Object? userInfoCache = null,}) {
  return _then(_self.copyWith(
documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<Document>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,sortOption: null == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as SortOption,selectedTags: null == selectedTags ? _self.selectedTags : selectedTags // ignore: cast_nullable_to_non_nullable
as List<String>,allTags: null == allTags ? _self.allTags : allTags // ignore: cast_nullable_to_non_nullable
as List<String>,areTagsLoading: null == areTagsLoading ? _self.areTagsLoading : areTagsLoading // ignore: cast_nullable_to_non_nullable
as bool,tagsError: freezed == tagsError ? _self.tagsError : tagsError // ignore: cast_nullable_to_non_nullable
as String?,userInfoCache: null == userInfoCache ? _self.userInfoCache : userInfoCache // ignore: cast_nullable_to_non_nullable
as Map<String, UserDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentListState].
extension DocumentListStatePatterns on DocumentListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentListState value)  $default,){
final _that = this;
switch (_that) {
case _DocumentListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentListState value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Document> documents,  bool isLoading,  String? error,  int pageNumber,  bool hasReachedMax,  SortOption sortOption,  List<String> selectedTags,  List<String> allTags,  bool areTagsLoading,  String? tagsError,  Map<String, UserDto> userInfoCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentListState() when $default != null:
return $default(_that.documents,_that.isLoading,_that.error,_that.pageNumber,_that.hasReachedMax,_that.sortOption,_that.selectedTags,_that.allTags,_that.areTagsLoading,_that.tagsError,_that.userInfoCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Document> documents,  bool isLoading,  String? error,  int pageNumber,  bool hasReachedMax,  SortOption sortOption,  List<String> selectedTags,  List<String> allTags,  bool areTagsLoading,  String? tagsError,  Map<String, UserDto> userInfoCache)  $default,) {final _that = this;
switch (_that) {
case _DocumentListState():
return $default(_that.documents,_that.isLoading,_that.error,_that.pageNumber,_that.hasReachedMax,_that.sortOption,_that.selectedTags,_that.allTags,_that.areTagsLoading,_that.tagsError,_that.userInfoCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Document> documents,  bool isLoading,  String? error,  int pageNumber,  bool hasReachedMax,  SortOption sortOption,  List<String> selectedTags,  List<String> allTags,  bool areTagsLoading,  String? tagsError,  Map<String, UserDto> userInfoCache)?  $default,) {final _that = this;
switch (_that) {
case _DocumentListState() when $default != null:
return $default(_that.documents,_that.isLoading,_that.error,_that.pageNumber,_that.hasReachedMax,_that.sortOption,_that.selectedTags,_that.allTags,_that.areTagsLoading,_that.tagsError,_that.userInfoCache);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentListState implements DocumentListState {
  const _DocumentListState({final  List<Document> documents = const [], this.isLoading = false, this.error = null, this.pageNumber = 1, this.hasReachedMax = false, this.sortOption = SortOption.dateDesc, final  List<String> selectedTags = const [], final  List<String> allTags = const [], this.areTagsLoading = false, this.tagsError = null, final  Map<String, UserDto> userInfoCache = const {}}): _documents = documents,_selectedTags = selectedTags,_allTags = allTags,_userInfoCache = userInfoCache;
  

// Core list properties
 final  List<Document> _documents;
// Core list properties
@override@JsonKey() List<Document> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String? error;
@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  bool hasReachedMax;
// --- START: NEW SORTING AND FILTERING STATE ---
// Sorting
@override@JsonKey() final  SortOption sortOption;
// Tag Filtering
 final  List<String> _selectedTags;
// Tag Filtering
@override@JsonKey() List<String> get selectedTags {
  if (_selectedTags is EqualUnmodifiableListView) return _selectedTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedTags);
}

 final  List<String> _allTags;
@override@JsonKey() List<String> get allTags {
  if (_allTags is EqualUnmodifiableListView) return _allTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allTags);
}

@override@JsonKey() final  bool areTagsLoading;
@override@JsonKey() final  String? tagsError;
// --- END: NEW SORTING AND FILTERING STATE ---
// --- START: USER INFO CACHE FOR ADMIN ---
// 用户信息缓存（userId -> UserDto）
 final  Map<String, UserDto> _userInfoCache;
// --- END: NEW SORTING AND FILTERING STATE ---
// --- START: USER INFO CACHE FOR ADMIN ---
// 用户信息缓存（userId -> UserDto）
@override@JsonKey() Map<String, UserDto> get userInfoCache {
  if (_userInfoCache is EqualUnmodifiableMapView) return _userInfoCache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_userInfoCache);
}


/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentListStateCopyWith<_DocumentListState> get copyWith => __$DocumentListStateCopyWithImpl<_DocumentListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentListState&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption)&&const DeepCollectionEquality().equals(other._selectedTags, _selectedTags)&&const DeepCollectionEquality().equals(other._allTags, _allTags)&&(identical(other.areTagsLoading, areTagsLoading) || other.areTagsLoading == areTagsLoading)&&(identical(other.tagsError, tagsError) || other.tagsError == tagsError)&&const DeepCollectionEquality().equals(other._userInfoCache, _userInfoCache));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_documents),isLoading,error,pageNumber,hasReachedMax,sortOption,const DeepCollectionEquality().hash(_selectedTags),const DeepCollectionEquality().hash(_allTags),areTagsLoading,tagsError,const DeepCollectionEquality().hash(_userInfoCache));

@override
String toString() {
  return 'DocumentListState(documents: $documents, isLoading: $isLoading, error: $error, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, sortOption: $sortOption, selectedTags: $selectedTags, allTags: $allTags, areTagsLoading: $areTagsLoading, tagsError: $tagsError, userInfoCache: $userInfoCache)';
}


}

/// @nodoc
abstract mixin class _$DocumentListStateCopyWith<$Res> implements $DocumentListStateCopyWith<$Res> {
  factory _$DocumentListStateCopyWith(_DocumentListState value, $Res Function(_DocumentListState) _then) = __$DocumentListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Document> documents, bool isLoading, String? error, int pageNumber, bool hasReachedMax, SortOption sortOption, List<String> selectedTags, List<String> allTags, bool areTagsLoading, String? tagsError, Map<String, UserDto> userInfoCache
});




}
/// @nodoc
class __$DocumentListStateCopyWithImpl<$Res>
    implements _$DocumentListStateCopyWith<$Res> {
  __$DocumentListStateCopyWithImpl(this._self, this._then);

  final _DocumentListState _self;
  final $Res Function(_DocumentListState) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documents = null,Object? isLoading = null,Object? error = freezed,Object? pageNumber = null,Object? hasReachedMax = null,Object? sortOption = null,Object? selectedTags = null,Object? allTags = null,Object? areTagsLoading = null,Object? tagsError = freezed,Object? userInfoCache = null,}) {
  return _then(_DocumentListState(
documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<Document>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,sortOption: null == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as SortOption,selectedTags: null == selectedTags ? _self._selectedTags : selectedTags // ignore: cast_nullable_to_non_nullable
as List<String>,allTags: null == allTags ? _self._allTags : allTags // ignore: cast_nullable_to_non_nullable
as List<String>,areTagsLoading: null == areTagsLoading ? _self.areTagsLoading : areTagsLoading // ignore: cast_nullable_to_non_nullable
as bool,tagsError: freezed == tagsError ? _self.tagsError : tagsError // ignore: cast_nullable_to_non_nullable
as String?,userInfoCache: null == userInfoCache ? _self._userInfoCache : userInfoCache // ignore: cast_nullable_to_non_nullable
as Map<String, UserDto>,
  ));
}


}

// dart format on
