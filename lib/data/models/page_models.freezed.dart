// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Page _$PageFromJson(Map<String, dynamic> json) {
  return _Page.fromJson(json);
}

/// @nodoc
mixin _$Page {
  String get pageId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this Page to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Page
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageCopyWith<Page> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageCopyWith<$Res> {
  factory $PageCopyWith(Page value, $Res Function(Page) then) =
      _$PageCopyWithImpl<$Res, Page>;
  @useResult
  $Res call({
    String pageId,
    String title,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    int order,
  });
}

/// @nodoc
class _$PageCopyWithImpl<$Res, $Val extends Page>
    implements $PageCopyWith<$Res> {
  _$PageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Page
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? order = null,
  }) {
    return _then(
      _value.copyWith(
            pageId: null == pageId
                ? _value.pageId
                : pageId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PageImplCopyWith<$Res> implements $PageCopyWith<$Res> {
  factory _$$PageImplCopyWith(
    _$PageImpl value,
    $Res Function(_$PageImpl) then,
  ) = __$$PageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String pageId,
    String title,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    int order,
  });
}

/// @nodoc
class __$$PageImplCopyWithImpl<$Res>
    extends _$PageCopyWithImpl<$Res, _$PageImpl>
    implements _$$PageImplCopyWith<$Res> {
  __$$PageImplCopyWithImpl(_$PageImpl _value, $Res Function(_$PageImpl) _then)
    : super(_value, _then);

  /// Create a copy of Page
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? order = null,
  }) {
    return _then(
      _$PageImpl(
        pageId: null == pageId
            ? _value.pageId
            : pageId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PageImpl implements _Page {
  const _$PageImpl({
    required this.pageId,
    required this.title,
    @HighPrecisionDateTimeConverter() required this.createdAt,
    @HighPrecisionDateTimeConverter() required this.updatedAt,
    this.order = 0,
  });

  factory _$PageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageImplFromJson(json);

  @override
  final String pageId;
  @override
  final String title;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'Page(pageId: $pageId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageImpl &&
            (identical(other.pageId, pageId) || other.pageId == pageId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, pageId, title, createdAt, updatedAt, order);

  /// Create a copy of Page
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageImplCopyWith<_$PageImpl> get copyWith =>
      __$$PageImplCopyWithImpl<_$PageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageImplToJson(this);
  }
}

abstract class _Page implements Page {
  const factory _Page({
    required final String pageId,
    required final String title,
    @HighPrecisionDateTimeConverter() required final DateTime createdAt,
    @HighPrecisionDateTimeConverter() required final DateTime updatedAt,
    final int order,
  }) = _$PageImpl;

  factory _Page.fromJson(Map<String, dynamic> json) = _$PageImpl.fromJson;

  @override
  String get pageId;
  @override
  String get title;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt;
  @override
  int get order;

  /// Create a copy of Page
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageImplCopyWith<_$PageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bbox _$BboxFromJson(Map<String, dynamic> json) {
  return _Bbox.fromJson(json);
}

/// @nodoc
mixin _$Bbox {
  int get x1 => throw _privateConstructorUsedError;
  int get y1 => throw _privateConstructorUsedError;
  int get x2 => throw _privateConstructorUsedError;
  int get y2 => throw _privateConstructorUsedError;

  /// Serializes this Bbox to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bbox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BboxCopyWith<Bbox> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BboxCopyWith<$Res> {
  factory $BboxCopyWith(Bbox value, $Res Function(Bbox) then) =
      _$BboxCopyWithImpl<$Res, Bbox>;
  @useResult
  $Res call({int x1, int y1, int x2, int y2});
}

/// @nodoc
class _$BboxCopyWithImpl<$Res, $Val extends Bbox>
    implements $BboxCopyWith<$Res> {
  _$BboxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bbox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x1 = null,
    Object? y1 = null,
    Object? x2 = null,
    Object? y2 = null,
  }) {
    return _then(
      _value.copyWith(
            x1: null == x1
                ? _value.x1
                : x1 // ignore: cast_nullable_to_non_nullable
                      as int,
            y1: null == y1
                ? _value.y1
                : y1 // ignore: cast_nullable_to_non_nullable
                      as int,
            x2: null == x2
                ? _value.x2
                : x2 // ignore: cast_nullable_to_non_nullable
                      as int,
            y2: null == y2
                ? _value.y2
                : y2 // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BboxImplCopyWith<$Res> implements $BboxCopyWith<$Res> {
  factory _$$BboxImplCopyWith(
    _$BboxImpl value,
    $Res Function(_$BboxImpl) then,
  ) = __$$BboxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int x1, int y1, int x2, int y2});
}

/// @nodoc
class __$$BboxImplCopyWithImpl<$Res>
    extends _$BboxCopyWithImpl<$Res, _$BboxImpl>
    implements _$$BboxImplCopyWith<$Res> {
  __$$BboxImplCopyWithImpl(_$BboxImpl _value, $Res Function(_$BboxImpl) _then)
    : super(_value, _then);

  /// Create a copy of Bbox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x1 = null,
    Object? y1 = null,
    Object? x2 = null,
    Object? y2 = null,
  }) {
    return _then(
      _$BboxImpl(
        x1: null == x1
            ? _value.x1
            : x1 // ignore: cast_nullable_to_non_nullable
                  as int,
        y1: null == y1
            ? _value.y1
            : y1 // ignore: cast_nullable_to_non_nullable
                  as int,
        x2: null == x2
            ? _value.x2
            : x2 // ignore: cast_nullable_to_non_nullable
                  as int,
        y2: null == y2
            ? _value.y2
            : y2 // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BboxImpl implements _Bbox {
  const _$BboxImpl({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  factory _$BboxImpl.fromJson(Map<String, dynamic> json) =>
      _$$BboxImplFromJson(json);

  @override
  final int x1;
  @override
  final int y1;
  @override
  final int x2;
  @override
  final int y2;

  @override
  String toString() {
    return 'Bbox(x1: $x1, y1: $y1, x2: $x2, y2: $y2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BboxImpl &&
            (identical(other.x1, x1) || other.x1 == x1) &&
            (identical(other.y1, y1) || other.y1 == y1) &&
            (identical(other.x2, x2) || other.x2 == x2) &&
            (identical(other.y2, y2) || other.y2 == y2));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x1, y1, x2, y2);

  /// Create a copy of Bbox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BboxImplCopyWith<_$BboxImpl> get copyWith =>
      __$$BboxImplCopyWithImpl<_$BboxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BboxImplToJson(this);
  }
}

abstract class _Bbox implements Bbox {
  const factory _Bbox({
    required final int x1,
    required final int y1,
    required final int x2,
    required final int y2,
  }) = _$BboxImpl;

  factory _Bbox.fromJson(Map<String, dynamic> json) = _$BboxImpl.fromJson;

  @override
  int get x1;
  @override
  int get y1;
  @override
  int get x2;
  @override
  int get y2;

  /// Create a copy of Bbox
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BboxImplCopyWith<_$BboxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OcrWord _$OcrWordFromJson(Map<String, dynamic> json) {
  return _OcrWord.fromJson(json);
}

/// @nodoc
mixin _$OcrWord {
  String get text => throw _privateConstructorUsedError;
  Bbox get bbox => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this OcrWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrWordCopyWith<OcrWord> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrWordCopyWith<$Res> {
  factory $OcrWordCopyWith(OcrWord value, $Res Function(OcrWord) then) =
      _$OcrWordCopyWithImpl<$Res, OcrWord>;
  @useResult
  $Res call({String text, Bbox bbox, double confidence});

  $BboxCopyWith<$Res> get bbox;
}

/// @nodoc
class _$OcrWordCopyWithImpl<$Res, $Val extends OcrWord>
    implements $OcrWordCopyWith<$Res> {
  _$OcrWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? bbox = null,
    Object? confidence = null,
  }) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            bbox: null == bbox
                ? _value.bbox
                : bbox // ignore: cast_nullable_to_non_nullable
                      as Bbox,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of OcrWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BboxCopyWith<$Res> get bbox {
    return $BboxCopyWith<$Res>(_value.bbox, (value) {
      return _then(_value.copyWith(bbox: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OcrWordImplCopyWith<$Res> implements $OcrWordCopyWith<$Res> {
  factory _$$OcrWordImplCopyWith(
    _$OcrWordImpl value,
    $Res Function(_$OcrWordImpl) then,
  ) = __$$OcrWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, Bbox bbox, double confidence});

  @override
  $BboxCopyWith<$Res> get bbox;
}

/// @nodoc
class __$$OcrWordImplCopyWithImpl<$Res>
    extends _$OcrWordCopyWithImpl<$Res, _$OcrWordImpl>
    implements _$$OcrWordImplCopyWith<$Res> {
  __$$OcrWordImplCopyWithImpl(
    _$OcrWordImpl _value,
    $Res Function(_$OcrWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcrWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? bbox = null,
    Object? confidence = null,
  }) {
    return _then(
      _$OcrWordImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        bbox: null == bbox
            ? _value.bbox
            : bbox // ignore: cast_nullable_to_non_nullable
                  as Bbox,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrWordImpl implements _OcrWord {
  const _$OcrWordImpl({
    required this.text,
    required this.bbox,
    required this.confidence,
  });

  factory _$OcrWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrWordImplFromJson(json);

  @override
  final String text;
  @override
  final Bbox bbox;
  @override
  final double confidence;

  @override
  String toString() {
    return 'OcrWord(text: $text, bbox: $bbox, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrWordImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.bbox, bbox) || other.bbox == bbox) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, bbox, confidence);

  /// Create a copy of OcrWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrWordImplCopyWith<_$OcrWordImpl> get copyWith =>
      __$$OcrWordImplCopyWithImpl<_$OcrWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrWordImplToJson(this);
  }
}

abstract class _OcrWord implements OcrWord {
  const factory _OcrWord({
    required final String text,
    required final Bbox bbox,
    required final double confidence,
  }) = _$OcrWordImpl;

  factory _OcrWord.fromJson(Map<String, dynamic> json) = _$OcrWordImpl.fromJson;

  @override
  String get text;
  @override
  Bbox get bbox;
  @override
  double get confidence;

  /// Create a copy of OcrWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrWordImplCopyWith<_$OcrWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OcrLine _$OcrLineFromJson(Map<String, dynamic> json) {
  return _OcrLine.fromJson(json);
}

/// @nodoc
mixin _$OcrLine {
  List<OcrWord> get words => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  Bbox get bbox => throw _privateConstructorUsedError;

  /// Serializes this OcrLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrLineCopyWith<OcrLine> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrLineCopyWith<$Res> {
  factory $OcrLineCopyWith(OcrLine value, $Res Function(OcrLine) then) =
      _$OcrLineCopyWithImpl<$Res, OcrLine>;
  @useResult
  $Res call({List<OcrWord> words, String text, Bbox bbox});

  $BboxCopyWith<$Res> get bbox;
}

/// @nodoc
class _$OcrLineCopyWithImpl<$Res, $Val extends OcrLine>
    implements $OcrLineCopyWith<$Res> {
  _$OcrLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? words = null, Object? text = null, Object? bbox = null}) {
    return _then(
      _value.copyWith(
            words: null == words
                ? _value.words
                : words // ignore: cast_nullable_to_non_nullable
                      as List<OcrWord>,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            bbox: null == bbox
                ? _value.bbox
                : bbox // ignore: cast_nullable_to_non_nullable
                      as Bbox,
          )
          as $Val,
    );
  }

  /// Create a copy of OcrLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BboxCopyWith<$Res> get bbox {
    return $BboxCopyWith<$Res>(_value.bbox, (value) {
      return _then(_value.copyWith(bbox: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OcrLineImplCopyWith<$Res> implements $OcrLineCopyWith<$Res> {
  factory _$$OcrLineImplCopyWith(
    _$OcrLineImpl value,
    $Res Function(_$OcrLineImpl) then,
  ) = __$$OcrLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<OcrWord> words, String text, Bbox bbox});

  @override
  $BboxCopyWith<$Res> get bbox;
}

/// @nodoc
class __$$OcrLineImplCopyWithImpl<$Res>
    extends _$OcrLineCopyWithImpl<$Res, _$OcrLineImpl>
    implements _$$OcrLineImplCopyWith<$Res> {
  __$$OcrLineImplCopyWithImpl(
    _$OcrLineImpl _value,
    $Res Function(_$OcrLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcrLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? words = null, Object? text = null, Object? bbox = null}) {
    return _then(
      _$OcrLineImpl(
        words: null == words
            ? _value._words
            : words // ignore: cast_nullable_to_non_nullable
                  as List<OcrWord>,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        bbox: null == bbox
            ? _value.bbox
            : bbox // ignore: cast_nullable_to_non_nullable
                  as Bbox,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrLineImpl implements _OcrLine {
  const _$OcrLineImpl({
    required final List<OcrWord> words,
    required this.text,
    required this.bbox,
  }) : _words = words;

  factory _$OcrLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrLineImplFromJson(json);

  final List<OcrWord> _words;
  @override
  List<OcrWord> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  final String text;
  @override
  final Bbox bbox;

  @override
  String toString() {
    return 'OcrLine(words: $words, text: $text, bbox: $bbox)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrLineImpl &&
            const DeepCollectionEquality().equals(other._words, _words) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.bbox, bbox) || other.bbox == bbox));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_words),
    text,
    bbox,
  );

  /// Create a copy of OcrLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrLineImplCopyWith<_$OcrLineImpl> get copyWith =>
      __$$OcrLineImplCopyWithImpl<_$OcrLineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrLineImplToJson(this);
  }
}

abstract class _OcrLine implements OcrLine {
  const factory _OcrLine({
    required final List<OcrWord> words,
    required final String text,
    required final Bbox bbox,
  }) = _$OcrLineImpl;

  factory _OcrLine.fromJson(Map<String, dynamic> json) = _$OcrLineImpl.fromJson;

  @override
  List<OcrWord> get words;
  @override
  String get text;
  @override
  Bbox get bbox;

  /// Create a copy of OcrLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrLineImplCopyWith<_$OcrLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OcrResult _$OcrResultFromJson(Map<String, dynamic> json) {
  return _OcrResult.fromJson(json);
}

/// @nodoc
mixin _$OcrResult {
  List<OcrLine> get lines => throw _privateConstructorUsedError;
  int get imageWidth => throw _privateConstructorUsedError;
  int get imageHeight => throw _privateConstructorUsedError;

  /// Serializes this OcrResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrResultCopyWith<OcrResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrResultCopyWith<$Res> {
  factory $OcrResultCopyWith(OcrResult value, $Res Function(OcrResult) then) =
      _$OcrResultCopyWithImpl<$Res, OcrResult>;
  @useResult
  $Res call({List<OcrLine> lines, int imageWidth, int imageHeight});
}

/// @nodoc
class _$OcrResultCopyWithImpl<$Res, $Val extends OcrResult>
    implements $OcrResultCopyWith<$Res> {
  _$OcrResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lines = null,
    Object? imageWidth = null,
    Object? imageHeight = null,
  }) {
    return _then(
      _value.copyWith(
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<OcrLine>,
            imageWidth: null == imageWidth
                ? _value.imageWidth
                : imageWidth // ignore: cast_nullable_to_non_nullable
                      as int,
            imageHeight: null == imageHeight
                ? _value.imageHeight
                : imageHeight // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OcrResultImplCopyWith<$Res>
    implements $OcrResultCopyWith<$Res> {
  factory _$$OcrResultImplCopyWith(
    _$OcrResultImpl value,
    $Res Function(_$OcrResultImpl) then,
  ) = __$$OcrResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<OcrLine> lines, int imageWidth, int imageHeight});
}

/// @nodoc
class __$$OcrResultImplCopyWithImpl<$Res>
    extends _$OcrResultCopyWithImpl<$Res, _$OcrResultImpl>
    implements _$$OcrResultImplCopyWith<$Res> {
  __$$OcrResultImplCopyWithImpl(
    _$OcrResultImpl _value,
    $Res Function(_$OcrResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lines = null,
    Object? imageWidth = null,
    Object? imageHeight = null,
  }) {
    return _then(
      _$OcrResultImpl(
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<OcrLine>,
        imageWidth: null == imageWidth
            ? _value.imageWidth
            : imageWidth // ignore: cast_nullable_to_non_nullable
                  as int,
        imageHeight: null == imageHeight
            ? _value.imageHeight
            : imageHeight // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrResultImpl implements _OcrResult {
  const _$OcrResultImpl({
    required final List<OcrLine> lines,
    required this.imageWidth,
    required this.imageHeight,
  }) : _lines = lines;

  factory _$OcrResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrResultImplFromJson(json);

  final List<OcrLine> _lines;
  @override
  List<OcrLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final int imageWidth;
  @override
  final int imageHeight;

  @override
  String toString() {
    return 'OcrResult(lines: $lines, imageWidth: $imageWidth, imageHeight: $imageHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrResultImpl &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.imageWidth, imageWidth) ||
                other.imageWidth == imageWidth) &&
            (identical(other.imageHeight, imageHeight) ||
                other.imageHeight == imageHeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_lines),
    imageWidth,
    imageHeight,
  );

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrResultImplCopyWith<_$OcrResultImpl> get copyWith =>
      __$$OcrResultImplCopyWithImpl<_$OcrResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrResultImplToJson(this);
  }
}

abstract class _OcrResult implements OcrResult {
  const factory _OcrResult({
    required final List<OcrLine> lines,
    required final int imageWidth,
    required final int imageHeight,
  }) = _$OcrResultImpl;

  factory _OcrResult.fromJson(Map<String, dynamic> json) =
      _$OcrResultImpl.fromJson;

  @override
  List<OcrLine> get lines;
  @override
  int get imageWidth;
  @override
  int get imageHeight;

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrResultImplCopyWith<_$OcrResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PageVersion _$PageVersionFromJson(Map<String, dynamic> json) {
  return _PageVersion.fromJson(json);
}

/// @nodoc
mixin _$PageVersion {
  String get versionId => throw _privateConstructorUsedError;
  int get versionNumber => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  OcrResult? get ocrResult => throw _privateConstructorUsedError;

  /// Serializes this PageVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PageVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageVersionCopyWith<PageVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageVersionCopyWith<$Res> {
  factory $PageVersionCopyWith(
    PageVersion value,
    $Res Function(PageVersion) then,
  ) = _$PageVersionCopyWithImpl<$Res, PageVersion>;
  @useResult
  $Res call({
    String versionId,
    int versionNumber,
    String? message,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    OcrResult? ocrResult,
  });

  $OcrResultCopyWith<$Res>? get ocrResult;
}

/// @nodoc
class _$PageVersionCopyWithImpl<$Res, $Val extends PageVersion>
    implements $PageVersionCopyWith<$Res> {
  _$PageVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? versionId = null,
    Object? versionNumber = null,
    Object? message = freezed,
    Object? createdAt = null,
    Object? ocrResult = freezed,
  }) {
    return _then(
      _value.copyWith(
            versionId: null == versionId
                ? _value.versionId
                : versionId // ignore: cast_nullable_to_non_nullable
                      as String,
            versionNumber: null == versionNumber
                ? _value.versionNumber
                : versionNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            ocrResult: freezed == ocrResult
                ? _value.ocrResult
                : ocrResult // ignore: cast_nullable_to_non_nullable
                      as OcrResult?,
          )
          as $Val,
    );
  }

  /// Create a copy of PageVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OcrResultCopyWith<$Res>? get ocrResult {
    if (_value.ocrResult == null) {
      return null;
    }

    return $OcrResultCopyWith<$Res>(_value.ocrResult!, (value) {
      return _then(_value.copyWith(ocrResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PageVersionImplCopyWith<$Res>
    implements $PageVersionCopyWith<$Res> {
  factory _$$PageVersionImplCopyWith(
    _$PageVersionImpl value,
    $Res Function(_$PageVersionImpl) then,
  ) = __$$PageVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String versionId,
    int versionNumber,
    String? message,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    OcrResult? ocrResult,
  });

  @override
  $OcrResultCopyWith<$Res>? get ocrResult;
}

/// @nodoc
class __$$PageVersionImplCopyWithImpl<$Res>
    extends _$PageVersionCopyWithImpl<$Res, _$PageVersionImpl>
    implements _$$PageVersionImplCopyWith<$Res> {
  __$$PageVersionImplCopyWithImpl(
    _$PageVersionImpl _value,
    $Res Function(_$PageVersionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PageVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? versionId = null,
    Object? versionNumber = null,
    Object? message = freezed,
    Object? createdAt = null,
    Object? ocrResult = freezed,
  }) {
    return _then(
      _$PageVersionImpl(
        versionId: null == versionId
            ? _value.versionId
            : versionId // ignore: cast_nullable_to_non_nullable
                  as String,
        versionNumber: null == versionNumber
            ? _value.versionNumber
            : versionNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        ocrResult: freezed == ocrResult
            ? _value.ocrResult
            : ocrResult // ignore: cast_nullable_to_non_nullable
                  as OcrResult?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PageVersionImpl implements _PageVersion {
  const _$PageVersionImpl({
    required this.versionId,
    required this.versionNumber,
    this.message,
    @HighPrecisionDateTimeConverter() required this.createdAt,
    this.ocrResult,
  });

  factory _$PageVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageVersionImplFromJson(json);

  @override
  final String versionId;
  @override
  final int versionNumber;
  @override
  final String? message;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime createdAt;
  @override
  final OcrResult? ocrResult;

  @override
  String toString() {
    return 'PageVersion(versionId: $versionId, versionNumber: $versionNumber, message: $message, createdAt: $createdAt, ocrResult: $ocrResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageVersionImpl &&
            (identical(other.versionId, versionId) ||
                other.versionId == versionId) &&
            (identical(other.versionNumber, versionNumber) ||
                other.versionNumber == versionNumber) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.ocrResult, ocrResult) ||
                other.ocrResult == ocrResult));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    versionId,
    versionNumber,
    message,
    createdAt,
    ocrResult,
  );

  /// Create a copy of PageVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageVersionImplCopyWith<_$PageVersionImpl> get copyWith =>
      __$$PageVersionImplCopyWithImpl<_$PageVersionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageVersionImplToJson(this);
  }
}

abstract class _PageVersion implements PageVersion {
  const factory _PageVersion({
    required final String versionId,
    required final int versionNumber,
    final String? message,
    @HighPrecisionDateTimeConverter() required final DateTime createdAt,
    final OcrResult? ocrResult,
  }) = _$PageVersionImpl;

  factory _PageVersion.fromJson(Map<String, dynamic> json) =
      _$PageVersionImpl.fromJson;

  @override
  String get versionId;
  @override
  int get versionNumber;
  @override
  String? get message;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt;
  @override
  OcrResult? get ocrResult;

  /// Create a copy of PageVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageVersionImplCopyWith<_$PageVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PageDetail _$PageDetailFromJson(Map<String, dynamic> json) {
  return _PageDetail.fromJson(json);
}

/// @nodoc
mixin _$PageDetail {
  String get pageId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  PageVersion get currentVersion => throw _privateConstructorUsedError;
  int get totalVersions => throw _privateConstructorUsedError;

  /// Serializes this PageDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PageDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageDetailCopyWith<PageDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageDetailCopyWith<$Res> {
  factory $PageDetailCopyWith(
    PageDetail value,
    $Res Function(PageDetail) then,
  ) = _$PageDetailCopyWithImpl<$Res, PageDetail>;
  @useResult
  $Res call({
    String pageId,
    String title,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    PageVersion currentVersion,
    int totalVersions,
  });

  $PageVersionCopyWith<$Res> get currentVersion;
}

/// @nodoc
class _$PageDetailCopyWithImpl<$Res, $Val extends PageDetail>
    implements $PageDetailCopyWith<$Res> {
  _$PageDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currentVersion = null,
    Object? totalVersions = null,
  }) {
    return _then(
      _value.copyWith(
            pageId: null == pageId
                ? _value.pageId
                : pageId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            currentVersion: null == currentVersion
                ? _value.currentVersion
                : currentVersion // ignore: cast_nullable_to_non_nullable
                      as PageVersion,
            totalVersions: null == totalVersions
                ? _value.totalVersions
                : totalVersions // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of PageDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageVersionCopyWith<$Res> get currentVersion {
    return $PageVersionCopyWith<$Res>(_value.currentVersion, (value) {
      return _then(_value.copyWith(currentVersion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PageDetailImplCopyWith<$Res>
    implements $PageDetailCopyWith<$Res> {
  factory _$$PageDetailImplCopyWith(
    _$PageDetailImpl value,
    $Res Function(_$PageDetailImpl) then,
  ) = __$$PageDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String pageId,
    String title,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    PageVersion currentVersion,
    int totalVersions,
  });

  @override
  $PageVersionCopyWith<$Res> get currentVersion;
}

/// @nodoc
class __$$PageDetailImplCopyWithImpl<$Res>
    extends _$PageDetailCopyWithImpl<$Res, _$PageDetailImpl>
    implements _$$PageDetailImplCopyWith<$Res> {
  __$$PageDetailImplCopyWithImpl(
    _$PageDetailImpl _value,
    $Res Function(_$PageDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PageDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currentVersion = null,
    Object? totalVersions = null,
  }) {
    return _then(
      _$PageDetailImpl(
        pageId: null == pageId
            ? _value.pageId
            : pageId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        currentVersion: null == currentVersion
            ? _value.currentVersion
            : currentVersion // ignore: cast_nullable_to_non_nullable
                  as PageVersion,
        totalVersions: null == totalVersions
            ? _value.totalVersions
            : totalVersions // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PageDetailImpl implements _PageDetail {
  const _$PageDetailImpl({
    required this.pageId,
    required this.title,
    @HighPrecisionDateTimeConverter() required this.createdAt,
    @HighPrecisionDateTimeConverter() required this.updatedAt,
    required this.currentVersion,
    required this.totalVersions,
  });

  factory _$PageDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageDetailImplFromJson(json);

  @override
  final String pageId;
  @override
  final String title;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime updatedAt;
  @override
  final PageVersion currentVersion;
  @override
  final int totalVersions;

  @override
  String toString() {
    return 'PageDetail(pageId: $pageId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, currentVersion: $currentVersion, totalVersions: $totalVersions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageDetailImpl &&
            (identical(other.pageId, pageId) || other.pageId == pageId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.totalVersions, totalVersions) ||
                other.totalVersions == totalVersions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pageId,
    title,
    createdAt,
    updatedAt,
    currentVersion,
    totalVersions,
  );

  /// Create a copy of PageDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageDetailImplCopyWith<_$PageDetailImpl> get copyWith =>
      __$$PageDetailImplCopyWithImpl<_$PageDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageDetailImplToJson(this);
  }
}

abstract class _PageDetail implements PageDetail {
  const factory _PageDetail({
    required final String pageId,
    required final String title,
    @HighPrecisionDateTimeConverter() required final DateTime createdAt,
    @HighPrecisionDateTimeConverter() required final DateTime updatedAt,
    required final PageVersion currentVersion,
    required final int totalVersions,
  }) = _$PageDetailImpl;

  factory _PageDetail.fromJson(Map<String, dynamic> json) =
      _$PageDetailImpl.fromJson;

  @override
  String get pageId;
  @override
  String get title;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt;
  @override
  PageVersion get currentVersion;
  @override
  int get totalVersions;

  /// Create a copy of PageDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageDetailImplCopyWith<_$PageDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
