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
  // Core list properties
  List<Document> get documents => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  bool get hasReachedMax =>
      throw _privateConstructorUsedError; // --- START: NEW SORTING AND FILTERING STATE ---
  // Sorting
  SortOption get sortOption =>
      throw _privateConstructorUsedError; // Tag Filtering
  List<String> get selectedTags => throw _privateConstructorUsedError;
  List<String> get allTags => throw _privateConstructorUsedError;
  bool get areTagsLoading => throw _privateConstructorUsedError;
  String? get tagsError => throw _privateConstructorUsedError;

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
    List<Document> documents,
    bool isLoading,
    String? error,
    int pageNumber,
    bool hasReachedMax,
    SortOption sortOption,
    List<String> selectedTags,
    List<String> allTags,
    bool areTagsLoading,
    String? tagsError,
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
    Object? documents = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? pageNumber = null,
    Object? hasReachedMax = null,
    Object? sortOption = null,
    Object? selectedTags = null,
    Object? allTags = null,
    Object? areTagsLoading = null,
    Object? tagsError = freezed,
  }) {
    return _then(
      _value.copyWith(
            documents: null == documents
                ? _value.documents
                : documents // ignore: cast_nullable_to_non_nullable
                      as List<Document>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            pageNumber: null == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            hasReachedMax: null == hasReachedMax
                ? _value.hasReachedMax
                : hasReachedMax // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOption: null == sortOption
                ? _value.sortOption
                : sortOption // ignore: cast_nullable_to_non_nullable
                      as SortOption,
            selectedTags: null == selectedTags
                ? _value.selectedTags
                : selectedTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            allTags: null == allTags
                ? _value.allTags
                : allTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            areTagsLoading: null == areTagsLoading
                ? _value.areTagsLoading
                : areTagsLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            tagsError: freezed == tagsError
                ? _value.tagsError
                : tagsError // ignore: cast_nullable_to_non_nullable
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
    List<Document> documents,
    bool isLoading,
    String? error,
    int pageNumber,
    bool hasReachedMax,
    SortOption sortOption,
    List<String> selectedTags,
    List<String> allTags,
    bool areTagsLoading,
    String? tagsError,
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
    Object? documents = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? pageNumber = null,
    Object? hasReachedMax = null,
    Object? sortOption = null,
    Object? selectedTags = null,
    Object? allTags = null,
    Object? areTagsLoading = null,
    Object? tagsError = freezed,
  }) {
    return _then(
      _$DocumentListStateImpl(
        documents: null == documents
            ? _value._documents
            : documents // ignore: cast_nullable_to_non_nullable
                  as List<Document>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        pageNumber: null == pageNumber
            ? _value.pageNumber
            : pageNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        hasReachedMax: null == hasReachedMax
            ? _value.hasReachedMax
            : hasReachedMax // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOption: null == sortOption
            ? _value.sortOption
            : sortOption // ignore: cast_nullable_to_non_nullable
                  as SortOption,
        selectedTags: null == selectedTags
            ? _value._selectedTags
            : selectedTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        allTags: null == allTags
            ? _value._allTags
            : allTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        areTagsLoading: null == areTagsLoading
            ? _value.areTagsLoading
            : areTagsLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        tagsError: freezed == tagsError
            ? _value.tagsError
            : tagsError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DocumentListStateImpl implements _DocumentListState {
  const _$DocumentListStateImpl({
    final List<Document> documents = const [],
    this.isLoading = false,
    this.error = null,
    this.pageNumber = 1,
    this.hasReachedMax = false,
    this.sortOption = SortOption.dateDesc,
    final List<String> selectedTags = const [],
    final List<String> allTags = const [],
    this.areTagsLoading = false,
    this.tagsError = null,
  }) : _documents = documents,
       _selectedTags = selectedTags,
       _allTags = allTags;

  // Core list properties
  final List<Document> _documents;
  // Core list properties
  @override
  @JsonKey()
  List<Document> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final int pageNumber;
  @override
  @JsonKey()
  final bool hasReachedMax;
  // --- START: NEW SORTING AND FILTERING STATE ---
  // Sorting
  @override
  @JsonKey()
  final SortOption sortOption;
  // Tag Filtering
  final List<String> _selectedTags;
  // Tag Filtering
  @override
  @JsonKey()
  List<String> get selectedTags {
    if (_selectedTags is EqualUnmodifiableListView) return _selectedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedTags);
  }

  final List<String> _allTags;
  @override
  @JsonKey()
  List<String> get allTags {
    if (_allTags is EqualUnmodifiableListView) return _allTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allTags);
  }

  @override
  @JsonKey()
  final bool areTagsLoading;
  @override
  @JsonKey()
  final String? tagsError;

  @override
  String toString() {
    return 'DocumentListState(documents: $documents, isLoading: $isLoading, error: $error, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, sortOption: $sortOption, selectedTags: $selectedTags, allTags: $allTags, areTagsLoading: $areTagsLoading, tagsError: $tagsError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentListStateImpl &&
            const DeepCollectionEquality().equals(
              other._documents,
              _documents,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.sortOption, sortOption) ||
                other.sortOption == sortOption) &&
            const DeepCollectionEquality().equals(
              other._selectedTags,
              _selectedTags,
            ) &&
            const DeepCollectionEquality().equals(other._allTags, _allTags) &&
            (identical(other.areTagsLoading, areTagsLoading) ||
                other.areTagsLoading == areTagsLoading) &&
            (identical(other.tagsError, tagsError) ||
                other.tagsError == tagsError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_documents),
    isLoading,
    error,
    pageNumber,
    hasReachedMax,
    sortOption,
    const DeepCollectionEquality().hash(_selectedTags),
    const DeepCollectionEquality().hash(_allTags),
    areTagsLoading,
    tagsError,
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
    final List<Document> documents,
    final bool isLoading,
    final String? error,
    final int pageNumber,
    final bool hasReachedMax,
    final SortOption sortOption,
    final List<String> selectedTags,
    final List<String> allTags,
    final bool areTagsLoading,
    final String? tagsError,
  }) = _$DocumentListStateImpl;

  // Core list properties
  @override
  List<Document> get documents;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  int get pageNumber;
  @override
  bool get hasReachedMax; // --- START: NEW SORTING AND FILTERING STATE ---
  // Sorting
  @override
  SortOption get sortOption; // Tag Filtering
  @override
  List<String> get selectedTags;
  @override
  List<String> get allTags;
  @override
  bool get areTagsLoading;
  @override
  String? get tagsError;

  /// Create a copy of DocumentListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentListStateImplCopyWith<_$DocumentListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
