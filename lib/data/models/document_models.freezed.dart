// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Document {

 String get documentId; String get title; List<String> get tags;@UnixTimestampConverter() DateTime get createdAt;@UnixTimestampConverter() DateTime get updatedAt; int get pageCount; String? get ownerUserId; String? get thumbnailUrl;
/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCopyWith<Document> get copyWith => _$DocumentCopyWithImpl<Document>(this as Document, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Document&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}


@override
int get hashCode => Object.hash(runtimeType,documentId,title,const DeepCollectionEquality().hash(tags),createdAt,updatedAt,pageCount,ownerUserId,thumbnailUrl);

@override
String toString() {
  return 'Document(documentId: $documentId, title: $title, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, pageCount: $pageCount, ownerUserId: $ownerUserId, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $DocumentCopyWith<$Res>  {
  factory $DocumentCopyWith(Document value, $Res Function(Document) _then) = _$DocumentCopyWithImpl;
@useResult
$Res call({
 String documentId, String title, List<String> tags,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime updatedAt, int pageCount, String? ownerUserId, String? thumbnailUrl
});




}
/// @nodoc
class _$DocumentCopyWithImpl<$Res>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._self, this._then);

  final Document _self;
  final $Res Function(Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? title = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,Object? pageCount = null,Object? ownerUserId = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,ownerUserId: freezed == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Document].
