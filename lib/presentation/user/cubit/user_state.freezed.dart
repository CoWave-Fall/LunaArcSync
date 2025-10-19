// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserState()';
}


}

/// @nodoc
class $UserStateCopyWith<$Res>  {
$UserStateCopyWith(UserState _, $Res Function(UserState) __);
}


/// Adds pattern-matching-related methods to [UserState].
extension UserStatePatterns on UserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _CurrentUserLoaded value)?  currentUserLoaded,TResult Function( _AllUsersLoaded value)?  allUsersLoaded,TResult Function( _UserDetailsLoaded value)?  userDetailsLoaded,TResult Function( _AdminStatsLoaded value)?  adminStatsLoaded,TResult Function( _Error value)?  error,TResult Function( _DataLoaded value)?  dataLoaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _CurrentUserLoaded() when currentUserLoaded != null:
return currentUserLoaded(_that);case _AllUsersLoaded() when allUsersLoaded != null:
return allUsersLoaded(_that);case _UserDetailsLoaded() when userDetailsLoaded != null:
return userDetailsLoaded(_that);case _AdminStatsLoaded() when adminStatsLoaded != null:
return adminStatsLoaded(_that);case _Error() when error != null:
return error(_that);case _DataLoaded() when dataLoaded != null:
return dataLoaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _CurrentUserLoaded value)  currentUserLoaded,required TResult Function( _AllUsersLoaded value)  allUsersLoaded,required TResult Function( _UserDetailsLoaded value)  userDetailsLoaded,required TResult Function( _AdminStatsLoaded value)  adminStatsLoaded,required TResult Function( _Error value)  error,required TResult Function( _DataLoaded value)  dataLoaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _CurrentUserLoaded():
return currentUserLoaded(_that);case _AllUsersLoaded():
return allUsersLoaded(_that);case _UserDetailsLoaded():
return userDetailsLoaded(_that);case _AdminStatsLoaded():
return adminStatsLoaded(_that);case _Error():
return error(_that);case _DataLoaded():
return dataLoaded(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _CurrentUserLoaded value)?  currentUserLoaded,TResult? Function( _AllUsersLoaded value)?  allUsersLoaded,TResult? Function( _UserDetailsLoaded value)?  userDetailsLoaded,TResult? Function( _AdminStatsLoaded value)?  adminStatsLoaded,TResult? Function( _Error value)?  error,TResult? Function( _DataLoaded value)?  dataLoaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _CurrentUserLoaded() when currentUserLoaded != null:
return currentUserLoaded(_that);case _AllUsersLoaded() when allUsersLoaded != null:
return allUsersLoaded(_that);case _UserDetailsLoaded() when userDetailsLoaded != null:
return userDetailsLoaded(_that);case _AdminStatsLoaded() when adminStatsLoaded != null:
return adminStatsLoaded(_that);case _Error() when error != null:
return error(_that);case _DataLoaded() when dataLoaded != null:
return dataLoaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserDto user)?  currentUserLoaded,TResult Function( List<AdminUserListDto> users)?  allUsersLoaded,TResult Function( UserDto user)?  userDetailsLoaded,TResult Function( AdminStatsDto stats)?  adminStatsLoaded,TResult Function( String message)?  error,TResult Function( UserDto currentUser,  List<AdminUserListDto>? allUsers,  AdminStatsDto? adminStats)?  dataLoaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _CurrentUserLoaded() when currentUserLoaded != null:
return currentUserLoaded(_that.user);case _AllUsersLoaded() when allUsersLoaded != null:
return allUsersLoaded(_that.users);case _UserDetailsLoaded() when userDetailsLoaded != null:
return userDetailsLoaded(_that.user);case _AdminStatsLoaded() when adminStatsLoaded != null:
return adminStatsLoaded(_that.stats);case _Error() when error != null:
return error(_that.message);case _DataLoaded() when dataLoaded != null:
return dataLoaded(_that.currentUser,_that.allUsers,_that.adminStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserDto user)  currentUserLoaded,required TResult Function( List<AdminUserListDto> users)  allUsersLoaded,required TResult Function( UserDto user)  userDetailsLoaded,required TResult Function( AdminStatsDto stats)  adminStatsLoaded,required TResult Function( String message)  error,required TResult Function( UserDto currentUser,  List<AdminUserListDto>? allUsers,  AdminStatsDto? adminStats)  dataLoaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _CurrentUserLoaded():
return currentUserLoaded(_that.user);case _AllUsersLoaded():
return allUsersLoaded(_that.users);case _UserDetailsLoaded():
return userDetailsLoaded(_that.user);case _AdminStatsLoaded():
return adminStatsLoaded(_that.stats);case _Error():
return error(_that.message);case _DataLoaded():
return dataLoaded(_that.currentUser,_that.allUsers,_that.adminStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserDto user)?  currentUserLoaded,TResult? Function( List<AdminUserListDto> users)?  allUsersLoaded,TResult? Function( UserDto user)?  userDetailsLoaded,TResult? Function( AdminStatsDto stats)?  adminStatsLoaded,TResult? Function( String message)?  error,TResult? Function( UserDto currentUser,  List<AdminUserListDto>? allUsers,  AdminStatsDto? adminStats)?  dataLoaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _CurrentUserLoaded() when currentUserLoaded != null:
return currentUserLoaded(_that.user);case _AllUsersLoaded() when allUsersLoaded != null:
return allUsersLoaded(_that.users);case _UserDetailsLoaded() when userDetailsLoaded != null:
return userDetailsLoaded(_that.user);case _AdminStatsLoaded() when adminStatsLoaded != null:
return adminStatsLoaded(_that.stats);case _Error() when error != null:
return error(_that.message);case _DataLoaded() when dataLoaded != null:
return dataLoaded(_that.currentUser,_that.allUsers,_that.adminStats);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements UserState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserState.initial()';
}


}




