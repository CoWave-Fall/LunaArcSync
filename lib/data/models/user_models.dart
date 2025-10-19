import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/api/json_converters.dart';

part 'user_models.freezed.dart';
part 'user_models.g.dart';

// 用户基本信息DTO
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String username,
    required String nickname,
    required String email,
    String? avatar,
    String? bio,
    required bool isAdmin,
    required bool isActive,
    @UnixTimestampConverter()
    required DateTime createdAt,
    @UnixTimestampConverter()
    DateTime? lastLoginAt,
    required int documentCount,
    required int pageCount,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

// 管理员用户列表DTO
@freezed
abstract class AdminUserListDto with _$AdminUserListDto {
  const factory AdminUserListDto({
    required String id,
    required String email,
    required bool isAdmin,
    required bool isActive,
    @UnixTimestampConverter()
    required DateTime createdAt,
    @UnixTimestampConverter()
    DateTime? lastLoginAt,
    required int documentCount,
    required int pageCount,
    required int totalStorageUsed,
  }) = _AdminUserListDto;

  factory AdminUserListDto.fromJson(Map<String, dynamic> json) =>
      _$AdminUserListDtoFromJson(json);
}

// 更新用户角色DTO
@freezed
abstract class UpdateUserRoleDto with _$UpdateUserRoleDto {
  const factory UpdateUserRoleDto({
    required bool isAdmin,
    required bool isActive,
  }) = _UpdateUserRoleDto;

  factory UpdateUserRoleDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRoleDtoFromJson(json);
}

// 管理员统计信息DTO
@freezed
abstract class AdminStatsDto with _$AdminStatsDto {
  const factory AdminStatsDto({
    required int totalUsers,
    required int activeUsers,
    required int adminUsers,
    required int totalDocuments,
    required int totalPages,
    required int totalStorageUsed,
  }) = _AdminStatsDto;

  factory AdminStatsDto.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsDtoFromJson(json);
}

// 用户信息更新请求DTO
@freezed
abstract class UpdateUserProfileDto with _$UpdateUserProfileDto {
  const factory UpdateUserProfileDto({
    String? username,
    String? nickname,
    String? email,
    String? avatar,
    String? bio,
  }) = _UpdateUserProfileDto;

  factory UpdateUserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileDtoFromJson(json);
}
