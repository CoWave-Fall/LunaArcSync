import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';
import 'package:luna_arc_sync/data/repositories/user_repository.dart';
import 'user_state.dart';

@lazySingleton
class UserCubit extends Cubit<UserState> {
  final IUserRepository _userRepository;
  
  // 缓存当前用户数据
  UserDto? _currentUser;
  List<AdminUserListDto>? _allUsers;
  AdminStatsDto? _adminStats;

  UserCubit(this._userRepository) : super(const UserState.initial());

  /// 获取当前用户信息
  Future<void> getCurrentUserProfile() async {
    try {
      debugPrint('👤 UserCubit: Getting current user profile...');
      emit(const UserState.loading());
      
      final user = await _userRepository.getCurrentUserProfile();
      _currentUser = user;
      
      debugPrint('👤 UserCubit: Current user profile loaded successfully');
      _emitDataLoadedState();
    } catch (e) {
      debugPrint('👤 UserCubit: Error getting current user profile - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 更新当前用户信息
  Future<void> updateCurrentUserProfile(UpdateUserProfileDto profile) async {
    try {
      debugPrint('👤 UserCubit: Updating current user profile...');
      emit(const UserState.loading());
      
      await _userRepository.updateCurrentUserProfile(profile);
      
      debugPrint('👤 UserCubit: Current user profile updated successfully');
      // 重新获取用户信息
      await getCurrentUserProfile();
    } catch (e) {
      debugPrint('👤 UserCubit: Error updating current user profile - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 获取所有用户列表（管理员功能）
  Future<void> getAllUsers() async {
    try {
      debugPrint('👤 UserCubit: Getting all users...');
      
      final users = await _userRepository.getAllUsers();
      _allUsers = users;
      
      debugPrint('👤 UserCubit: All users loaded successfully (${users.length} users)');
      _emitDataLoadedState();
    } catch (e) {
      debugPrint('👤 UserCubit: Error getting all users - $e');
      // 对于管理员数据获取失败，不显示错误，因为可能用户不是管理员
      debugPrint('👤 UserCubit: This might be because user is not an admin');
    }
  }

  /// 获取用户详情（管理员功能）
  Future<void> getUserById(String userId) async {
    try {
      debugPrint('👤 UserCubit: Getting user by ID: $userId');
      emit(const UserState.loading());
      
      final user = await _userRepository.getUserById(userId);
      
      debugPrint('👤 UserCubit: User details loaded successfully');
      emit(UserState.userDetailsLoaded(user));
    } catch (e) {
      debugPrint('👤 UserCubit: Error getting user details - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 更新用户角色（管理员功能）
  Future<void> updateUserRole(String userId, UpdateUserRoleDto roleDto) async {
    try {
      debugPrint('👤 UserCubit: Updating user role for user: $userId');
      emit(const UserState.loading());
      
      await _userRepository.updateUserRole(userId, roleDto);
      
      debugPrint('👤 UserCubit: User role updated successfully');
      // 重新获取所有用户列表
      await getAllUsers();
    } catch (e) {
      debugPrint('👤 UserCubit: Error updating user role - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 删除用户（管理员功能）
  Future<void> deleteUser(String userId) async {
    try {
      debugPrint('👤 UserCubit: Deleting user: $userId');
      emit(const UserState.loading());
      
      await _userRepository.deleteUser(userId);
      
      debugPrint('👤 UserCubit: User deleted successfully');
      // 重新获取所有用户列表
      await getAllUsers();
    } catch (e) {
      debugPrint('👤 UserCubit: Error deleting user - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 获取管理员统计信息（管理员功能）
  Future<void> getAdminStats() async {
    try {
      debugPrint('👤 UserCubit: Getting admin stats...');
      
      final stats = await _userRepository.getAdminStats();
      _adminStats = stats;
      
      debugPrint('👤 UserCubit: Admin stats loaded successfully');
      _emitDataLoadedState();
    } catch (e) {
      debugPrint('👤 UserCubit: Error getting admin stats - $e');
      // 对于管理员数据获取失败，不显示错误，因为可能用户不是管理员
      debugPrint('👤 UserCubit: This might be because user is not an admin');
    }
  }

  /// 上传头像
  Future<void> uploadAvatar(String filePath) async {
    try {
      debugPrint('👤 UserCubit: Uploading avatar...');
      emit(const UserState.loading());
      
      await _userRepository.uploadAvatar(filePath);
      
      debugPrint('👤 UserCubit: Avatar uploaded successfully');
      // 重新获取用户信息
      await getCurrentUserProfile();
    } catch (e) {
      debugPrint('👤 UserCubit: Error uploading avatar - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 删除头像
  Future<void> deleteAvatar() async {
    try {
      debugPrint('👤 UserCubit: Deleting avatar...');
      emit(const UserState.loading());
      
      await _userRepository.deleteAvatar();
      
      debugPrint('👤 UserCubit: Avatar deleted successfully');
      // 重新获取用户信息
      await getCurrentUserProfile();
    } catch (e) {
      debugPrint('👤 UserCubit: Error deleting avatar - $e');
      emit(UserState.error(e.toString()));
    }
  }

  /// 重置状态
  void reset() {
    _currentUser = null;
    _allUsers = null;
    _adminStats = null;
    emit(const UserState.initial());
  }

  /// 发出包含所有数据的完整状态
  void _emitDataLoadedState() {
    if (_currentUser != null) {
      emit(UserState.dataLoaded(
        currentUser: _currentUser!,
        allUsers: _allUsers,
        adminStats: _adminStats,
      ));
    }
  }
}
