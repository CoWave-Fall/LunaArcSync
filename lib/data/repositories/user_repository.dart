import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';

import 'package:luna_arc_sync/data/models/user_models.dart';

abstract class IUserRepository {
  /// 获取当前用户信息
  Future<UserDto> getCurrentUserProfile();
  
  /// 更新当前用户信息
  Future<void> updateCurrentUserProfile(UpdateUserProfileDto profile);
  
  /// 上传头像
  Future<String> uploadAvatar(String filePath);
  
  /// 获取头像URL
  String getAvatarUrl(String userId);
  
  /// 删除头像
  Future<void> deleteAvatar();
  
  /// 获取所有用户列表（仅管理员）
  Future<List<AdminUserListDto>> getAllUsers();
  
  /// 获取用户详情（仅管理员）
  Future<UserDto> getUserById(String userId);
  
  /// 更新用户角色（仅管理员）
  Future<void> updateUserRole(String userId, UpdateUserRoleDto roleDto);
  
  /// 删除用户（仅管理员）
  Future<void> deleteUser(String userId);
  
  /// 获取管理员统计信息（仅管理员）
  Future<AdminStatsDto> getAdminStats();
}

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  @override
  Future<UserDto> getCurrentUserProfile() async {
    try {
      final response = await _apiClient.dio.get('/api/accounts/profile');
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('获取用户信息失败: ${e.message}');
    }
  }

  @override
  Future<void> updateCurrentUserProfile(UpdateUserProfileDto profile) async {
    try {
      await _apiClient.dio.put(
        '/api/accounts/profile',
        data: profile.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('更新用户信息失败: ${e.message}');
    }
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.dio.post(
        '/api/accounts/avatar/upload',
        data: formData,
      );
      
      return response.data['avatarUrl'] ?? '';
    } on DioException catch (e) {
      throw Exception('上传头像失败: ${e.message}');
    }
  }

  @override
  String getAvatarUrl(String userId) {
    final baseUrl = _apiClient.getBaseUrl();
    return '$baseUrl/api/accounts/avatar/$userId';
  }

  @override
  Future<void> deleteAvatar() async {
    try {
      await _apiClient.dio.delete('/api/accounts/avatar');
    } on DioException catch (e) {
      throw Exception('删除头像失败: ${e.message}');
    }
  }

  @override
  Future<List<AdminUserListDto>> getAllUsers() async {
    try {
      final response = await _apiClient.dio.get('/api/accounts/admin/users');
      return (response.data as List)
          .map((json) => AdminUserListDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('获取用户列表失败: ${e.message}');
    }
  }

  @override
  Future<UserDto> getUserById(String userId) async {
    try {
      final response = await _apiClient.dio.get('/api/accounts/admin/users/$userId');
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('获取用户详情失败: ${e.message}');
    }
  }

  @override
  Future<void> updateUserRole(String userId, UpdateUserRoleDto roleDto) async {
    try {
      await _apiClient.dio.put(
        '/api/accounts/admin/users/$userId/role',
        data: roleDto.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('更新用户角色失败: ${e.message}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _apiClient.dio.delete('/api/accounts/admin/users/$userId');
    } on DioException catch (e) {
      throw Exception('删除用户失败: ${e.message}');
    }
  }

  @override
  Future<AdminStatsDto> getAdminStats() async {
    try {
      final response = await _apiClient.dio.get('/api/accounts/admin/stats');
      return AdminStatsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('获取统计信息失败: ${e.message}');
    }
  }
}