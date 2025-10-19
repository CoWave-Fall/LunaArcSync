// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {

 String get id; String get username; String get nickname; String get email; String? get avatar; String? get bio; bool get isAdmin; bool get isActive;@UnixTimestampConverter() DateTime get createdAt;@UnixTimestampConverter() DateTime? get lastLoginAt; int get documentCount; int get pageCount;
/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDtoCopyWith<UserDto> get copyWith => _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.documentCount, documentCount) || other.documentCount == documentCount)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,nickname,email,avatar,bio,isAdmin,isActive,createdAt,lastLoginAt,documentCount,pageCount);

@override
String toString() {
  return 'UserDto(id: $id, username: $username, nickname: $nickname, email: $email, avatar: $avatar, bio: $bio, isAdmin: $isAdmin, isActive: $isActive, createdAt: $createdAt, lastLoginAt: $lastLoginAt, documentCount: $documentCount, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res>  {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) = _$UserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String nickname, String email, String? avatar, String? bio, bool isAdmin, bool isActive,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime? lastLoginAt, int documentCount, int pageCount
});




}
/// @nodoc
class _$UserDtoCopyWithImpl<$Res>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? nickname = null,Object? email = null,Object? avatar = freezed,Object? bio = freezed,Object? isAdmin = null,Object? isActive = null,Object? createdAt = null,Object? lastLoginAt = freezed,Object? documentCount = null,Object? pageCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentCount: null == documentCount ? _self.documentCount : documentCount // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDto value)  $default,){
final _that = this;
switch (_that) {
case _UserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String nickname,  String email,  String? avatar,  String? bio,  bool isAdmin,  bool isActive, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime? lastLoginAt,  int documentCount,  int pageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.username,_that.nickname,_that.email,_that.avatar,_that.bio,_that.isAdmin,_that.isActive,_that.createdAt,_that.lastLoginAt,_that.documentCount,_that.pageCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String nickname,  String email,  String? avatar,  String? bio,  bool isAdmin,  bool isActive, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime? lastLoginAt,  int documentCount,  int pageCount)  $default,) {final _that = this;
switch (_that) {
case _UserDto():
return $default(_that.id,_that.username,_that.nickname,_that.email,_that.avatar,_that.bio,_that.isAdmin,_that.isActive,_that.createdAt,_that.lastLoginAt,_that.documentCount,_that.pageCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String nickname,  String email,  String? avatar,  String? bio,  bool isAdmin,  bool isActive, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime? lastLoginAt,  int documentCount,  int pageCount)?  $default,) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.username,_that.nickname,_that.email,_that.avatar,_that.bio,_that.isAdmin,_that.isActive,_that.createdAt,_that.lastLoginAt,_that.documentCount,_that.pageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDto implements UserDto {
  const _UserDto({required this.id, required this.username, required this.nickname, required this.email, this.avatar, this.bio, required this.isAdmin, required this.isActive, @UnixTimestampConverter() required this.createdAt, @UnixTimestampConverter() this.lastLoginAt, required this.documentCount, required this.pageCount});
  factory _UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String nickname;
@override final  String email;
@override final  String? avatar;
@override final  String? bio;
@override final  bool isAdmin;
@override final  bool isActive;
@override@UnixTimestampConverter() final  DateTime createdAt;
@override@UnixTimestampConverter() final  DateTime? lastLoginAt;
@override final  int documentCount;
@override final  int pageCount;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDtoCopyWith<_UserDto> get copyWith => __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.documentCount, documentCount) || other.documentCount == documentCount)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,nickname,email,avatar,bio,isAdmin,isActive,createdAt,lastLoginAt,documentCount,pageCount);