/// @nodoc


class _Loading implements UserState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserState.loading()';
}


}




/// @nodoc


class _CurrentUserLoaded implements UserState {
  const _CurrentUserLoaded(this.user);
  

 final  UserDto user;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentUserLoadedCopyWith<_CurrentUserLoaded> get copyWith => __$CurrentUserLoadedCopyWithImpl<_CurrentUserLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentUserLoaded&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'UserState.currentUserLoaded(user: $user)';
}


}

/// @nodoc
abstract mixin class _$CurrentUserLoadedCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$CurrentUserLoadedCopyWith(_CurrentUserLoaded value, $Res Function(_CurrentUserLoaded) _then) = __$CurrentUserLoadedCopyWithImpl;
@useResult
$Res call({
 UserDto user
});


$UserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$CurrentUserLoadedCopyWithImpl<$Res>
    implements _$CurrentUserLoadedCopyWith<$Res> {
  __$CurrentUserLoadedCopyWithImpl(this._self, this._then);

  final _CurrentUserLoaded _self;
  final $Res Function(_CurrentUserLoaded) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_CurrentUserLoaded(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto,
  ));
}

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get user {
  
  return $UserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _AllUsersLoaded implements UserState {
  const _AllUsersLoaded(final  List<AdminUserListDto> users): _users = users;
  

 final  List<AdminUserListDto> _users;
 List<AdminUserListDto> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllUsersLoadedCopyWith<_AllUsersLoaded> get copyWith => __$AllUsersLoadedCopyWithImpl<_AllUsersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllUsersLoaded&&const DeepCollectionEquality().equals(other._users, _users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'UserState.allUsersLoaded(users: $users)';
}


}

/// @nodoc
abstract mixin class _$AllUsersLoadedCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$AllUsersLoadedCopyWith(_AllUsersLoaded value, $Res Function(_AllUsersLoaded) _then) = __$AllUsersLoadedCopyWithImpl;
@useResult
$Res call({
 List<AdminUserListDto> users
});




}
/// @nodoc
class __$AllUsersLoadedCopyWithImpl<$Res>
    implements _$AllUsersLoadedCopyWith<$Res> {
  __$AllUsersLoadedCopyWithImpl(this._self, this._then);

  final _AllUsersLoaded _self;
  final $Res Function(_AllUsersLoaded) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? users = null,}) {
  return _then(_AllUsersLoaded(
null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUserListDto>,
  ));
}


}

/// @nodoc


class _UserDetailsLoaded implements UserState {
  const _UserDetailsLoaded(this.user);
  

 final  UserDto user;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDetailsLoadedCopyWith<_UserDetailsLoaded> get copyWith => __$UserDetailsLoadedCopyWithImpl<_UserDetailsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetailsLoaded&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'UserState.userDetailsLoaded(user: $user)';
}


}

/// @nodoc
abstract mixin class _$UserDetailsLoadedCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$UserDetailsLoadedCopyWith(_UserDetailsLoaded value, $Res Function(_UserDetailsLoaded) _then) = __$UserDetailsLoadedCopyWithImpl;
@useResult
$Res call({
 UserDto user
});


$UserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$UserDetailsLoadedCopyWithImpl<$Res>
    implements _$UserDetailsLoadedCopyWith<$Res> {
  __$UserDetailsLoadedCopyWithImpl(this._self, this._then);

  final _UserDetailsLoaded _self;
  final $Res Function(_UserDetailsLoaded) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_UserDetailsLoaded(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto,
  ));
}

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get user {
  
  return $UserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _AdminStatsLoaded implements UserState {
  const _AdminStatsLoaded(this.stats);
  

 final  AdminStatsDto stats;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStatsLoadedCopyWith<_AdminStatsLoaded> get copyWith => __$AdminStatsLoadedCopyWithImpl<_AdminStatsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminStatsLoaded&&(identical(other.stats, stats) || other.stats == stats));
}


@override
int get hashCode => Object.hash(runtimeType,stats);

@override
String toString() {
  return 'UserState.adminStatsLoaded(stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$AdminStatsLoadedCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$AdminStatsLoadedCopyWith(_AdminStatsLoaded value, $Res Function(_AdminStatsLoaded) _then) = __$AdminStatsLoadedCopyWithImpl;
@useResult
$Res call({
 AdminStatsDto stats
});


$AdminStatsDtoCopyWith<$Res> get stats;

}
/// @nodoc
class __$AdminStatsLoadedCopyWithImpl<$Res>
    implements _$AdminStatsLoadedCopyWith<$Res> {
  __$AdminStatsLoadedCopyWithImpl(this._self, this._then);

  final _AdminStatsLoaded _self;
  final $Res Function(_AdminStatsLoaded) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stats = null,}) {
  return _then(_AdminStatsLoaded(
null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as AdminStatsDto,
  ));
}

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminStatsDtoCopyWith<$Res> get stats {
  
  return $AdminStatsDtoCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

/// @nodoc


class _Error implements UserState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UserState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DataLoaded implements UserState {
  const _DataLoaded({required this.currentUser, final  List<AdminUserListDto>? allUsers, this.adminStats}): _allUsers = allUsers;
  

 final  UserDto currentUser;
 final  List<AdminUserListDto>? _allUsers;
 List<AdminUserListDto>? get allUsers {
  final value = _allUsers;
  if (value == null) return null;
  if (_allUsers is EqualUnmodifiableListView) return _allUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  AdminStatsDto? adminStats;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataLoadedCopyWith<_DataLoaded> get copyWith => __$DataLoadedCopyWithImpl<_DataLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataLoaded&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&const DeepCollectionEquality().equals(other._allUsers, _allUsers)&&(identical(other.adminStats, adminStats) || other.adminStats == adminStats));
}


@override
int get hashCode => Object.hash(runtimeType,currentUser,const DeepCollectionEquality().hash(_allUsers),adminStats);

@override
String toString() {
  return 'UserState.dataLoaded(currentUser: $currentUser, allUsers: $allUsers, adminStats: $adminStats)';
}


}

/// @nodoc
abstract mixin class _$DataLoadedCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$DataLoadedCopyWith(_DataLoaded value, $Res Function(_DataLoaded) _then) = __$DataLoadedCopyWithImpl;
@useResult
$Res call({
 UserDto currentUser, List<AdminUserListDto>? allUsers, AdminStatsDto? adminStats
});


$UserDtoCopyWith<$Res> get currentUser;$AdminStatsDtoCopyWith<$Res>? get adminStats;

}
/// @nodoc
class __$DataLoadedCopyWithImpl<$Res>
    implements _$DataLoadedCopyWith<$Res> {
  __$DataLoadedCopyWithImpl(this._self, this._then);

  final _DataLoaded _self;
  final $Res Function(_DataLoaded) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentUser = null,Object? allUsers = freezed,Object? adminStats = freezed,}) {
  return _then(_DataLoaded(
currentUser: null == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as UserDto,allUsers: freezed == allUsers ? _self._allUsers : allUsers // ignore: cast_nullable_to_non_nullable
as List<AdminUserListDto>?,adminStats: freezed == adminStats ? _self.adminStats : adminStats // ignore: cast_nullable_to_non_nullable
as AdminStatsDto?,
  ));
}

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get currentUser {
  
  return $UserDtoCopyWith<$Res>(_self.currentUser, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminStatsDtoCopyWith<$Res>? get adminStats {
    if (_self.adminStats == null) {
    return null;
  }

  return $AdminStatsDtoCopyWith<$Res>(_self.adminStats!, (value) {
    return _then(_self.copyWith(adminStats: value));
  });
}
}

// dart format on
