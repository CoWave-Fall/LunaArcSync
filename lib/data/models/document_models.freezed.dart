// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return _Document.fromJson(json);
}

/// @nodoc
mixin _$Document {
  String get documentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get pageCount => throw _privateConstructorUsedError;

  /// Serializes this Document to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentCopyWith<Document> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentCopyWith<$Res> {
  factory $DocumentCopyWith(Document value, $Res Function(Document) then) =
      _$DocumentCopyWithImpl<$Res, Document>;
  @useResult
  $Res call({
    String documentId,
    String title,
    List<String> tags,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    int pageCount,
  });
}

/// @nodoc
class _$DocumentCopyWithImpl<$Res, $Val extends Document>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pageCount = null,
  }) {
    return _then(
      _value.copyWith(
            documentId: null == documentId
                ? _value.documentId
                : documentId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            pageCount: null == pageCount
                ? _value.pageCount
                : pageCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentImplCopyWith<$Res>
    implements $DocumentCopyWith<$Res> {
  factory _$$DocumentImplCopyWith(
    _$DocumentImpl value,
    $Res Function(_$DocumentImpl) then,
  ) = __$$DocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String documentId,
    String title,
    List<String> tags,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    int pageCount,
  });
}

/// @nodoc
class __$$DocumentImplCopyWithImpl<$Res>
    extends _$DocumentCopyWithImpl<$Res, _$DocumentImpl>
    implements _$$DocumentImplCopyWith<$Res> {
  __$$DocumentImplCopyWithImpl(
    _$DocumentImpl _value,
    $Res Function(_$DocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pageCount = null,
  }) {
    return _then(
      _$DocumentImpl(
        documentId: null == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        pageCount: null == pageCount
            ? _value.pageCount
            : pageCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentImpl implements _Document {
  const _$DocumentImpl({
    required this.documentId,
    required this.title,
    final List<String> tags = const [],
    @HighPrecisionDateTimeConverter() required this.createdAt,
    @HighPrecisionDateTimeConverter() required this.updatedAt,
    this.pageCount = 0,
  }) : _tags = tags;

  factory _$DocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentImplFromJson(json);

  @override
  final String documentId;
  @override
  final String title;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HighPrecisionDateTimeConverter()
  final DateTime createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int pageCount;

  @override
  String toString() {
    return 'Document(documentId: $documentId, title: $title, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, pageCount: $pageCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    documentId,
    title,
    const DeepCollectionEquality().hash(_tags),
    createdAt,
    updatedAt,
    pageCount,
  );

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      __$$DocumentImplCopyWithImpl<_$DocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentImplToJson(this);
  }
}

abstract class _Document implements Document {
  const factory _Document({
    required final String documentId,
    required final String title,
    final List<String> tags,
    @HighPrecisionDateTimeConverter() required final DateTime createdAt,
    @HighPrecisionDateTimeConverter() required final DateTime updatedAt,
    final int pageCount,
  }) = _$DocumentImpl;

  factory _Document.fromJson(Map<String, dynamic> json) =
      _$DocumentImpl.fromJson;

  @override
  String get documentId;
  @override
  String get title;
  @override
  List<String> get tags;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt;
  @override
  int get pageCount;

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentDetail _$DocumentDetailFromJson(Map<String, dynamic> json) {
  return _DocumentDetail.fromJson(json);
}

/// @nodoc
mixin _$DocumentDetail {
  String get documentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<Page> get pages => throw _privateConstructorUsedError;

  /// Serializes this DocumentDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentDetailCopyWith<DocumentDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentDetailCopyWith<$Res> {
  factory $DocumentDetailCopyWith(
    DocumentDetail value,
    $Res Function(DocumentDetail) then,
  ) = _$DocumentDetailCopyWithImpl<$Res, DocumentDetail>;
  @useResult
  $Res call({
    String documentId,
    String title,
    List<String> tags,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    List<Page> pages,
  });
}

/// @nodoc
class _$DocumentDetailCopyWithImpl<$Res, $Val extends DocumentDetail>
    implements $DocumentDetailCopyWith<$Res> {
  _$DocumentDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pages = null,
  }) {
    return _then(
      _value.copyWith(
            documentId: null == documentId
                ? _value.documentId
                : documentId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            pages: null == pages
                ? _value.pages
                : pages // ignore: cast_nullable_to_non_nullable
                      as List<Page>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentDetailImplCopyWith<$Res>
    implements $DocumentDetailCopyWith<$Res> {
  factory _$$DocumentDetailImplCopyWith(
    _$DocumentDetailImpl value,
    $Res Function(_$DocumentDetailImpl) then,
  ) = __$$DocumentDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String documentId,
    String title,
    List<String> tags,
    @HighPrecisionDateTimeConverter() DateTime createdAt,
    @HighPrecisionDateTimeConverter() DateTime updatedAt,
    List<Page> pages,
  });
}

/// @nodoc
class __$$DocumentDetailImplCopyWithImpl<$Res>
    extends _$DocumentDetailCopyWithImpl<$Res, _$DocumentDetailImpl>
    implements _$$DocumentDetailImplCopyWith<$Res> {
  __$$DocumentDetailImplCopyWithImpl(
    _$DocumentDetailImpl _value,
    $Res Function(_$DocumentDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pages = null,
  }) {
    return _then(
      _$DocumentDetailImpl(
        documentId: null == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        pages: null == pages
            ? _value._pages
            : pages // ignore: cast_nullable_to_non_nullable
                  as List<Page>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentDetailImpl implements _DocumentDetail {
  const _$DocumentDetailImpl({
    required this.documentId,
    required this.title,
    final List<String> tags = const [],
    @HighPrecisionDateTimeConverter() required this.createdAt,
    @HighPrecisionDateTimeConverter() required this.updatedAt,
    final List<Page> pages = const [],
  }) : _tags = tags,
       _pages = pages;

  factory _$DocumentDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentDetailImplFromJson(json);

  @override
  final String documentId;
  @override
  final String title;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HighPrecisionDateTimeConverter()
  final DateTime createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  final DateTime updatedAt;
  final List<Page> _pages;
  @override
  @JsonKey()
  List<Page> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  @override
  String toString() {
    return 'DocumentDetail(documentId: $documentId, title: $title, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, pages: $pages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentDetailImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._pages, _pages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    documentId,
    title,
    const DeepCollectionEquality().hash(_tags),
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_pages),
  );

  /// Create a copy of DocumentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentDetailImplCopyWith<_$DocumentDetailImpl> get copyWith =>
      __$$DocumentDetailImplCopyWithImpl<_$DocumentDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentDetailImplToJson(this);
  }
}

abstract class _DocumentDetail implements DocumentDetail {
  const factory _DocumentDetail({
    required final String documentId,
    required final String title,
    final List<String> tags,
    @HighPrecisionDateTimeConverter() required final DateTime createdAt,
    @HighPrecisionDateTimeConverter() required final DateTime updatedAt,
    final List<Page> pages,
  }) = _$DocumentDetailImpl;

  factory _DocumentDetail.fromJson(Map<String, dynamic> json) =
      _$DocumentDetailImpl.fromJson;

  @override
  String get documentId;
  @override
  String get title;
  @override
  List<String> get tags;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get createdAt;
  @override
  @HighPrecisionDateTimeConverter()
  DateTime get updatedAt;
  @override
  List<Page> get pages;

  /// Create a copy of DocumentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentDetailImplCopyWith<_$DocumentDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentStats _$DocumentStatsFromJson(Map<String, dynamic> json) {
  return _DocumentStats.fromJson(json);
}

/// @nodoc
mixin _$DocumentStats {
  int get totalDocuments => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this DocumentStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentStatsCopyWith<DocumentStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentStatsCopyWith<$Res> {
  factory $DocumentStatsCopyWith(
    DocumentStats value,
    $Res Function(DocumentStats) then,
  ) = _$DocumentStatsCopyWithImpl<$Res, DocumentStats>;
  @useResult
  $Res call({int totalDocuments, int totalPages});
}

/// @nodoc
class _$DocumentStatsCopyWithImpl<$Res, $Val extends DocumentStats>
    implements $DocumentStatsCopyWith<$Res> {
  _$DocumentStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalDocuments = null, Object? totalPages = null}) {
    return _then(
      _value.copyWith(
            totalDocuments: null == totalDocuments
                ? _value.totalDocuments
                : totalDocuments // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentStatsImplCopyWith<$Res>
    implements $DocumentStatsCopyWith<$Res> {
  factory _$$DocumentStatsImplCopyWith(
    _$DocumentStatsImpl value,
    $Res Function(_$DocumentStatsImpl) then,
  ) = __$$DocumentStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalDocuments, int totalPages});
}

/// @nodoc
class __$$DocumentStatsImplCopyWithImpl<$Res>
    extends _$DocumentStatsCopyWithImpl<$Res, _$DocumentStatsImpl>
    implements _$$DocumentStatsImplCopyWith<$Res> {
  __$$DocumentStatsImplCopyWithImpl(
    _$DocumentStatsImpl _value,
    $Res Function(_$DocumentStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalDocuments = null, Object? totalPages = null}) {
    return _then(
      _$DocumentStatsImpl(
        totalDocuments: null == totalDocuments
            ? _value.totalDocuments
            : totalDocuments // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentStatsImpl implements _DocumentStats {
  const _$DocumentStatsImpl({
    required this.totalDocuments,
    required this.totalPages,
  });

  factory _$DocumentStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentStatsImplFromJson(json);

  @override
  final int totalDocuments;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'DocumentStats(totalDocuments: $totalDocuments, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentStatsImpl &&
            (identical(other.totalDocuments, totalDocuments) ||
                other.totalDocuments == totalDocuments) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalDocuments, totalPages);

  /// Create a copy of DocumentStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentStatsImplCopyWith<_$DocumentStatsImpl> get copyWith =>
      __$$DocumentStatsImplCopyWithImpl<_$DocumentStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentStatsImplToJson(this);
  }
}

abstract class _DocumentStats implements DocumentStats {
  const factory _DocumentStats({
    required final int totalDocuments,
    required final int totalPages,
  }) = _$DocumentStatsImpl;

  factory _DocumentStats.fromJson(Map<String, dynamic> json) =
      _$DocumentStatsImpl.fromJson;

  @override
  int get totalDocuments;
  @override
  int get totalPages;

  /// Create a copy of DocumentStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentStatsImplCopyWith<_$DocumentStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