@override
String toString() {
  return 'UserDto(id: $id, username: $username, nickname: $nickname, email: $email, avatar: $avatar, bio: $bio, isAdmin: $isAdmin, isActive: $isActive, createdAt: $createdAt, lastLoginAt: $lastLoginAt, documentCount: $documentCount, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) = __$UserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String nickname, String email, String? avatar, String? bio, bool isAdmin, bool isActive,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime? lastLoginAt, int documentCount, int pageCount
});




}
/// @nodoc
class __$UserDtoCopyWithImpl<$Res>
    implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? nickname = null,Object? email = null,Object? avatar = freezed,Object? bio = freezed,Object? isAdmin = null,Object? isActive = null,Object? createdAt = null,Object? lastLoginAt = freezed,Object? documentCount = null,Object? pageCount = null,}) {
  return _then(_UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentCount: null == documentCount ? _self.documentCount : documentCount // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminUserListDto {

 String get id; String get email; bool get isAdmin; bool get isActive;@UnixTimestampConverter() DateTime get createdAt;@UnixTimestampConverter() DateTime? get lastLoginAt; int get documentCount; int get pageCount; int get totalStorageUsed;
/// Create a copy of AdminUserListDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserListDtoCopyWith<AdminUserListDto> get copyWith => _$AdminUserListDtoCopyWithImpl<AdminUserListDto>(this as AdminUserListDto, _$identity);

  /// Serializes this AdminUserListDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserListDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.documentCount, documentCount) || other.documentCount == documentCount)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.totalStorageUsed, totalStorageUsed) || other.totalStorageUsed == totalStorageUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,isAdmin,isActive,createdAt,lastLoginAt,documentCount,pageCount,totalStorageUsed);

@override
String toString() {
  return 'AdminUserListDto(id: $id, email: $email, isAdmin: $isAdmin, isActive: $isActive, createdAt: $createdAt, lastLoginAt: $lastLoginAt, documentCount: $documentCount, pageCount: $pageCount, totalStorageUsed: $totalStorageUsed)';
}


}

/// @nodoc
abstract mixin class $AdminUserListDtoCopyWith<$Res>  {
  factory $AdminUserListDtoCopyWith(AdminUserListDto value, $Res Function(AdminUserListDto) _then) = _$AdminUserListDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, bool isAdmin, bool isActive,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime? lastLoginAt, int documentCount, int pageCount, int totalStorageUsed
});




}
/// @nodoc
class _$AdminUserListDtoCopyWithImpl<$Res>
    implements $AdminUserListDtoCopyWith<$Res> {
  _$AdminUserListDtoCopyWithImpl(this._self, this._then);

  final AdminUserListDto _self;
  final $Res Function(AdminUserListDto) _then;

/// Create a copy of AdminUserListDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? isAdmin = null,Object? isActive = null,Object? createdAt = null,Object? lastLoginAt = freezed,Object? documentCount = null,Object? pageCount = null,Object? totalStorageUsed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentCount: null == documentCount ? _self.documentCount : documentCount // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,totalStorageUsed: null == totalStorageUsed ? _self.totalStorageUsed : totalStorageUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserListDto].
extension AdminUserListDtoPatterns on AdminUserListDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserListDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserListDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserListDto value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserListDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserListDto value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserListDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  bool isAdmin,  bool isActive, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime? lastLoginAt,  int documentCount,  int pageCount,  int totalStorageUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserListDto() when $default != null:
return $default(_that.id,_that.email,_that.isAdmin,_that.isActive,_that.createdAt,_that.lastLoginAt,_that.documentCount,_that.pageCount,_that.totalStorageUsed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  bool isAdmin,  bool isActive, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime? lastLoginAt,  int documentCount,  int pageCount,  int totalStorageUsed)  $default,) {final _that = this;
switch (_that) {
case _AdminUserListDto():
return $default(_that.id,_that.email,_that.isAdmin,_that.isActive,_that.createdAt,_that.lastLoginAt,_that.documentCount,_that.pageCount,_that.totalStorageUsed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  bool isAdmin,  bool isActive, @UnixTimestampConverter()  DateTime createdAt, @UnixTimestampConverter()  DateTime? lastLoginAt,  int documentCount,  int pageCount,  int totalStorageUsed)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserListDto() when $default != null:
return $default(_that.id,_that.email,_that.isAdmin,_that.isActive,_that.createdAt,_that.lastLoginAt,_that.documentCount,_that.pageCount,_that.totalStorageUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserListDto implements AdminUserListDto {
  const _AdminUserListDto({required this.id, required this.email, required this.isAdmin, required this.isActive, @UnixTimestampConverter() required this.createdAt, @UnixTimestampConverter() this.lastLoginAt, required this.documentCount, required this.pageCount, required this.totalStorageUsed});
  factory _AdminUserListDto.fromJson(Map<String, dynamic> json) => _$AdminUserListDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  bool isAdmin;
@override final  bool isActive;
@override@UnixTimestampConverter() final  DateTime createdAt;
@override@UnixTimestampConverter() final  DateTime? lastLoginAt;
@override final  int documentCount;
@override final  int pageCount;
@override final  int totalStorageUsed;

/// Create a copy of AdminUserListDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserListDtoCopyWith<_AdminUserListDto> get copyWith => __$AdminUserListDtoCopyWithImpl<_AdminUserListDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserListDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserListDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.documentCount, documentCount) || other.documentCount == documentCount)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.totalStorageUsed, totalStorageUsed) || other.totalStorageUsed == totalStorageUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,isAdmin,isActive,createdAt,lastLoginAt,documentCount,pageCount,totalStorageUsed);

@override
String toString() {
  return 'AdminUserListDto(id: $id, email: $email, isAdmin: $isAdmin, isActive: $isActive, createdAt: $createdAt, lastLoginAt: $lastLoginAt, documentCount: $documentCount, pageCount: $pageCount, totalStorageUsed: $totalStorageUsed)';
}


}

/// @nodoc
abstract mixin class _$AdminUserListDtoCopyWith<$Res> implements $AdminUserListDtoCopyWith<$Res> {
  factory _$AdminUserListDtoCopyWith(_AdminUserListDto value, $Res Function(_AdminUserListDto) _then) = __$AdminUserListDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, bool isAdmin, bool isActive,@UnixTimestampConverter() DateTime createdAt,@UnixTimestampConverter() DateTime? lastLoginAt, int documentCount, int pageCount, int totalStorageUsed
});




}
/// @nodoc
class __$AdminUserListDtoCopyWithImpl<$Res>
    implements _$AdminUserListDtoCopyWith<$Res> {
  __$AdminUserListDtoCopyWithImpl(this._self, this._then);

  final _AdminUserListDto _self;
  final $Res Function(_AdminUserListDto) _then;

/// Create a copy of AdminUserListDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? isAdmin = null,Object? isActive = null,Object? createdAt = null,Object? lastLoginAt = freezed,Object? documentCount = null,Object? pageCount = null,Object? totalStorageUsed = null,}) {
  return _then(_AdminUserListDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentCount: null == documentCount ? _self.documentCount : documentCount // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,totalStorageUsed: null == totalStorageUsed ? _self.totalStorageUsed : totalStorageUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateUserRoleDto {

 bool get isAdmin; bool get isActive;
/// Create a copy of UpdateUserRoleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserRoleDtoCopyWith<UpdateUserRoleDto> get copyWith => _$UpdateUserRoleDtoCopyWithImpl<UpdateUserRoleDto>(this as UpdateUserRoleDto, _$identity);

  /// Serializes this UpdateUserRoleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserRoleDto&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isAdmin,isActive);

@override
String toString() {
  return 'UpdateUserRoleDto(isAdmin: $isAdmin, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UpdateUserRoleDtoCopyWith<$Res>  {
  factory $UpdateUserRoleDtoCopyWith(UpdateUserRoleDto value, $Res Function(UpdateUserRoleDto) _then) = _$UpdateUserRoleDtoCopyWithImpl;
@useResult
$Res call({
 bool isAdmin, bool isActive
});




}
/// @nodoc
class _$UpdateUserRoleDtoCopyWithImpl<$Res>
    implements $UpdateUserRoleDtoCopyWith<$Res> {
  _$UpdateUserRoleDtoCopyWithImpl(this._self, this._then);

  final UpdateUserRoleDto _self;
  final $Res Function(UpdateUserRoleDto) _then;

/// Create a copy of UpdateUserRoleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAdmin = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserRoleDto].
extension UpdateUserRoleDtoPatterns on UpdateUserRoleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserRoleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserRoleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserRoleDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserRoleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserRoleDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserRoleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAdmin,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserRoleDto() when $default != null:
return $default(_that.isAdmin,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAdmin,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserRoleDto():
return $default(_that.isAdmin,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAdmin,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserRoleDto() when $default != null:
return $default(_that.isAdmin,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserRoleDto implements UpdateUserRoleDto {
  const _UpdateUserRoleDto({required this.isAdmin, required this.isActive});
  factory _UpdateUserRoleDto.fromJson(Map<String, dynamic> json) => _$UpdateUserRoleDtoFromJson(json);

@override final  bool isAdmin;
@override final  bool isActive;

/// Create a copy of UpdateUserRoleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserRoleDtoCopyWith<_UpdateUserRoleDto> get copyWith => __$UpdateUserRoleDtoCopyWithImpl<_UpdateUserRoleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserRoleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserRoleDto&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isAdmin,isActive);

@override
String toString() {
  return 'UpdateUserRoleDto(isAdmin: $isAdmin, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserRoleDtoCopyWith<$Res> implements $UpdateUserRoleDtoCopyWith<$Res> {
  factory _$UpdateUserRoleDtoCopyWith(_UpdateUserRoleDto value, $Res Function(_UpdateUserRoleDto) _then) = __$UpdateUserRoleDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isAdmin, bool isActive
});




}
/// @nodoc
class __$UpdateUserRoleDtoCopyWithImpl<$Res>
    implements _$UpdateUserRoleDtoCopyWith<$Res> {
  __$UpdateUserRoleDtoCopyWithImpl(this._self, this._then);

  final _UpdateUserRoleDto _self;
  final $Res Function(_UpdateUserRoleDto) _then;

/// Create a copy of UpdateUserRoleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAdmin = null,Object? isActive = null,}) {
  return _then(_UpdateUserRoleDto(
isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AdminStatsDto {

 int get totalUsers; int get activeUsers; int get adminUsers; int get totalDocuments; int get totalPages; int get totalStorageUsed;
/// Create a copy of AdminStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStatsDtoCopyWith<AdminStatsDto> get copyWith => _$AdminStatsDtoCopyWithImpl<AdminStatsDto>(this as AdminStatsDto, _$identity);

  /// Serializes this AdminStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminStatsDto&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers)&&(identical(other.adminUsers, adminUsers) || other.adminUsers == adminUsers)&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalStorageUsed, totalStorageUsed) || other.totalStorageUsed == totalStorageUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalUsers,activeUsers,adminUsers,totalDocuments,totalPages,totalStorageUsed);

@override
String toString() {
  return 'AdminStatsDto(totalUsers: $totalUsers, activeUsers: $activeUsers, adminUsers: $adminUsers, totalDocuments: $totalDocuments, totalPages: $totalPages, totalStorageUsed: $totalStorageUsed)';
}


}

/// @nodoc
abstract mixin class $AdminStatsDtoCopyWith<$Res>  {
  factory $AdminStatsDtoCopyWith(AdminStatsDto value, $Res Function(AdminStatsDto) _then) = _$AdminStatsDtoCopyWithImpl;
@useResult
$Res call({
 int totalUsers, int activeUsers, int adminUsers, int totalDocuments, int totalPages, int totalStorageUsed
});




}
/// @nodoc
class _$AdminStatsDtoCopyWithImpl<$Res>
    implements $AdminStatsDtoCopyWith<$Res> {
  _$AdminStatsDtoCopyWithImpl(this._self, this._then);

  final AdminStatsDto _self;
  final $Res Function(AdminStatsDto) _then;

/// Create a copy of AdminStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalUsers = null,Object? activeUsers = null,Object? adminUsers = null,Object? totalDocuments = null,Object? totalPages = null,Object? totalStorageUsed = null,}) {
  return _then(_self.copyWith(
totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,adminUsers: null == adminUsers ? _self.adminUsers : adminUsers // ignore: cast_nullable_to_non_nullable
as int,totalDocuments: null == totalDocuments ? _self.totalDocuments : totalDocuments // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalStorageUsed: null == totalStorageUsed ? _self.totalStorageUsed : totalStorageUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminStatsDto].
extension AdminStatsDtoPatterns on AdminStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _AdminStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _AdminStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalUsers,  int activeUsers,  int adminUsers,  int totalDocuments,  int totalPages,  int totalStorageUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminStatsDto() when $default != null:
return $default(_that.totalUsers,_that.activeUsers,_that.adminUsers,_that.totalDocuments,_that.totalPages,_that.totalStorageUsed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalUsers,  int activeUsers,  int adminUsers,  int totalDocuments,  int totalPages,  int totalStorageUsed)  $default,) {final _that = this;
switch (_that) {
case _AdminStatsDto():
return $default(_that.totalUsers,_that.activeUsers,_that.adminUsers,_that.totalDocuments,_that.totalPages,_that.totalStorageUsed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalUsers,  int activeUsers,  int adminUsers,  int totalDocuments,  int totalPages,  int totalStorageUsed)?  $default,) {final _that = this;
switch (_that) {
case _AdminStatsDto() when $default != null:
return $default(_that.totalUsers,_that.activeUsers,_that.adminUsers,_that.totalDocuments,_that.totalPages,_that.totalStorageUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminStatsDto implements AdminStatsDto {
  const _AdminStatsDto({required this.totalUsers, required this.activeUsers, required this.adminUsers, required this.totalDocuments, required this.totalPages, required this.totalStorageUsed});
  factory _AdminStatsDto.fromJson(Map<String, dynamic> json) => _$AdminStatsDtoFromJson(json);

@override final  int totalUsers;
@override final  int activeUsers;
@override final  int adminUsers;
@override final  int totalDocuments;
@override final  int totalPages;
@override final  int totalStorageUsed;

/// Create a copy of AdminStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStatsDtoCopyWith<_AdminStatsDto> get copyWith => __$AdminStatsDtoCopyWithImpl<_AdminStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminStatsDto&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers)&&(identical(other.adminUsers, adminUsers) || other.adminUsers == adminUsers)&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalStorageUsed, totalStorageUsed) || other.totalStorageUsed == totalStorageUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalUsers,activeUsers,adminUsers,totalDocuments,totalPages,totalStorageUsed);

@override
String toString() {
  return 'AdminStatsDto(totalUsers: $totalUsers, activeUsers: $activeUsers, adminUsers: $adminUsers, totalDocuments: $totalDocuments, totalPages: $totalPages, totalStorageUsed: $totalStorageUsed)';
}


}

/// @nodoc
abstract mixin class _$AdminStatsDtoCopyWith<$Res> implements $AdminStatsDtoCopyWith<$Res> {
  factory _$AdminStatsDtoCopyWith(_AdminStatsDto value, $Res Function(_AdminStatsDto) _then) = __$AdminStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int totalUsers, int activeUsers, int adminUsers, int totalDocuments, int totalPages, int totalStorageUsed
});




}
/// @nodoc
class __$AdminStatsDtoCopyWithImpl<$Res>
    implements _$AdminStatsDtoCopyWith<$Res> {
  __$AdminStatsDtoCopyWithImpl(this._self, this._then);

  final _AdminStatsDto _self;
  final $Res Function(_AdminStatsDto) _then;

/// Create a copy of AdminStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalUsers = null,Object? activeUsers = null,Object? adminUsers = null,Object? totalDocuments = null,Object? totalPages = null,Object? totalStorageUsed = null,}) {
  return _then(_AdminStatsDto(
totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,adminUsers: null == adminUsers ? _self.adminUsers : adminUsers // ignore: cast_nullable_to_non_nullable
as int,totalDocuments: null == totalDocuments ? _self.totalDocuments : totalDocuments // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalStorageUsed: null == totalStorageUsed ? _self.totalStorageUsed : totalStorageUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateUserProfileDto {

 String? get username; String? get nickname; String? get email; String? get avatar; String? get bio;
/// Create a copy of UpdateUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserProfileDtoCopyWith<UpdateUserProfileDto> get copyWith => _$UpdateUserProfileDtoCopyWithImpl<UpdateUserProfileDto>(this as UpdateUserProfileDto, _$identity);

  /// Serializes this UpdateUserProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserProfileDto&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.bio, bio) || other.bio == bio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,nickname,email,avatar,bio);

@override
String toString() {
  return 'UpdateUserProfileDto(username: $username, nickname: $nickname, email: $email, avatar: $avatar, bio: $bio)';
}


}

/// @nodoc
abstract mixin class $UpdateUserProfileDtoCopyWith<$Res>  {
  factory $UpdateUserProfileDtoCopyWith(UpdateUserProfileDto value, $Res Function(UpdateUserProfileDto) _then) = _$UpdateUserProfileDtoCopyWithImpl;
@useResult
$Res call({
 String? username, String? nickname, String? email, String? avatar, String? bio
});




}
/// @nodoc
class _$UpdateUserProfileDtoCopyWithImpl<$Res>
    implements $UpdateUserProfileDtoCopyWith<$Res> {
  _$UpdateUserProfileDtoCopyWithImpl(this._self, this._then);

  final UpdateUserProfileDto _self;
  final $Res Function(UpdateUserProfileDto) _then;

/// Create a copy of UpdateUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = freezed,Object? nickname = freezed,Object? email = freezed,Object? avatar = freezed,Object? bio = freezed,}) {
  return _then(_self.copyWith(
username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserProfileDto].
extension UpdateUserProfileDtoPatterns on UpdateUserProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? username,  String? nickname,  String? email,  String? avatar,  String? bio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserProfileDto() when $default != null:
return $default(_that.username,_that.nickname,_that.email,_that.avatar,_that.bio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? username,  String? nickname,  String? email,  String? avatar,  String? bio)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserProfileDto():
return $default(_that.username,_that.nickname,_that.email,_that.avatar,_that.bio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? username,  String? nickname,  String? email,  String? avatar,  String? bio)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserProfileDto() when $default != null:
return $default(_that.username,_that.nickname,_that.email,_that.avatar,_that.bio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserProfileDto implements UpdateUserProfileDto {
  const _UpdateUserProfileDto({this.username, this.nickname, this.email, this.avatar, this.bio});
  factory _UpdateUserProfileDto.fromJson(Map<String, dynamic> json) => _$UpdateUserProfileDtoFromJson(json);

@override final  String? username;
@override final  String? nickname;
@override final  String? email;
@override final  String? avatar;
@override final  String? bio;

/// Create a copy of UpdateUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserProfileDtoCopyWith<_UpdateUserProfileDto> get copyWith => __$UpdateUserProfileDtoCopyWithImpl<_UpdateUserProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserProfileDto&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.bio, bio) || other.bio == bio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,nickname,email,avatar,bio);

@override
String toString() {
  return 'UpdateUserProfileDto(username: $username, nickname: $nickname, email: $email, avatar: $avatar, bio: $bio)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserProfileDtoCopyWith<$Res> implements $UpdateUserProfileDtoCopyWith<$Res> {
  factory _$UpdateUserProfileDtoCopyWith(_UpdateUserProfileDto value, $Res Function(_UpdateUserProfileDto) _then) = __$UpdateUserProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String? username, String? nickname, String? email, String? avatar, String? bio
});




}
/// @nodoc
class __$UpdateUserProfileDtoCopyWithImpl<$Res>
    implements _$UpdateUserProfileDtoCopyWith<$Res> {
  __$UpdateUserProfileDtoCopyWithImpl(this._self, this._then);

  final _UpdateUserProfileDto _self;
  final $Res Function(_UpdateUserProfileDto) _then;

/// Create a copy of UpdateUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = freezed,Object? nickname = freezed,Object? email = freezed,Object? avatar = freezed,Object? bio = freezed,}) {
  return _then(_UpdateUserProfileDto(
username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
