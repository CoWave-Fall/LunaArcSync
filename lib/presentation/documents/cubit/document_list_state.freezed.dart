// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DocumentListState {
  DocumentListStatus get status => throw _privateConstructorUsedError;
  List<Document> get documents => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DocumentListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentListStateCopyWith<DocumentListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentListStateCopyWith<$Res> {
  factory $DocumentListStateCopyWith(
    DocumentListState value,
    $Res Function(DocumentListState) then,
  ) = _$DocumentListStateCopyWithImpl<$Res, DocumentListState>;
  @useResult
  $Res call({
    DocumentListStatus status,
    List<Document> documents,
    int pageNumber,
    bool hasReachedMax,
    String? errorMessage,
  });
}

/// @nodoc
class _$DocumentListStateCopyWithImpl<$Res, $Val extends DocumentListState>
    implements $DocumentListStateCopyWith<$Res> {
  _$DocumentListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? documents = null,
    Object? pageNumber = null,
    Object? hasReachedMax = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DocumentListStatus,
            documents: null == documents
                ? _value.documents
                : documents // ignore: cast_nullable_to_non_nullable
                      as List<Document>,
            pageNumber: null == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            hasReachedMax: null == hasReachedMax
                ? _value.hasReachedMax
                : hasReachedMax // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentListStateImplCopyWith<$Res>
    implements $DocumentListStateCopyWith<$Res> {
  factory _$$DocumentListStateImplCopyWith(
    _$DocumentListStateImpl value,
    $Res Function(_$DocumentListStateImpl) then,
  ) = __$$DocumentListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DocumentListStatus status,
    List<Document> documents,
    int pageNumber,
    bool hasReachedMax,
    String? errorMessage,
  });
}

/// @nodoc
class __$$DocumentListStateImplCopyWithImpl<$Res>
    extends _$DocumentListStateCopyWithImpl<$Res, _$DocumentListStateImpl>
    implements _$$DocumentListStateImplCopyWith<$Res> {
  __$$DocumentListStateImplCopyWithImpl(
    _$DocumentListStateImpl _value,
    $Res Function(_$DocumentListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? documents = null,
    Object? pageNumber = null,
    Object? hasReachedMax = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DocumentListStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DocumentListStatus,
        documents: null == documents
            ? _value._documents
            : documents // ignore: cast_nullable_to_non_nullable
                  as List<Document>,
        pageNumber: null == pageNumber
            ? _value.pageNumber
            : pageNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        hasReachedMax: null == hasReachedMax
            ? _value.hasReachedMax
            : hasReachedMax // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DocumentListStateImpl implements _DocumentListState {
  const _$DocumentListStateImpl({
    this.status = DocumentListStatus.initial,
    final List<Document> documents = const [],
    this.pageNumber = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  }) : _documents = documents;

  @override
  @JsonKey()
  final DocumentListStatus status;
  final List<Document> _documents;
  @override
  @JsonKey()
  List<Document> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  @JsonKey()
  final int pageNumber;
  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DocumentListState(status: $status, documents: $documents, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentListStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._documents,
              _documents,
            ) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_documents),
    pageNumber,
    hasReachedMax,
    errorMessage,
  );

  /// Create a copy of DocumentListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentListStateImplCopyWith<_$DocumentListStateImpl> get copyWith =>
      __$$DocumentListStateImplCopyWithImpl<_$DocumentListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DocumentListState implements DocumentListState {
  const factory _DocumentListState({
    final DocumentListStatus status,
    final List<Document> documents,
    final int pageNumber,
    final bool hasReachedMax,
    final String? errorMessage,
  }) = _$DocumentListStateImpl;

  @override
  DocumentListStatus get status;
  @override
  List<Document> get documents;
  @override
  int get pageNumber;
  @override
  bool get hasReachedMax;
  @override
  String? get errorMessage;

  /// Create a copy of DocumentListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentListStateImplCopyWith<_$DocumentListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
