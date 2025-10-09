// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResultItem {

 SearchResultType get type; String get documentId; String get documentTitle;// Reverted to required
 String? get pageId; String? get pageTitle;// Reverted to pageTitle
 String get matchSnippet;
/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultItemCopyWith<SearchResultItem> get copyWith => _$SearchResultItemCopyWithImpl<SearchResultItem>(this as SearchResultItem, _$identity);

  /// Serializes this SearchResultItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultItem&&(identical(other.type, type) || other.type == type)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.documentTitle, documentTitle) || other.documentTitle == documentTitle)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.pageTitle, pageTitle) || other.pageTitle == pageTitle)&&(identical(other.matchSnippet, matchSnippet) || other.matchSnippet == matchSnippet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,documentId,documentTitle,pageId,pageTitle,matchSnippet);

@override
String toString() {
  return 'SearchResultItem(type: $type, documentId: $documentId, documentTitle: $documentTitle, pageId: $pageId, pageTitle: $pageTitle, matchSnippet: $matchSnippet)';
}


}

/// @nodoc
abstract mixin class $SearchResultItemCopyWith<$Res>  {
  factory $SearchResultItemCopyWith(SearchResultItem value, $Res Function(SearchResultItem) _then) = _$SearchResultItemCopyWithImpl;
@useResult
$Res call({
 SearchResultType type, String documentId, String documentTitle, String? pageId, String? pageTitle, String matchSnippet
});




}
/// @nodoc
class _$SearchResultItemCopyWithImpl<$Res>
    implements $SearchResultItemCopyWith<$Res> {
  _$SearchResultItemCopyWithImpl(this._self, this._then);

  final SearchResultItem _self;
  final $Res Function(SearchResultItem) _then;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? documentId = null,Object? documentTitle = null,Object? pageId = freezed,Object? pageTitle = freezed,Object? matchSnippet = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SearchResultType,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,documentTitle: null == documentTitle ? _self.documentTitle : documentTitle // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,pageTitle: freezed == pageTitle ? _self.pageTitle : pageTitle // ignore: cast_nullable_to_non_nullable
as String?,matchSnippet: null == matchSnippet ? _self.matchSnippet : matchSnippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResultItem].
extension SearchResultItemPatterns on SearchResultItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResultItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResultItem value)  $default,){
final _that = this;
switch (_that) {
case _SearchResultItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResultItem value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchResultType type,  String documentId,  String documentTitle,  String? pageId,  String? pageTitle,  String matchSnippet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
return $default(_that.type,_that.documentId,_that.documentTitle,_that.pageId,_that.pageTitle,_that.matchSnippet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchResultType type,  String documentId,  String documentTitle,  String? pageId,  String? pageTitle,  String matchSnippet)  $default,) {final _that = this;
switch (_that) {
case _SearchResultItem():
return $default(_that.type,_that.documentId,_that.documentTitle,_that.pageId,_that.pageTitle,_that.matchSnippet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchResultType type,  String documentId,  String documentTitle,  String? pageId,  String? pageTitle,  String matchSnippet)?  $default,) {final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
return $default(_that.type,_that.documentId,_that.documentTitle,_that.pageId,_that.pageTitle,_that.matchSnippet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResultItem implements SearchResultItem {
  const _SearchResultItem({required this.type, required this.documentId, required this.documentTitle, this.pageId, this.pageTitle, required this.matchSnippet});
  factory _SearchResultItem.fromJson(Map<String, dynamic> json) => _$SearchResultItemFromJson(json);

@override final  SearchResultType type;
@override final  String documentId;
@override final  String documentTitle;
// Reverted to required
@override final  String? pageId;
@override final  String? pageTitle;
// Reverted to pageTitle
@override final  String matchSnippet;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultItemCopyWith<_SearchResultItem> get copyWith => __$SearchResultItemCopyWithImpl<_SearchResultItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultItem&&(identical(other.type, type) || other.type == type)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.documentTitle, documentTitle) || other.documentTitle == documentTitle)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.pageTitle, pageTitle) || other.pageTitle == pageTitle)&&(identical(other.matchSnippet, matchSnippet) || other.matchSnippet == matchSnippet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,documentId,documentTitle,pageId,pageTitle,matchSnippet);

@override
String toString() {
  return 'SearchResultItem(type: $type, documentId: $documentId, documentTitle: $documentTitle, pageId: $pageId, pageTitle: $pageTitle, matchSnippet: $matchSnippet)';
}


}

/// @nodoc
abstract mixin class _$SearchResultItemCopyWith<$Res> implements $SearchResultItemCopyWith<$Res> {
  factory _$SearchResultItemCopyWith(_SearchResultItem value, $Res Function(_SearchResultItem) _then) = __$SearchResultItemCopyWithImpl;
@override @useResult
$Res call({
 SearchResultType type, String documentId, String documentTitle, String? pageId, String? pageTitle, String matchSnippet
});




}
/// @nodoc
class __$SearchResultItemCopyWithImpl<$Res>
    implements _$SearchResultItemCopyWith<$Res> {
  __$SearchResultItemCopyWithImpl(this._self, this._then);

  final _SearchResultItem _self;
  final $Res Function(_SearchResultItem) _then;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? documentId = null,Object? documentTitle = null,Object? pageId = freezed,Object? pageTitle = freezed,Object? matchSnippet = null,}) {
  return _then(_SearchResultItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SearchResultType,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,documentTitle: null == documentTitle ? _self.documentTitle : documentTitle // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,pageTitle: freezed == pageTitle ? _self.pageTitle : pageTitle // ignore: cast_nullable_to_non_nullable
as String?,matchSnippet: null == matchSnippet ? _self.matchSnippet : matchSnippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
