// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanner_management_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScannerManagementState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerManagementState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerManagementState()';
}


}

/// @nodoc
class $ScannerManagementStateCopyWith<$Res>  {
$ScannerManagementStateCopyWith(ScannerManagementState _, $Res Function(ScannerManagementState) __);
}


/// Adds pattern-matching-related methods to [ScannerManagementState].
extension ScannerManagementStatePatterns on ScannerManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScannerManagementInitial value)?  initial,TResult Function( ScannerManagementLoading value)?  loading,TResult Function( ScannerManagementDiscovering value)?  discovering,TResult Function( ScannerManagementLoaded value)?  loaded,TResult Function( ScannerManagementError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScannerManagementInitial() when initial != null:
return initial(_that);case ScannerManagementLoading() when loading != null:
return loading(_that);case ScannerManagementDiscovering() when discovering != null:
return discovering(_that);case ScannerManagementLoaded() when loaded != null:
return loaded(_that);case ScannerManagementError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScannerManagementInitial value)  initial,required TResult Function( ScannerManagementLoading value)  loading,required TResult Function( ScannerManagementDiscovering value)  discovering,required TResult Function( ScannerManagementLoaded value)  loaded,required TResult Function( ScannerManagementError value)  error,}){
final _that = this;
switch (_that) {
case ScannerManagementInitial():
return initial(_that);case ScannerManagementLoading():
return loading(_that);case ScannerManagementDiscovering():
return discovering(_that);case ScannerManagementLoaded():
return loaded(_that);case ScannerManagementError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScannerManagementInitial value)?  initial,TResult? Function( ScannerManagementLoading value)?  loading,TResult? Function( ScannerManagementDiscovering value)?  discovering,TResult? Function( ScannerManagementLoaded value)?  loaded,TResult? Function( ScannerManagementError value)?  error,}){
final _that = this;
switch (_that) {
case ScannerManagementInitial() when initial != null:
return initial(_that);case ScannerManagementLoading() when loading != null:
return loading(_that);case ScannerManagementDiscovering() when discovering != null:
return discovering(_that);case ScannerManagementLoaded() when loaded != null:
return loaded(_that);case ScannerManagementError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SavedScannerConfig> savedScanners)?  discovering,TResult Function( List<SavedScannerConfig> savedScanners,  List<ScannerInfo> discoveredScanners)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScannerManagementInitial() when initial != null:
return initial();case ScannerManagementLoading() when loading != null:
return loading();case ScannerManagementDiscovering() when discovering != null:
return discovering(_that.savedScanners);case ScannerManagementLoaded() when loaded != null:
return loaded(_that.savedScanners,_that.discoveredScanners);case ScannerManagementError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SavedScannerConfig> savedScanners)  discovering,required TResult Function( List<SavedScannerConfig> savedScanners,  List<ScannerInfo> discoveredScanners)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ScannerManagementInitial():
return initial();case ScannerManagementLoading():
return loading();case ScannerManagementDiscovering():
return discovering(_that.savedScanners);case ScannerManagementLoaded():
return loaded(_that.savedScanners,_that.discoveredScanners);case ScannerManagementError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SavedScannerConfig> savedScanners)?  discovering,TResult? Function( List<SavedScannerConfig> savedScanners,  List<ScannerInfo> discoveredScanners)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ScannerManagementInitial() when initial != null:
return initial();case ScannerManagementLoading() when loading != null:
return loading();case ScannerManagementDiscovering() when discovering != null:
return discovering(_that.savedScanners);case ScannerManagementLoaded() when loaded != null:
return loaded(_that.savedScanners,_that.discoveredScanners);case ScannerManagementError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ScannerManagementInitial implements ScannerManagementState {
  const ScannerManagementInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerManagementInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerManagementState.initial()';
}


}




/// @nodoc


class ScannerManagementLoading implements ScannerManagementState {
  const ScannerManagementLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerManagementLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerManagementState.loading()';
}


}




/// @nodoc


class ScannerManagementDiscovering implements ScannerManagementState {
  const ScannerManagementDiscovering(final  List<SavedScannerConfig> savedScanners): _savedScanners = savedScanners;
  

 final  List<SavedScannerConfig> _savedScanners;
 List<SavedScannerConfig> get savedScanners {
  if (_savedScanners is EqualUnmodifiableListView) return _savedScanners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savedScanners);
}


/// Create a copy of ScannerManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannerManagementDiscoveringCopyWith<ScannerManagementDiscovering> get copyWith => _$ScannerManagementDiscoveringCopyWithImpl<ScannerManagementDiscovering>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerManagementDiscovering&&const DeepCollectionEquality().equals(other._savedScanners, _savedScanners));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_savedScanners));

@override
String toString() {
  return 'ScannerManagementState.discovering(savedScanners: $savedScanners)';
}


}

