// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PageListState {
  PageListStatus get status => throw _privateConstructorUsedError;
  List<Page> get pages => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PageListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageListStateCopyWith<PageListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageListStateCopyWith<$Res> {
  factory $PageListStateCopyWith(
    PageListState value,
    $Res Function(PageListState) then,
  ) = _$PageListStateCopyWithImpl<$Res, PageListState>;
  @useResult
  $Res call({
    PageListStatus status,
    List<Page> pages,
    int pageNumber,
    bool hasReachedMax,
    String? errorMessage,
  });
}

/// @nodoc
class _$PageListStateCopyWithImpl<$Res, $Val extends PageListState>
    implements $PageListStateCopyWith<$Res> {
  _$PageListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pages = null,
    Object? pageNumber = null,
    Object? hasReachedMax = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PageListStatus,
            pages: null == pages
                ? _value.pages
                : pages // ignore: cast_nullable_to_non_nullable
                      as List<Page>,
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
abstract class _$$PageListStateImplCopyWith<$Res>
    implements $PageListStateCopyWith<$Res> {
  factory _$$PageListStateImplCopyWith(
    _$PageListStateImpl value,
    $Res Function(_$PageListStateImpl) then,
  ) = __$$PageListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PageListStatus status,
    List<Page> pages,
    int pageNumber,
    bool hasReachedMax,
    String? errorMessage,
  });
}

/// @nodoc
class __$$PageListStateImplCopyWithImpl<$Res>
    extends _$PageListStateCopyWithImpl<$Res, _$PageListStateImpl>
    implements _$$PageListStateImplCopyWith<$Res> {
  __$$PageListStateImplCopyWithImpl(
    _$PageListStateImpl _value,
    $Res Function(_$PageListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PageListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pages = null,
    Object? pageNumber = null,
    Object? hasReachedMax = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$PageListStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PageListStatus,
        pages: null == pages
            ? _value._pages
            : pages // ignore: cast_nullable_to_non_nullable
                  as List<Page>,
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

class _$PageListStateImpl implements _PageListState {
  const _$PageListStateImpl({
    this.status = PageListStatus.initial,
    final List<Page> pages = const [],
    this.pageNumber = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  }) : _pages = pages;

  @override
  @JsonKey()
  final PageListStatus status;
  final List<Page> _pages;
  @override
  @JsonKey()
  List<Page> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
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
    return 'PageListState(status: $status, pages: $pages, pageNumber: $pageNumber, hasReachedMax: $hasReachedMax, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageListStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
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
    const DeepCollectionEquality().hash(_pages),
    pageNumber,
    hasReachedMax,
    errorMessage,
  );

  /// Create a copy of PageListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageListStateImplCopyWith<_$PageListStateImpl> get copyWith =>
      __$$PageListStateImplCopyWithImpl<_$PageListStateImpl>(this, _$identity);
}

abstract class _PageListState implements PageListState {
  const factory _PageListState({
    final PageListStatus status,
    final List<Page> pages,
    final int pageNumber,
    final bool hasReachedMax,
    final String? errorMessage,
  }) = _$PageListStateImpl;

  @override
  PageListStatus get status;
  @override
  List<Page> get pages;
  @override
  int get pageNumber;
  @override
  bool get hasReachedMax;
  @override
  String? get errorMessage;

  /// Create a copy of PageListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageListStateImplCopyWith<_$PageListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