extension DocumentPatterns on Document {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Document value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Document value)  $default,){
final _that = this;
switch (_that) {
case _Document():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Document value)?  $default,){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentId,  String title,  List<String> tags, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime updatedAt,  int pageCount,  String? ownerUserId,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.documentId,_that.title,_that.tags,_that.createdAt,_that.updatedAt,_that.pageCount,_that.ownerUserId,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentId,  String title,  List<String> tags, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime updatedAt,  int pageCount,  String? ownerUserId,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _Document():
return $default(_that.documentId,_that.title,_that.tags,_that.createdAt,_that.updatedAt,_that.pageCount,_that.ownerUserId,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentId,  String title,  List<String> tags, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime updatedAt,  int pageCount,  String? ownerUserId,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.documentId,_that.title,_that.tags,_that.createdAt,_that.updatedAt,_that.pageCount,_that.ownerUserId,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Document implements Document {
  const _Document({required this.documentId, required this.title, final  List<String> tags = const [], @UnixTimestampConverter() required this.createdAt, @UnixTimestampConverter() required this.updatedAt, this.pageCount = 0, this.ownerUserId, this.thumbnailUrl}): _tags = tags;
  

@override final  String documentId;
@override final  String title;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@UnixTimestampConverter() final  DateTime createdAt;
@override@UnixTimestampConverter() final  DateTime updatedAt;
@override@JsonKey() final  int pageCount;
@override final  String? ownerUserId;
@override final  String? thumbnailUrl;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCopyWith<_Document> get copyWith => __$DocumentCopyWithImpl<_Document>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Document&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}


@override
int get hashCode => Object.hash(runtimeType,documentId,title,const DeepCollectionEquality().hash(_tags),createdAt,updatedAt,pageCount,ownerUserId,thumbnailUrl);

@override
String toString() {
  return 'Document(documentId: $documentId, title: $title, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, pageCount: $pageCount, ownerUserId: $ownerUserId, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$DocumentCopyWith<$Res> implements $DocumentCopyWith<$Res> {
  factory _$DocumentCopyWith(_Document value, $Res Function(_Document) _then) = __$DocumentCopyWithImpl;
@override @useResult
$Res call({
 String documentId, String title, List<String> tags,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime updatedAt, int pageCount, String? ownerUserId, String? thumbnailUrl
});




}
/// @nodoc
class __$DocumentCopyWithImpl<$Res>
    implements _$DocumentCopyWith<$Res> {
  __$DocumentCopyWithImpl(this._self, this._then);

  final _Document _self;
  final $Res Function(_Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? title = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,Object? pageCount = null,Object? ownerUserId = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_Document(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,ownerUserId: freezed == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DocumentDetail {

 String get documentId; String get title; List<String> get tags;@UnixTimestampConverter() DateTime get createdAt;@UnixTimestampConverter() DateTime get updatedAt; List<Page> get pages;
/// Create a copy of DocumentDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailCopyWith<DocumentDetail> get copyWith => _$DocumentDetailCopyWithImpl<DocumentDetail>(this as DocumentDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetail&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.pages, pages));
}


@override
int get hashCode => Object.hash(runtimeType,documentId,title,const DeepCollectionEquality().hash(tags),createdAt,updatedAt,const DeepCollectionEquality().hash(pages));

@override
String toString() {
  return 'DocumentDetail(documentId: $documentId, title: $title, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, pages: $pages)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailCopyWith<$Res>  {
  factory $DocumentDetailCopyWith(DocumentDetail value, $Res Function(DocumentDetail) _then) = _$DocumentDetailCopyWithImpl;
@useResult
$Res call({
 String documentId, String title, List<String> tags,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime updatedAt, List<Page> pages
});




}
/// @nodoc
class _$DocumentDetailCopyWithImpl<$Res>
    implements $DocumentDetailCopyWith<$Res> {
  _$DocumentDetailCopyWithImpl(this._self, this._then);

  final DocumentDetail _self;
  final $Res Function(DocumentDetail) _then;

/// Create a copy of DocumentDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? title = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,Object? pages = null,}) {
  return _then(_self.copyWith(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<Page>,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentDetail].
extension DocumentDetailPatterns on DocumentDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentDetail value)  $default,){
final _that = this;
switch (_that) {
case _DocumentDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentDetail value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentId,  String title,  List<String> tags, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime updatedAt,  List<Page> pages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentDetail() when $default != null:
return $default(_that.documentId,_that.title,_that.tags,_that.createdAt,_that.updatedAt,_that.pages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentId,  String title,  List<String> tags, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime updatedAt,  List<Page> pages)  $default,) {final _that = this;
switch (_that) {
case _DocumentDetail():
return $default(_that.documentId,_that.title,_that.tags,_that.createdAt,_that.updatedAt,_that.pages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentId,  String title,  List<String> tags, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime updatedAt,  List<Page> pages)?  $default,) {final _that = this;
switch (_that) {
case _DocumentDetail() when $default != null:
return $default(_that.documentId,_that.title,_that.tags,_that.createdAt,_that.updatedAt,_that.pages);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentDetail implements DocumentDetail {
  const _DocumentDetail({required this.documentId, required this.title, final  List<String> tags = const [], @UnixTimestampConverter() required this.createdAt, @UnixTimestampConverter() required this.updatedAt, final  List<Page> pages = const []}): _tags = tags,_pages = pages;
  

@override final  String documentId;
@override final  String title;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@UnixTimestampConverter() final  DateTime createdAt;
@override@UnixTimestampConverter() final  DateTime updatedAt;
 final  List<Page> _pages;
@override@JsonKey() List<Page> get pages {
  if (_pages is EqualUnmodifiableListView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pages);
}


/// Create a copy of DocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentDetailCopyWith<_DocumentDetail> get copyWith => __$DocumentDetailCopyWithImpl<_DocumentDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentDetail&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._pages, _pages));
}


@override
int get hashCode => Object.hash(runtimeType,documentId,title,const DeepCollectionEquality().hash(_tags),createdAt,updatedAt,const DeepCollectionEquality().hash(_pages));

@override
String toString() {
  return 'DocumentDetail(documentId: $documentId, title: $title, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, pages: $pages)';
}


}

/// @nodoc
abstract mixin class _$DocumentDetailCopyWith<$Res> implements $DocumentDetailCopyWith<$Res> {
  factory _$DocumentDetailCopyWith(_DocumentDetail value, $Res Function(_DocumentDetail) _then) = __$DocumentDetailCopyWithImpl;
@override @useResult
$Res call({
 String documentId, String title, List<String> tags,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime updatedAt, List<Page> pages
});




}
/// @nodoc
class __$DocumentDetailCopyWithImpl<$Res>
    implements _$DocumentDetailCopyWith<$Res> {
  __$DocumentDetailCopyWithImpl(this._self, this._then);

  final _DocumentDetail _self;
  final $Res Function(_DocumentDetail) _then;

/// Create a copy of DocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? title = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,Object? pages = null,}) {
  return _then(_DocumentDetail(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as List<Page>,
  ));
}


}

/// @nodoc
mixin _$DocumentStats {

 int get totalDocuments; int get totalPages;
/// Create a copy of DocumentStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentStatsCopyWith<DocumentStats> get copyWith => _$DocumentStatsCopyWithImpl<DocumentStats>(this as DocumentStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentStats&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,totalDocuments,totalPages);

@override
String toString() {
  return 'DocumentStats(totalDocuments: $totalDocuments, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $DocumentStatsCopyWith<$Res>  {
  factory $DocumentStatsCopyWith(DocumentStats value, $Res Function(DocumentStats) _then) = _$DocumentStatsCopyWithImpl;
@useResult
$Res call({
 int totalDocuments, int totalPages
});




}
/// @nodoc
class _$DocumentStatsCopyWithImpl<$Res>
    implements $DocumentStatsCopyWith<$Res> {
  _$DocumentStatsCopyWithImpl(this._self, this._then);

  final DocumentStats _self;
  final $Res Function(DocumentStats) _then;

/// Create a copy of DocumentStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalDocuments = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
totalDocuments: null == totalDocuments ? _self.totalDocuments : totalDocuments // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentStats].
extension DocumentStatsPatterns on DocumentStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentStats value)  $default,){
final _that = this;
switch (_that) {
case _DocumentStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentStats value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalDocuments,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentStats() when $default != null:
return $default(_that.totalDocuments,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalDocuments,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _DocumentStats():
return $default(_that.totalDocuments,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalDocuments,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _DocumentStats() when $default != null:
return $default(_that.totalDocuments,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentStats implements DocumentStats {
  const _DocumentStats({required this.totalDocuments, required this.totalPages});
  

@override final  int totalDocuments;
@override final  int totalPages;

/// Create a copy of DocumentStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentStatsCopyWith<_DocumentStats> get copyWith => __$DocumentStatsCopyWithImpl<_DocumentStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentStats&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,totalDocuments,totalPages);

@override
String toString() {
  return 'DocumentStats(totalDocuments: $totalDocuments, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$DocumentStatsCopyWith<$Res> implements $DocumentStatsCopyWith<$Res> {
  factory _$DocumentStatsCopyWith(_DocumentStats value, $Res Function(_DocumentStats) _then) = __$DocumentStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalDocuments, int totalPages
});




}
/// @nodoc
class __$DocumentStatsCopyWithImpl<$Res>
    implements _$DocumentStatsCopyWith<$Res> {
  __$DocumentStatsCopyWithImpl(this._self, this._then);

  final _DocumentStats _self;
  final $Res Function(_DocumentStats) _then;

/// Create a copy of DocumentStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalDocuments = null,Object? totalPages = null,}) {
  return _then(_DocumentStats(
totalDocuments: null == totalDocuments ? _self.totalDocuments : totalDocuments // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