/// @nodoc
abstract mixin class $ScannerManagementDiscoveringCopyWith<$Res> implements $ScannerManagementStateCopyWith<$Res> {
  factory $ScannerManagementDiscoveringCopyWith(ScannerManagementDiscovering value, $Res Function(ScannerManagementDiscovering) _then) = _$ScannerManagementDiscoveringCopyWithImpl;
@useResult
$Res call({
 List<SavedScannerConfig> savedScanners
});




}
/// @nodoc
class _$ScannerManagementDiscoveringCopyWithImpl<$Res>
    implements $ScannerManagementDiscoveringCopyWith<$Res> {
  _$ScannerManagementDiscoveringCopyWithImpl(this._self, this._then);

  final ScannerManagementDiscovering _self;
  final $Res Function(ScannerManagementDiscovering) _then;

/// Create a copy of ScannerManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? savedScanners = null,}) {
  return _then(ScannerManagementDiscovering(
null == savedScanners ? _self._savedScanners : savedScanners // ignore: cast_nullable_to_non_nullable
as List<SavedScannerConfig>,
  ));
}


}

/// @nodoc


class ScannerManagementLoaded implements ScannerManagementState {
  const ScannerManagementLoaded({required final  List<SavedScannerConfig> savedScanners, required final  List<ScannerInfo> discoveredScanners}): _savedScanners = savedScanners,_discoveredScanners = discoveredScanners;
  

 final  List<SavedScannerConfig> _savedScanners;
 List<SavedScannerConfig> get savedScanners {
  if (_savedScanners is EqualUnmodifiableListView) return _savedScanners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savedScanners);
}

 final  List<ScannerInfo> _discoveredScanners;
 List<ScannerInfo> get discoveredScanners {
  if (_discoveredScanners is EqualUnmodifiableListView) return _discoveredScanners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discoveredScanners);
}


/// Create a copy of ScannerManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannerManagementLoadedCopyWith<ScannerManagementLoaded> get copyWith => _$ScannerManagementLoadedCopyWithImpl<ScannerManagementLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerManagementLoaded&&const DeepCollectionEquality().equals(other._savedScanners, _savedScanners)&&const DeepCollectionEquality().equals(other._discoveredScanners, _discoveredScanners));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_savedScanners),const DeepCollectionEquality().hash(_discoveredScanners));

@override
String toString() {
  return 'ScannerManagementState.loaded(savedScanners: $savedScanners, discoveredScanners: $discoveredScanners)';
}


}

/// @nodoc
abstract mixin class $ScannerManagementLoadedCopyWith<$Res> implements $ScannerManagementStateCopyWith<$Res> {
  factory $ScannerManagementLoadedCopyWith(ScannerManagementLoaded value, $Res Function(ScannerManagementLoaded) _then) = _$ScannerManagementLoadedCopyWithImpl;
@useResult
$Res call({
 List<SavedScannerConfig> savedScanners, List<ScannerInfo> discoveredScanners
});




}
/// @nodoc
class _$ScannerManagementLoadedCopyWithImpl<$Res>
    implements $ScannerManagementLoadedCopyWith<$Res> {
  _$ScannerManagementLoadedCopyWithImpl(this._self, this._then);

  final ScannerManagementLoaded _self;
  final $Res Function(ScannerManagementLoaded) _then;

/// Create a copy of ScannerManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? savedScanners = null,Object? discoveredScanners = null,}) {
  return _then(ScannerManagementLoaded(
savedScanners: null == savedScanners ? _self._savedScanners : savedScanners // ignore: cast_nullable_to_non_nullable
as List<SavedScannerConfig>,discoveredScanners: null == discoveredScanners ? _self._discoveredScanners : discoveredScanners // ignore: cast_nullable_to_non_nullable
as List<ScannerInfo>,
  ));
}


}

/// @nodoc


class ScannerManagementError implements ScannerManagementState {
  const ScannerManagementError(this.message);
  

 final  String message;

/// Create a copy of ScannerManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannerManagementErrorCopyWith<ScannerManagementError> get copyWith => _$ScannerManagementErrorCopyWithImpl<ScannerManagementError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerManagementError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ScannerManagementState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ScannerManagementErrorCopyWith<$Res> implements $ScannerManagementStateCopyWith<$Res> {
  factory $ScannerManagementErrorCopyWith(ScannerManagementError value, $Res Function(ScannerManagementError) _then) = _$ScannerManagementErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ScannerManagementErrorCopyWithImpl<$Res>
    implements $ScannerManagementErrorCopyWith<$Res> {
  _$ScannerManagementErrorCopyWithImpl(this._self, this._then);

  final ScannerManagementError _self;
  final $Res Function(ScannerManagementError) _then;

/// Create a copy of ScannerManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ScannerManagementError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
