// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AboutResponse {

 String get appName; String get version; String get serverName; String get serverIcon; String get description; String get contact; String? get serverId;
/// Create a copy of AboutResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutResponseCopyWith<AboutResponse> get copyWith => _$AboutResponseCopyWithImpl<AboutResponse>(this as AboutResponse, _$identity);

  /// Serializes this AboutResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutResponse&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.version, version) || other.version == version)&&(identical(other.serverName, serverName) || other.serverName == serverName)&&(identical(other.serverIcon, serverIcon) || other.serverIcon == serverIcon)&&(identical(other.description, description) || other.description == description)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.serverId, serverId) || other.serverId == serverId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,version,serverName,serverIcon,description,contact,serverId);

@override
String toString() {
  return 'AboutResponse(appName: $appName, version: $version, serverName: $serverName, serverIcon: $serverIcon, description: $description, contact: $contact, serverId: $serverId)';
}


}

/// @nodoc
abstract mixin class $AboutResponseCopyWith<$Res>  {
  factory $AboutResponseCopyWith(AboutResponse value, $Res Function(AboutResponse) _then) = _$AboutResponseCopyWithImpl;
@useResult
$Res call({
 String appName, String version, String serverName, String serverIcon, String description, String contact, String? serverId
});




}
/// @nodoc
class _$AboutResponseCopyWithImpl<$Res>
    implements $AboutResponseCopyWith<$Res> {
  _$AboutResponseCopyWithImpl(this._self, this._then);

  final AboutResponse _self;
  final $Res Function(AboutResponse) _then;

/// Create a copy of AboutResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = null,Object? version = null,Object? serverName = null,Object? serverIcon = null,Object? description = null,Object? contact = null,Object? serverId = freezed,}) {
  return _then(_self.copyWith(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,serverName: null == serverName ? _self.serverName : serverName // ignore: cast_nullable_to_non_nullable
as String,serverIcon: null == serverIcon ? _self.serverIcon : serverIcon // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AboutResponse].
extension AboutResponsePatterns on AboutResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AboutResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AboutResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AboutResponse value)  $default,){
final _that = this;
switch (_that) {
case _AboutResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AboutResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AboutResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appName,  String version,  String serverName,  String serverIcon,  String description,  String contact,  String? serverId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AboutResponse() when $default != null:
return $default(_that.appName,_that.version,_that.serverName,_that.serverIcon,_that.description,_that.contact,_that.serverId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appName,  String version,  String serverName,  String serverIcon,  String description,  String contact,  String? serverId)  $default,) {final _that = this;
switch (_that) {
case _AboutResponse():
return $default(_that.appName,_that.version,_that.serverName,_that.serverIcon,_that.description,_that.contact,_that.serverId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appName,  String version,  String serverName,  String serverIcon,  String description,  String contact,  String? serverId)?  $default,) {final _that = this;
switch (_that) {
case _AboutResponse() when $default != null:
return $default(_that.appName,_that.version,_that.serverName,_that.serverIcon,_that.description,_that.contact,_that.serverId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AboutResponse implements AboutResponse {
  const _AboutResponse({required this.appName, required this.version, required this.serverName, required this.serverIcon, required this.description, required this.contact, this.serverId});
  factory _AboutResponse.fromJson(Map<String, dynamic> json) => _$AboutResponseFromJson(json);

@override final  String appName;
@override final  String version;
@override final  String serverName;
@override final  String serverIcon;
@override final  String description;
@override final  String contact;
@override final  String? serverId;

/// Create a copy of AboutResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutResponseCopyWith<_AboutResponse> get copyWith => __$AboutResponseCopyWithImpl<_AboutResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AboutResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutResponse&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.version, version) || other.version == version)&&(identical(other.serverName, serverName) || other.serverName == serverName)&&(identical(other.serverIcon, serverIcon) || other.serverIcon == serverIcon)&&(identical(other.description, description) || other.description == description)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.serverId, serverId) || other.serverId == serverId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,version,serverName,serverIcon,description,contact,serverId);

@override
String toString() {
  return 'AboutResponse(appName: $appName, version: $version, serverName: $serverName, serverIcon: $serverIcon, description: $description, contact: $contact, serverId: $serverId)';
}


}

/// @nodoc
abstract mixin class _$AboutResponseCopyWith<$Res> implements $AboutResponseCopyWith<$Res> {
  factory _$AboutResponseCopyWith(_AboutResponse value, $Res Function(_AboutResponse) _then) = __$AboutResponseCopyWithImpl;
@override @useResult
$Res call({
 String appName, String version, String serverName, String serverIcon, String description, String contact, String? serverId
});




}
/// @nodoc
class __$AboutResponseCopyWithImpl<$Res>
    implements _$AboutResponseCopyWith<$Res> {
  __$AboutResponseCopyWithImpl(this._self, this._then);

  final _AboutResponse _self;
  final $Res Function(_AboutResponse) _then;

/// Create a copy of AboutResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? version = null,Object? serverName = null,Object? serverIcon = null,Object? description = null,Object? contact = null,Object? serverId = freezed,}) {
  return _then(_AboutResponse(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,serverName: null == serverName ? _self.serverName : serverName // ignore: cast_nullable_to_non_nullable
as String,serverIcon: null == serverIcon ? _self.serverIcon : serverIcon // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
