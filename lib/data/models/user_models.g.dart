// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: json['id'] as String,
  username: json['username'] as String,
  nickname: json['nickname'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  bio: json['bio'] as String?,
  isAdmin: json['isAdmin'] as bool,
  isActive: json['isActive'] as bool,
  createdAt: const UnixTimestampConverter().fromJson(json['createdAt']),
  lastLoginAt: const UnixTimestampConverter().fromJson(json['lastLoginAt']),
  documentCount: (json['documentCount'] as num).toInt(),
  pageCount: (json['pageCount'] as num).toInt(),
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'nickname': instance.nickname,
  'email': instance.email,
  'avatar': instance.avatar,
  'bio': instance.bio,
  'isAdmin': instance.isAdmin,
  'isActive': instance.isActive,
  'createdAt': const UnixTimestampConverter().toJson(instance.createdAt),
  'lastLoginAt': _$JsonConverterToJson<dynamic, DateTime>(
    instance.lastLoginAt,
    const UnixTimestampConverter().toJson,
  ),
  'documentCount': instance.documentCount,
  'pageCount': instance.pageCount,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_AdminUserListDto _$AdminUserListDtoFromJson(Map<String, dynamic> json) =>
    _AdminUserListDto(
      id: json['id'] as String,
      email: json['email'] as String,
      isAdmin: json['isAdmin'] as bool,
      isActive: json['isActive'] as bool,
      createdAt: const UnixTimestampConverter().fromJson(json['createdAt']),
      lastLoginAt: const UnixTimestampConverter().fromJson(json['lastLoginAt']),
      documentCount: (json['documentCount'] as num).toInt(),
      pageCount: (json['pageCount'] as num).toInt(),
      totalStorageUsed: (json['totalStorageUsed'] as num).toInt(),
    );

Map<String, dynamic> _$AdminUserListDtoToJson(_AdminUserListDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
      'isActive': instance.isActive,
      'createdAt': const UnixTimestampConverter().toJson(instance.createdAt),
      'lastLoginAt': _$JsonConverterToJson<dynamic, DateTime>(
        instance.lastLoginAt,
        const UnixTimestampConverter().toJson,
      ),
      'documentCount': instance.documentCount,
      'pageCount': instance.pageCount,
      'totalStorageUsed': instance.totalStorageUsed,
    };

_UpdateUserRoleDto _$UpdateUserRoleDtoFromJson(Map<String, dynamic> json) =>
    _UpdateUserRoleDto(
      isAdmin: json['isAdmin'] as bool,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$UpdateUserRoleDtoToJson(_UpdateUserRoleDto instance) =>
    <String, dynamic>{
      'isAdmin': instance.isAdmin,
      'isActive': instance.isActive,
    };

_AdminStatsDto _$AdminStatsDtoFromJson(Map<String, dynamic> json) =>
    _AdminStatsDto(
      totalUsers: (json['totalUsers'] as num).toInt(),
      activeUsers: (json['activeUsers'] as num).toInt(),
      adminUsers: (json['adminUsers'] as num).toInt(),
      totalDocuments: (json['totalDocuments'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalStorageUsed: (json['totalStorageUsed'] as num).toInt(),
    );

Map<String, dynamic> _$AdminStatsDtoToJson(_AdminStatsDto instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'activeUsers': instance.activeUsers,
      'adminUsers': instance.adminUsers,
      'totalDocuments': instance.totalDocuments,
      'totalPages': instance.totalPages,
      'totalStorageUsed': instance.totalStorageUsed,
    };

_UpdateUserProfileDto _$UpdateUserProfileDtoFromJson(
  Map<String, dynamic> json,
) => _UpdateUserProfileDto(
  username: json['username'] as String?,
  nickname: json['nickname'] as String?,
  email: json['email'] as String?,
  avatar: json['avatar'] as String?,
  bio: json['bio'] as String?,
);

Map<String, dynamic> _$UpdateUserProfileDtoToJson(
  _UpdateUserProfileDto instance,
) => <String, dynamic>{
  'username': instance.username,
  'nickname': instance.nickname,
  'email': instance.email,
  'avatar': instance.avatar,
  'bio': instance.bio,
};
