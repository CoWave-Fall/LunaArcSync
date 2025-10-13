import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/data/repositories/auth_repository.dart';
import 'package:luna_arc_sync/data/models/auth_models.dart';

/// 自动登录服务
/// 集中处理所有自动登录相关的逻辑，包括凭据管理、token验证等
@lazySingleton
class AutoLoginService {
  final SecureStorageService _storageService;
  final IAuthRepository _authRepository;

  AutoLoginService(this._storageService, this._authRepository);

  /// 检查是否有有效的登录会话
  /// 返回 userId 如果会话有效，否则返回 null
  Future<String?> checkValidSession() async {
    try {
      final token = await _storageService.getToken();
      final userId = await _storageService.getUserId();

      // 检查 token 和 userId 是否都存在且有效
      if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
        debugPrint('🔐 AutoLoginService: No valid session - missing token or userId');
        return null;
      }

      // 检查 token 是否过期
      final expiration = await _storageService.getExpiration();
      if (expiration != null && expiration.isBefore(DateTime.now())) {
        debugPrint('🔐 AutoLoginService: Token expired at $expiration');
        await clearSession();
        return null;
      }

      debugPrint('🔐 AutoLoginService: Valid session found for user $userId');
      return userId;
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Error checking session - $e');
      return null;
    }
  }

  /// 尝试使用存储的凭据自动登录
  /// 返回登录响应，如果失败则抛出异常
  Future<LoginResponse> attemptAutoLogin() async {
    try {
      final email = await _storageService.getEmail();
      final password = await _storageService.getPassword();

      if (email == null || email.isEmpty || password == null || password.isEmpty) {
        debugPrint('🔐 AutoLoginService: No stored credentials found');
        throw Exception('No stored credentials available for auto-login');
      }

      debugPrint('🔐 AutoLoginService: Attempting auto-login for $email');
      final response = await _authRepository.login(email, password);
      
      debugPrint('🔐 AutoLoginService: Auto-login successful');
      return response;
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Auto-login failed - $e');
      rethrow;
    }
  }

  /// 保存登录凭据
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _storageService.saveEmail(email);
      await _storageService.savePassword(password);
      debugPrint('🔐 AutoLoginService: Credentials saved for $email');
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Failed to save credentials - $e');
      rethrow;
    }
  }

  /// 检查是否有存储的凭据
  Future<bool> hasStoredCredentials() async {
    try {
      final email = await _storageService.getEmail();
      final password = await _storageService.getPassword();
      return email != null && email.isNotEmpty && 
             password != null && password.isNotEmpty;
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Error checking credentials - $e');
      return false;
    }
  }

  /// 获取存储的凭据
  Future<({String? email, String? password})> getStoredCredentials() async {
    try {
      final email = await _storageService.getEmail();
      final password = await _storageService.getPassword();
      return (email: email, password: password);
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Error getting credentials - $e');
      return (email: null, password: null);
    }
  }

  /// 清除所有会话数据（包括凭据）
  Future<void> clearSession() async {
    try {
      await _storageService.deleteToken();
      await _storageService.deleteExpiration();
      debugPrint('🔐 AutoLoginService: Session cleared');
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Error clearing session - $e');
      rethrow;
    }
  }

  /// 清除存储的凭据（但保留当前会话）
  Future<void> clearCredentials() async {
    try {
      await _storageService.deleteEmail();
      await _storageService.deletePassword();
      debugPrint('🔐 AutoLoginService: Credentials cleared');
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Error clearing credentials - $e');
      rethrow;
    }
  }

  /// 完全登出（清除所有数据）
  Future<void> fullLogout() async {
    try {
      await clearSession();
      await clearCredentials();
      debugPrint('🔐 AutoLoginService: Full logout completed');
    } catch (e) {
      debugPrint('🔐 AutoLoginService: Error during full logout - $e');
      rethrow;
    }
  }
}

