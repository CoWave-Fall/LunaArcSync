// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Page {

 String get pageId; String get title;@HighPrecisionDateTimeConverter() DateTime get createdAt;@HighPrecisionDateTimeConverter() DateTime get updatedAt; int get order;// 新增 order 字段
 String? get thumbnailUrl;
/// Create a copy of Page
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageCopyWith<Page> get copyWith => _$PageCopyWithImpl<Page>(this as Page, _$identity);

  /// Serializes this Page to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Page&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.order, order) || other.order == order)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageId,title,createdAt,updatedAt,order,thumbnailUrl);

@override
String toString() {
  return 'Page(pageId: $pageId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, order: $order, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $PageCopyWith<$Res>  {
  factory $PageCopyWith(Page value, $Res Function(Page) _then) = _$PageCopyWithImpl;
@useResult
$Res call({
 String pageId, String title,@HighPrecisionDateTimeConverter() DateTime createdAt,@HighPrecisionDateTimeConverter() DateTime updatedAt, int order, String? thumbnailUrl
});




}
/// @nodoc
class _$PageCopyWithImpl<$Res>
    implements $PageCopyWith<$Res> {
  _$PageCopyWithImpl(this._self, this._then);

  final Page _self;
  final $Res Function(Page) _then;

/// Create a copy of Page
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? order = null,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Page].
extension PagePatterns on Page {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Page value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Page() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Page value)  $default,){
final _that = this;
switch (_that) {
case _Page():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Page value)?  $default,){
final _that = this;
switch (_that) {
case _Page() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pageId,  String title, @HighPrecisionDateTimeConverter()  DateTime createdAt, @HighPrecisionDateTimeConverter()  DateTime updatedAt,  int order,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Page() when $default != null:
return $default(_that.pageId,_that.title,_that.createdAt,_that.updatedAt,_that.order,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pageId,  String title, @HighPrecisionDateTimeConverter()  DateTime createdAt, @HighPrecisionDateTimeConverter()  DateTime updatedAt,  int order,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _Page():
return $default(_that.pageId,_that.title,_that.createdAt,_that.updatedAt,_that.order,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pageId,  String title, @HighPrecisionDateTimeConverter()  DateTime createdAt, @HighPrecisionDateTimeConverter()  DateTime updatedAt,  int order,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _Page() when $default != null:
return $default(_that.pageId,_that.title,_that.createdAt,_that.updatedAt,_that.order,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Page implements Page {
  const _Page({required this.pageId, required this.title, @HighPrecisionDateTimeConverter() required this.createdAt, @HighPrecisionDateTimeConverter() required this.updatedAt, this.order = 0, this.thumbnailUrl});
  factory _Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

@override final  String pageId;
@override final  String title;
@override@HighPrecisionDateTimeConverter() final  DateTime createdAt;
@override@HighPrecisionDateTimeConverter() final  DateTime updatedAt;
@override@JsonKey() final  int order;
// 新增 order 字段
@override final  String? thumbnailUrl;

/// Create a copy of Page
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageCopyWith<_Page> get copyWith => __$PageCopyWithImpl<_Page>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Page&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.order, order) || other.order == order)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageId,title,createdAt,updatedAt,order,thumbnailUrl);

@override
String toString() {
  return 'Page(pageId: $pageId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, order: $order, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$PageCopyWith<$Res> implements $PageCopyWith<$Res> {
  factory _$PageCopyWith(_Page value, $Res Function(_Page) _then) = __$PageCopyWithImpl;
@override @useResult
$Res call({
 String pageId, String title,@HighPrecisionDateTimeConverter() DateTime createdAt,@HighPrecisionDateTimeConverter() DateTime updatedAt, int order, String? thumbnailUrl
});




}
/// @nodoc
class __$PageCopyWithImpl<$Res>
    implements _$PageCopyWith<$Res> {
  __$PageCopyWithImpl(this._self, this._then);

  final _Page _self;
  final $Res Function(_Page) _then;

/// Create a copy of Page
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? order = null,Object? thumbnailUrl = freezed,}) {
  return _then(_Page(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Bbox {

 int get x1; int get y1; int get x2; int get y2;// 标准化坐标 (0-1 之间)，相对于图片宽高的比例
// 如果后端提供了这些字段，优先使用它们进行渲染
 double? get normalizedX1; double? get normalizedY1; double? get normalizedX2; double? get normalizedY2;
/// Create a copy of Bbox
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BboxCopyWith<Bbox> get copyWith => _$BboxCopyWithImpl<Bbox>(this as Bbox, _$identity);

  /// Serializes this Bbox to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bbox&&(identical(other.x1, x1) || other.x1 == x1)&&(identical(other.y1, y1) || other.y1 == y1)&&(identical(other.x2, x2) || other.x2 == x2)&&(identical(other.y2, y2) || other.y2 == y2)&&(identical(other.normalizedX1, normalizedX1) || other.normalizedX1 == normalizedX1)&&(identical(other.normalizedY1, normalizedY1) || other.normalizedY1 == normalizedY1)&&(identical(other.normalizedX2, normalizedX2) || other.normalizedX2 == normalizedX2)&&(identical(other.normalizedY2, normalizedY2) || other.normalizedY2 == normalizedY2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x1,y1,x2,y2,normalizedX1,normalizedY1,normalizedX2,normalizedY2);

@override
String toString() {
  return 'Bbox(x1: $x1, y1: $y1, x2: $x2, y2: $y2, normalizedX1: $normalizedX1, normalizedY1: $normalizedY1, normalizedX2: $normalizedX2, normalizedY2: $normalizedY2)';
}


}

/// @nodoc
abstract mixin class $BboxCopyWith<$Res>  {
  factory $BboxCopyWith(Bbox value, $Res Function(Bbox) _then) = _$BboxCopyWithImpl;
@useResult
$Res call({
 int x1, int y1, int x2, int y2, double? normalizedX1, double? normalizedY1, double? normalizedX2, double? normalizedY2
});




}
/// @nodoc
class _$BboxCopyWithImpl<$Res>
    implements $BboxCopyWith<$Res> {
  _$BboxCopyWithImpl(this._self, this._then);

  final Bbox _self;
  final $Res Function(Bbox) _then;

/// Create a copy of Bbox
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x1 = null,Object? y1 = null,Object? x2 = null,Object? y2 = null,Object? normalizedX1 = freezed,Object? normalizedY1 = freezed,Object? normalizedX2 = freezed,Object? normalizedY2 = freezed,}) {
  return _then(_self.copyWith(
x1: null == x1 ? _self.x1 : x1 // ignore: cast_nullable_to_non_nullable
as int,y1: null == y1 ? _self.y1 : y1 // ignore: cast_nullable_to_non_nullable
as int,x2: null == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as int,y2: null == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as int,normalizedX1: freezed == normalizedX1 ? _self.normalizedX1 : normalizedX1 // ignore: cast_nullable_to_non_nullable
as double?,normalizedY1: freezed == normalizedY1 ? _self.normalizedY1 : normalizedY1 // ignore: cast_nullable_to_non_nullable
as double?,normalizedX2: freezed == normalizedX2 ? _self.normalizedX2 : normalizedX2 // ignore: cast_nullable_to_non_nullable
as double?,normalizedY2: freezed == normalizedY2 ? _self.normalizedY2 : normalizedY2 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Bbox].
extension BboxPatterns on Bbox {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bbox value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bbox() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bbox value)  $default,){
final _that = this;
switch (_that) {
case _Bbox():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bbox value)?  $default,){
final _that = this;
switch (_that) {
case _Bbox() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int x1,  int y1,  int x2,  int y2,  double? normalizedX1,  double? normalizedY1,  double? normalizedX2,  double? normalizedY2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bbox() when $default != null:
return $default(_that.x1,_that.y1,_that.x2,_that.y2,_that.normalizedX1,_that.normalizedY1,_that.normalizedX2,_that.normalizedY2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int x1,  int y1,  int x2,  int y2,  double? normalizedX1,  double? normalizedY1,  double? normalizedX2,  double? normalizedY2)  $default,) {final _that = this;
switch (_that) {
case _Bbox():
return $default(_that.x1,_that.y1,_that.x2,_that.y2,_that.normalizedX1,_that.normalizedY1,_that.normalizedX2,_that.normalizedY2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int x1,  int y1,  int x2,  int y2,  double? normalizedX1,  double? normalizedY1,  double? normalizedX2,  double? normalizedY2)?  $default,) {final _that = this;
switch (_that) {
case _Bbox() when $default != null:
return $default(_that.x1,_that.y1,_that.x2,_that.y2,_that.normalizedX1,_that.normalizedY1,_that.normalizedX2,_that.normalizedY2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bbox implements Bbox {
  const _Bbox({required this.x1, required this.y1, required this.x2, required this.y2, this.normalizedX1, this.normalizedY1, this.normalizedX2, this.normalizedY2});
  factory _Bbox.fromJson(Map<String, dynamic> json) => _$BboxFromJson(json);

@override final  int x1;
@override final  int y1;
@override final  int x2;
@override final  int y2;
// 标准化坐标 (0-1 之间)，相对于图片宽高的比例
// 如果后端提供了这些字段，优先使用它们进行渲染
@override final  double? normalizedX1;
@override final  double? normalizedY1;
@override final  double? normalizedX2;
@override final  double? normalizedY2;

/// Create a copy of Bbox
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BboxCopyWith<_Bbox> get copyWith => __$BboxCopyWithImpl<_Bbox>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BboxToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bbox&&(identical(other.x1, x1) || other.x1 == x1)&&(identical(other.y1, y1) || other.y1 == y1)&&(identical(other.x2, x2) || other.x2 == x2)&&(identical(other.y2, y2) || other.y2 == y2)&&(identical(other.normalizedX1, normalizedX1) || other.normalizedX1 == normalizedX1)&&(identical(other.normalizedY1, normalizedY1) || other.normalizedY1 == normalizedY1)&&(identical(other.normalizedX2, normalizedX2) || other.normalizedX2 == normalizedX2)&&(identical(other.normalizedY2, normalizedY2) || other.normalizedY2 == normalizedY2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x1,y1,x2,y2,normalizedX1,normalizedY1,normalizedX2,normalizedY2);

@override
String toString() {
  return 'Bbox(x1: $x1, y1: $y1, x2: $x2, y2: $y2, normalizedX1: $normalizedX1, normalizedY1: $normalizedY1, normalizedX2: $normalizedX2, normalizedY2: $normalizedY2)';
}


}

/// @nodoc
abstract mixin class _$BboxCopyWith<$Res> implements $BboxCopyWith<$Res> {
  factory _$BboxCopyWith(_Bbox value, $Res Function(_Bbox) _then) = __$BboxCopyWithImpl;
@override @useResult
$Res call({
 int x1, int y1, int x2, int y2, double? normalizedX1, double? normalizedY1, double? normalizedX2, double? normalizedY2
});




}
/// @nodoc
class __$BboxCopyWithImpl<$Res>
    implements _$BboxCopyWith<$Res> {
  __$BboxCopyWithImpl(this._self, this._then);

  final _Bbox _self;
  final $Res Function(_Bbox) _then;

/// Create a copy of Bbox
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x1 = null,Object? y1 = null,Object? x2 = null,Object? y2 = null,Object? normalizedX1 = freezed,Object? normalizedY1 = freezed,Object? normalizedX2 = freezed,Object? normalizedY2 = freezed,}) {
  return _then(_Bbox(
x1: null == x1 ? _self.x1 : x1 // ignore: cast_nullable_to_non_nullable
as int,y1: null == y1 ? _self.y1 : y1 // ignore: cast_nullable_to_non_nullable
as int,x2: null == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as int,y2: null == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as int,normalizedX1: freezed == normalizedX1 ? _self.normalizedX1 : normalizedX1 // ignore: cast_nullable_to_non_nullable
as double?,normalizedY1: freezed == normalizedY1 ? _self.normalizedY1 : normalizedY1 // ignore: cast_nullable_to_non_nullable
as double?,normalizedX2: freezed == normalizedX2 ? _self.normalizedX2 : normalizedX2 // ignore: cast_nullable_to_non_nullable
as double?,normalizedY2: freezed == normalizedY2 ? _self.normalizedY2 : normalizedY2 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$OcrWord {

 String get text; Bbox get bbox; double get confidence;
/// Create a copy of OcrWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrWordCopyWith<OcrWord> get copyWith => _$OcrWordCopyWithImpl<OcrWord>(this as OcrWord, _$identity);

  /// Serializes this OcrWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrWord&&(identical(other.text, text) || other.text == text)&&(identical(other.bbox, bbox) || other.bbox == bbox)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,bbox,confidence);

@override
String toString() {
  return 'OcrWord(text: $text, bbox: $bbox, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $OcrWordCopyWith<$Res>  {
  factory $OcrWordCopyWith(OcrWord value, $Res Function(OcrWord) _then) = _$OcrWordCopyWithImpl;
@useResult
$Res call({
 String text, Bbox bbox, double confidence
});


$BboxCopyWith<$Res> get bbox;

}
/// @nodoc
class _$OcrWordCopyWithImpl<$Res>
    implements $OcrWordCopyWith<$Res> {
  _$OcrWordCopyWithImpl(this._self, this._then);

  final OcrWord _self;
  final $Res Function(OcrWord) _then;

/// Create a copy of OcrWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? bbox = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,bbox: null == bbox ? _self.bbox : bbox // ignore: cast_nullable_to_non_nullable
as Bbox,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of OcrWord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BboxCopyWith<$Res> get bbox {
  
  return $BboxCopyWith<$Res>(_self.bbox, (value) {
    return _then(_self.copyWith(bbox: value));
  });
}
}


/// Adds pattern-matching-related methods to [OcrWord].
extension OcrWordPatterns on OcrWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrWord value)  $default,){
final _that = this;
switch (_that) {
case _OcrWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrWord value)?  $default,){
final _that = this;
switch (_that) {
case _OcrWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  Bbox bbox,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrWord() when $default != null:
return $default(_that.text,_that.bbox,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  Bbox bbox,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _OcrWord():
return $default(_that.text,_that.bbox,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  Bbox bbox,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _OcrWord() when $default != null:
return $default(_that.text,_that.bbox,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OcrWord implements OcrWord {
  const _OcrWord({required this.text, required this.bbox, required this.confidence});
  factory _OcrWord.fromJson(Map<String, dynamic> json) => _$OcrWordFromJson(json);

@override final  String text;
@override final  Bbox bbox;
@override final  double confidence;

/// Create a copy of OcrWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrWordCopyWith<_OcrWord> get copyWith => __$OcrWordCopyWithImpl<_OcrWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrWord&&(identical(other.text, text) || other.text == text)&&(identical(other.bbox, bbox) || other.bbox == bbox)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,bbox,confidence);

@override
String toString() {
  return 'OcrWord(text: $text, bbox: $bbox, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$OcrWordCopyWith<$Res> implements $OcrWordCopyWith<$Res> {
  factory _$OcrWordCopyWith(_OcrWord value, $Res Function(_OcrWord) _then) = __$OcrWordCopyWithImpl;
@override @useResult
$Res call({
 String text, Bbox bbox, double confidence
});


@override $BboxCopyWith<$Res> get bbox;

}
/// @nodoc
class __$OcrWordCopyWithImpl<$Res>
    implements _$OcrWordCopyWith<$Res> {
  __$OcrWordCopyWithImpl(this._self, this._then);

  final _OcrWord _self;
  final $Res Function(_OcrWord) _then;

/// Create a copy of OcrWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? bbox = null,Object? confidence = null,}) {
  return _then(_OcrWord(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,bbox: null == bbox ? _self.bbox : bbox // ignore: cast_nullable_to_non_nullable
as Bbox,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of OcrWord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BboxCopyWith<$Res> get bbox {
  
  return $BboxCopyWith<$Res>(_self.bbox, (value) {
    return _then(_self.copyWith(bbox: value));
  });
}
}


/// @nodoc
mixin _$OcrLine {

 List<OcrWord> get words; String get text; Bbox get bbox;
/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrLineCopyWith<OcrLine> get copyWith => _$OcrLineCopyWithImpl<OcrLine>(this as OcrLine, _$identity);

  /// Serializes this OcrLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrLine&&const DeepCollectionEquality().equals(other.words, words)&&(identical(other.text, text) || other.text == text)&&(identical(other.bbox, bbox) || other.bbox == bbox));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(words),text,bbox);

@override
String toString() {
  return 'OcrLine(words: $words, text: $text, bbox: $bbox)';
}


}

/// @nodoc
abstract mixin class $OcrLineCopyWith<$Res>  {
  factory $OcrLineCopyWith(OcrLine value, $Res Function(OcrLine) _then) = _$OcrLineCopyWithImpl;
@useResult
$Res call({
 List<OcrWord> words, String text, Bbox bbox
});


$BboxCopyWith<$Res> get bbox;

}
/// @nodoc
class _$OcrLineCopyWithImpl<$Res>
    implements $OcrLineCopyWith<$Res> {
  _$OcrLineCopyWithImpl(this._self, this._then);

  final OcrLine _self;
  final $Res Function(OcrLine) _then;

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? words = null,Object? text = null,Object? bbox = null,}) {
  return _then(_self.copyWith(
words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<OcrWord>,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,bbox: null == bbox ? _self.bbox : bbox // ignore: cast_nullable_to_non_nullable
as Bbox,
  ));
}
/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BboxCopyWith<$Res> get bbox {
  
  return $BboxCopyWith<$Res>(_self.bbox, (value) {
    return _then(_self.copyWith(bbox: value));
  });
}
}


/// Adds pattern-matching-related methods to [OcrLine].
extension OcrLinePatterns on OcrLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrLine value)  $default,){
final _that = this;
switch (_that) {
case _OcrLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrLine value)?  $default,){
final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OcrWord> words,  String text,  Bbox bbox)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
return $default(_that.words,_that.text,_that.bbox);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OcrWord> words,  String text,  Bbox bbox)  $default,) {final _that = this;
switch (_that) {
case _OcrLine():
return $default(_that.words,_that.text,_that.bbox);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OcrWord> words,  String text,  Bbox bbox)?  $default,) {final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
return $default(_that.words,_that.text,_that.bbox);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OcrLine implements OcrLine {
  const _OcrLine({required final  List<OcrWord> words, required this.text, required this.bbox}): _words = words;
  factory _OcrLine.fromJson(Map<String, dynamic> json) => _$OcrLineFromJson(json);

 final  List<OcrWord> _words;
@override List<OcrWord> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}

@override final  String text;
@override final  Bbox bbox;

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrLineCopyWith<_OcrLine> get copyWith => __$OcrLineCopyWithImpl<_OcrLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrLine&&const DeepCollectionEquality().equals(other._words, _words)&&(identical(other.text, text) || other.text == text)&&(identical(other.bbox, bbox) || other.bbox == bbox));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_words),text,bbox);

@override
String toString() {
  return 'OcrLine(words: $words, text: $text, bbox: $bbox)';
}


}

/// @nodoc
abstract mixin class _$OcrLineCopyWith<$Res> implements $OcrLineCopyWith<$Res> {
  factory _$OcrLineCopyWith(_OcrLine value, $Res Function(_OcrLine) _then) = __$OcrLineCopyWithImpl;
@override @useResult
$Res call({
 List<OcrWord> words, String text, Bbox bbox
});


@override $BboxCopyWith<$Res> get bbox;

}
/// @nodoc
class __$OcrLineCopyWithImpl<$Res>
    implements _$OcrLineCopyWith<$Res> {
  __$OcrLineCopyWithImpl(this._self, this._then);

  final _OcrLine _self;
  final $Res Function(_OcrLine) _then;

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? words = null,Object? text = null,Object? bbox = null,}) {
  return _then(_OcrLine(
words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<OcrWord>,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,bbox: null == bbox ? _self.bbox : bbox // ignore: cast_nullable_to_non_nullable
as Bbox,
  ));
}

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BboxCopyWith<$Res> get bbox {
  
  return $BboxCopyWith<$Res>(_self.bbox, (value) {
    return _then(_self.copyWith(bbox: value));
  });
}
}


/// @nodoc
mixin _$OcrResult {

 List<OcrLine> get lines; int get imageWidth; int get imageHeight;
/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrResultCopyWith<OcrResult> get copyWith => _$OcrResultCopyWithImpl<OcrResult>(this as OcrResult, _$identity);

  /// Serializes this OcrResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrResult&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lines),imageWidth,imageHeight);

@override
String toString() {
  return 'OcrResult(lines: $lines, imageWidth: $imageWidth, imageHeight: $imageHeight)';
}


}

/// @nodoc
abstract mixin class $OcrResultCopyWith<$Res>  {
  factory $OcrResultCopyWith(OcrResult value, $Res Function(OcrResult) _then) = _$OcrResultCopyWithImpl;
@useResult
$Res call({
 List<OcrLine> lines, int imageWidth, int imageHeight
});




}
/// @nodoc
class _$OcrResultCopyWithImpl<$Res>
    implements $OcrResultCopyWith<$Res> {
  _$OcrResultCopyWithImpl(this._self, this._then);

  final OcrResult _self;
  final $Res Function(OcrResult) _then;

/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lines = null,Object? imageWidth = null,Object? imageHeight = null,}) {
  return _then(_self.copyWith(
lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OcrLine>,imageWidth: null == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int,imageHeight: null == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrResult].
extension OcrResultPatterns on OcrResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrResult value)  $default,){
final _that = this;
switch (_that) {
case _OcrResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrResult value)?  $default,){
final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OcrLine> lines,  int imageWidth,  int imageHeight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
return $default(_that.lines,_that.imageWidth,_that.imageHeight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OcrLine> lines,  int imageWidth,  int imageHeight)  $default,) {final _that = this;
switch (_that) {
case _OcrResult():
return $default(_that.lines,_that.imageWidth,_that.imageHeight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OcrLine> lines,  int imageWidth,  int imageHeight)?  $default,) {final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
return $default(_that.lines,_that.imageWidth,_that.imageHeight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OcrResult implements OcrResult {
  const _OcrResult({required final  List<OcrLine> lines, required this.imageWidth, required this.imageHeight}): _lines = lines;
  factory _OcrResult.fromJson(Map<String, dynamic> json) => _$OcrResultFromJson(json);

 final  List<OcrLine> _lines;
@override List<OcrLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  int imageWidth;
@override final  int imageHeight;

/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrResultCopyWith<_OcrResult> get copyWith => __$OcrResultCopyWithImpl<_OcrResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrResult&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lines),imageWidth,imageHeight);

@override
String toString() {
  return 'OcrResult(lines: $lines, imageWidth: $imageWidth, imageHeight: $imageHeight)';
}


}

/// @nodoc
abstract mixin class _$OcrResultCopyWith<$Res> implements $OcrResultCopyWith<$Res> {
  factory _$OcrResultCopyWith(_OcrResult value, $Res Function(_OcrResult) _then) = __$OcrResultCopyWithImpl;
@override @useResult
$Res call({
 List<OcrLine> lines, int imageWidth, int imageHeight
});




}
/// @nodoc
class __$OcrResultCopyWithImpl<$Res>
    implements _$OcrResultCopyWith<$Res> {
  __$OcrResultCopyWithImpl(this._self, this._then);

  final _OcrResult _self;
  final $Res Function(_OcrResult) _then;

/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lines = null,Object? imageWidth = null,Object? imageHeight = null,}) {
  return _then(_OcrResult(
lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OcrLine>,imageWidth: null == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int,imageHeight: null == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PageVersion {

 String get versionId; int get versionNumber; String? get message;@HighPrecisionDateTimeConverter() DateTime get createdAt; OcrResult? get ocrResult; String? get fileUrl; String? get mimeType;
/// Create a copy of PageVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageVersionCopyWith<PageVersion> get copyWith => _$PageVersionCopyWithImpl<PageVersion>(this as PageVersion, _$identity);

  /// Serializes this PageVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageVersion&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ocrResult, ocrResult) || other.ocrResult == ocrResult)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,versionId,versionNumber,message,createdAt,ocrResult,fileUrl,mimeType);

@override
String toString() {
  return 'PageVersion(versionId: $versionId, versionNumber: $versionNumber, message: $message, createdAt: $createdAt, ocrResult: $ocrResult, fileUrl: $fileUrl, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $PageVersionCopyWith<$Res>  {
  factory $PageVersionCopyWith(PageVersion value, $Res Function(PageVersion) _then) = _$PageVersionCopyWithImpl;
@useResult
$Res call({
 String versionId, int versionNumber, String? message,@HighPrecisionDateTimeConverter() DateTime createdAt, OcrResult? ocrResult, String? fileUrl, String? mimeType
});


$OcrResultCopyWith<$Res>? get ocrResult;

}
/// @nodoc
class _$PageVersionCopyWithImpl<$Res>
    implements $PageVersionCopyWith<$Res> {
  _$PageVersionCopyWithImpl(this._self, this._then);

  final PageVersion _self;
  final $Res Function(PageVersion) _then;

/// Create a copy of PageVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? versionId = null,Object? versionNumber = null,Object? message = freezed,Object? createdAt = null,Object? ocrResult = freezed,Object? fileUrl = freezed,Object? mimeType = freezed,}) {
  return _then(_self.copyWith(
versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ocrResult: freezed == ocrResult ? _self.ocrResult : ocrResult // ignore: cast_nullable_to_non_nullable
as OcrResult?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PageVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrResultCopyWith<$Res>? get ocrResult {
    if (_self.ocrResult == null) {
    return null;
  }

  return $OcrResultCopyWith<$Res>(_self.ocrResult!, (value) {
    return _then(_self.copyWith(ocrResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [PageVersion].
extension PageVersionPatterns on PageVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageVersion value)  $default,){
final _that = this;
switch (_that) {
case _PageVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageVersion value)?  $default,){
final _that = this;
switch (_that) {
case _PageVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String versionId,  int versionNumber,  String? message, @HighPrecisionDateTimeConverter()  DateTime createdAt,  OcrResult? ocrResult,  String? fileUrl,  String? mimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageVersion() when $default != null:
return $default(_that.versionId,_that.versionNumber,_that.message,_that.createdAt,_that.ocrResult,_that.fileUrl,_that.mimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String versionId,  int versionNumber,  String? message, @HighPrecisionDateTimeConverter()  DateTime createdAt,  OcrResult? ocrResult,  String? fileUrl,  String? mimeType)  $default,) {final _that = this;
switch (_that) {
case _PageVersion():
return $default(_that.versionId,_that.versionNumber,_that.message,_that.createdAt,_that.ocrResult,_that.fileUrl,_that.mimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String versionId,  int versionNumber,  String? message, @HighPrecisionDateTimeConverter()  DateTime createdAt,  OcrResult? ocrResult,  String? fileUrl,  String? mimeType)?  $default,) {final _that = this;
switch (_that) {
case _PageVersion() when $default != null:
return $default(_that.versionId,_that.versionNumber,_that.message,_that.createdAt,_that.ocrResult,_that.fileUrl,_that.mimeType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageVersion implements PageVersion {
  const _PageVersion({required this.versionId, required this.versionNumber, this.message, @HighPrecisionDateTimeConverter() required this.createdAt, this.ocrResult, this.fileUrl, this.mimeType});
  factory _PageVersion.fromJson(Map<String, dynamic> json) => _$PageVersionFromJson(json);

@override final  String versionId;
@override final  int versionNumber;
@override final  String? message;
@override@HighPrecisionDateTimeConverter() final  DateTime createdAt;
@override final  OcrResult? ocrResult;
@override final  String? fileUrl;
@override final  String? mimeType;

/// Create a copy of PageVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageVersionCopyWith<_PageVersion> get copyWith => __$PageVersionCopyWithImpl<_PageVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageVersion&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ocrResult, ocrResult) || other.ocrResult == ocrResult)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,versionId,versionNumber,message,createdAt,ocrResult,fileUrl,mimeType);

@override
String toString() {
  return 'PageVersion(versionId: $versionId, versionNumber: $versionNumber, message: $message, createdAt: $createdAt, ocrResult: $ocrResult, fileUrl: $fileUrl, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$PageVersionCopyWith<$Res> implements $PageVersionCopyWith<$Res> {
  factory _$PageVersionCopyWith(_PageVersion value, $Res Function(_PageVersion) _then) = __$PageVersionCopyWithImpl;
@override @useResult
$Res call({
 String versionId, int versionNumber, String? message,@HighPrecisionDateTimeConverter() DateTime createdAt, OcrResult? ocrResult, String? fileUrl, String? mimeType
});


@override $OcrResultCopyWith<$Res>? get ocrResult;

}
/// @nodoc
class __$PageVersionCopyWithImpl<$Res>
    implements _$PageVersionCopyWith<$Res> {
  __$PageVersionCopyWithImpl(this._self, this._then);

  final _PageVersion _self;
  final $Res Function(_PageVersion) _then;

/// Create a copy of PageVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? versionId = null,Object? versionNumber = null,Object? message = freezed,Object? createdAt = null,Object? ocrResult = freezed,Object? fileUrl = freezed,Object? mimeType = freezed,}) {
  return _then(_PageVersion(
versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ocrResult: freezed == ocrResult ? _self.ocrResult : ocrResult // ignore: cast_nullable_to_non_nullable
as OcrResult?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PageVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrResultCopyWith<$Res>? get ocrResult {
    if (_self.ocrResult == null) {
    return null;
  }

  return $OcrResultCopyWith<$Res>(_self.ocrResult!, (value) {
    return _then(_self.copyWith(ocrResult: value));
  });
}
}


/// @nodoc
mixin _$PageDetail {

 String get pageId; String get title;@HighPrecisionDateTimeConverter() DateTime get createdAt;@HighPrecisionDateTimeConverter() DateTime get updatedAt; PageVersion? get currentVersion; int get totalVersions; String? get thumbnailUrl;
/// Create a copy of PageDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageDetailCopyWith<PageDetail> get copyWith => _$PageDetailCopyWithImpl<PageDetail>(this as PageDetail, _$identity);

  /// Serializes this PageDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageDetail&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.totalVersions, totalVersions) || other.totalVersions == totalVersions)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageId,title,createdAt,updatedAt,currentVersion,totalVersions,thumbnailUrl);

@override
String toString() {
  return 'PageDetail(pageId: $pageId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, currentVersion: $currentVersion, totalVersions: $totalVersions, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $PageDetailCopyWith<$Res>  {
  factory $PageDetailCopyWith(PageDetail value, $Res Function(PageDetail) _then) = _$PageDetailCopyWithImpl;
@useResult
$Res call({
 String pageId, String title,@HighPrecisionDateTimeConverter() DateTime createdAt,@HighPrecisionDateTimeConverter() DateTime updatedAt, PageVersion? currentVersion, int totalVersions, String? thumbnailUrl
});


$PageVersionCopyWith<$Res>? get currentVersion;

}
/// @nodoc
class _$PageDetailCopyWithImpl<$Res>
    implements $PageDetailCopyWith<$Res> {
  _$PageDetailCopyWithImpl(this._self, this._then);

  final PageDetail _self;
  final $Res Function(PageDetail) _then;

/// Create a copy of PageDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? currentVersion = freezed,Object? totalVersions = null,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentVersion: freezed == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as PageVersion?,totalVersions: null == totalVersions ? _self.totalVersions : totalVersions // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PageDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageVersionCopyWith<$Res>? get currentVersion {
    if (_self.currentVersion == null) {
    return null;
  }

  return $PageVersionCopyWith<$Res>(_self.currentVersion!, (value) {
    return _then(_self.copyWith(currentVersion: value));
  });
}
}


/// Adds pattern-matching-related methods to [PageDetail].
extension PageDetailPatterns on PageDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageDetail value)  $default,){
final _that = this;
switch (_that) {
case _PageDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PageDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pageId,  String title, @HighPrecisionDateTimeConverter()  DateTime createdAt, @HighPrecisionDateTimeConverter()  DateTime updatedAt,  PageVersion? currentVersion,  int totalVersions,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageDetail() when $default != null:
return $default(_that.pageId,_that.title,_that.createdAt,_that.updatedAt,_that.currentVersion,_that.totalVersions,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pageId,  String title, @HighPrecisionDateTimeConverter()  DateTime createdAt, @HighPrecisionDateTimeConverter()  DateTime updatedAt,  PageVersion? currentVersion,  int totalVersions,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _PageDetail():
return $default(_that.pageId,_that.title,_that.createdAt,_that.updatedAt,_that.currentVersion,_that.totalVersions,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pageId,  String title, @HighPrecisionDateTimeConverter()  DateTime createdAt, @HighPrecisionDateTimeConverter()  DateTime updatedAt,  PageVersion? currentVersion,  int totalVersions,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _PageDetail() when $default != null:
return $default(_that.pageId,_that.title,_that.createdAt,_that.updatedAt,_that.currentVersion,_that.totalVersions,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageDetail implements PageDetail {
  const _PageDetail({required this.pageId, required this.title, @HighPrecisionDateTimeConverter() required this.createdAt, @HighPrecisionDateTimeConverter() required this.updatedAt, required this.currentVersion, required this.totalVersions, this.thumbnailUrl});
  factory _PageDetail.fromJson(Map<String, dynamic> json) => _$PageDetailFromJson(json);

@override final  String pageId;
@override final  String title;
@override@HighPrecisionDateTimeConverter() final  DateTime createdAt;
@override@HighPrecisionDateTimeConverter() final  DateTime updatedAt;
@override final  PageVersion? currentVersion;
@override final  int totalVersions;
@override final  String? thumbnailUrl;

/// Create a copy of PageDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageDetailCopyWith<_PageDetail> get copyWith => __$PageDetailCopyWithImpl<_PageDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageDetail&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.totalVersions, totalVersions) || other.totalVersions == totalVersions)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageId,title,createdAt,updatedAt,currentVersion,totalVersions,thumbnailUrl);

@override
String toString() {
  return 'PageDetail(pageId: $pageId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, currentVersion: $currentVersion, totalVersions: $totalVersions, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$PageDetailCopyWith<$Res> implements $PageDetailCopyWith<$Res> {
  factory _$PageDetailCopyWith(_PageDetail value, $Res Function(_PageDetail) _then) = __$PageDetailCopyWithImpl;
@override @useResult
$Res call({
 String pageId, String title,@HighPrecisionDateTimeConverter() DateTime createdAt,@HighPrecisionDateTimeConverter() DateTime updatedAt, PageVersion? currentVersion, int totalVersions, String? thumbnailUrl
});


@override $PageVersionCopyWith<$Res>? get currentVersion;

}
/// @nodoc
class __$PageDetailCopyWithImpl<$Res>
    implements _$PageDetailCopyWith<$Res> {
  __$PageDetailCopyWithImpl(this._self, this._then);

  final _PageDetail _self;
  final $Res Function(_PageDetail) _then;

/// Create a copy of PageDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? currentVersion = freezed,Object? totalVersions = null,Object? thumbnailUrl = freezed,}) {
  return _then(_PageDetail(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentVersion: freezed == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as PageVersion?,totalVersions: null == totalVersions ? _self.totalVersions : totalVersions // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PageDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageVersionCopyWith<$Res>? get currentVersion {
    if (_self.currentVersion == null) {
    return null;
  }

  return $PageVersionCopyWith<$Res>(_self.currentVersion!, (value) {
    return _then(_self.copyWith(currentVersion: value));
  });
}
}

// dart format on
