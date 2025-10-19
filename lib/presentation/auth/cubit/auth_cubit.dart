import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/auth_repository.dart';
import 'package:luna_arc_sync/core/services/auto_login_service.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';
import 'package:luna_arc_sync/data/models/auth_models.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  final AutoLoginService _autoLoginService;
  final ServerCacheService _serverCacheService;
  final SecureStorageService _secureStorageService;
  final ApiClient _apiClient;

  AuthCubit(
    this._authRepository,
    this._autoLoginService,
    this._serverCacheService,
    this._secureStorageService,
    this._apiClient,
  ) : super(const AuthState.initial());

  /// 检查认证状态
  /// 在应用启动时调用，检查是否有有效的会话
  Future<void> checkAuthStatus() async {
    try {
      debugPrint('🔐 AuthCubit: Checking auth status...');
      
      // 使用 AutoLoginService 检查会话有效性
      final userId = await _autoLoginService.checkValidSession();
      
      if (userId != null) {
        // 获取存储的角色信息
        final role = await _autoLoginService.getStoredRole();
        final isAdmin = await _autoLoginService.getStoredIsAdmin();
        
        debugPrint('🔐 AuthCubit: Valid session found for user $userId');
        debugPrint('🔐 AuthCubit: User role: $role, isAdmin: $isAdmin');
        emit(AuthState.authenticated(
          userId: userId,
          isAdmin: isAdmin ?? false,
          role: role ?? 'User',
        ));
      } else {
        debugPrint('🔐 AuthCubit: No valid session found');
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      debugPrint('🔐 AuthCubit: Error during checkAuthStatus - $e');
      emit(const AuthState.unauthenticated());
    }
  }

  /// 尝试使用存储的凭据自动登录
  Future<void> attemptAutoLogin() async {
    try {
      debugPrint('🔐 AuthCubit: Attempting auto-login...');
      emit(const AuthState.unauthenticated(isLoading: true));
      
      final response = await _autoLoginService.attemptAutoLogin();
      
      // 保存用户信息到服务器缓存
      await _saveUserInfoToServerCache(response);
      
      debugPrint('🔐 AuthCubit: Auto-login successful for user ${response.userId}');
      emit(AuthState.authenticated(
        userId: response.userId,
        isAdmin: response.isAdmin,
        role: response.role,
      ));
    } catch (e) {
      debugPrint('🔐 AuthCubit: Auto-login failed - $e');
      emit(AuthState.unauthenticated(error: e.toString()));
    }
  }

  /// 登录
  /// saveCredentials 参数控制是否保存凭据用于自动登录
  Future<void> login(
    String email,
    String password, {
    bool saveCredentials = true,
  }) async {
    try {
      debugPrint('🔐 AuthCubit: Starting login for $email...');
      emit(const AuthState.unauthenticated(isLoading: true));
      
      final response = await _authRepository.login(email, password);
      
      // 保存凭据以支持自动登录（如果需要）
      if (saveCredentials) {
        await _autoLoginService.saveCredentials(
          email: email,
          password: password,
        );
        debugPrint('🔐 AuthCubit: Credentials saved for auto-login');
      }
      
      // 保存用户信息到服务器缓存
      await _saveUserInfoToServerCache(response);
      
      debugPrint('🔐 AuthCubit: Login successful for user ${response.userId}');
      emit(AuthState.authenticated(
        userId: response.userId,
        isAdmin: response.isAdmin,
        role: response.role,
      ));
    } catch (e) {
      debugPrint('🔐 AuthCubit: Login failed - $e');
      emit(AuthState.unauthenticated(error: e.toString()));
    }
  }
  
  /// 保存用户信息到服务器缓存
  Future<void> _saveUserInfoToServerCache(LoginResponse response) async {
    try {
      // 获取当前服务器URL
      final serverUrl = await _secureStorageService.getServerUrl();
      if (serverUrl == null || serverUrl.isEmpty) {
        debugPrint('🔐 AuthCubit: 无法保存用户信息到服务器缓存 - 服务器URL为空');
        return;
      }
      
      // 获取服务器信息
      final aboutResponse = await _apiClient.dio.get('/api/about');
      final about = AboutResponse.fromJson(aboutResponse.data);
      
      // 更新服务器缓存，包含用户信息
      await _serverCacheService.cacheServerInfo(
        about,
        serverUrl: serverUrl,
        username: response.username,
        nickname: response.nickname,
      );
      
      debugPrint('🔐 AuthCubit: 用户信息已保存到服务器缓存: ${response.nickname} (${response.username})');
    } catch (e) {
      debugPrint('🔐 AuthCubit: 保存用户信息到服务器缓存失败 - $e');
      // 不抛出异常，因为这不是关键操作
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      emit(const AuthState.unauthenticated(isLoading: true));
      await _authRepository.register(email, password, confirmPassword);
      await login(email, password);
    } catch (e) {
      emit(AuthState.unauthenticated(error: e.toString()));
    }
  }

  /// 登出
  /// clearCredentials 参数控制是否清除存储的凭据（默认不清除，允许重新登录）
  Future<void> logout({bool clearCredentials = false}) async {
    try {
      debugPrint('🔐 AuthCubit: Logging out...');
      
      await _authRepository.logout();
      
      if (clearCredentials) {
        await _autoLoginService.clearCredentials();
        debugPrint('🔐 AuthCubit: Credentials cleared');
      }
      
      debugPrint('🔐 AuthCubit: Logout successful');
      emit(const AuthState.unauthenticated());
    } catch (e) {
      debugPrint('🔐 AuthCubit: Logout error - $e');
      emit(const AuthState.unauthenticated());
    }
  }

  /// 检查是否有存储的凭据
  Future<bool> hasStoredCredentials() async {
    return await _autoLoginService.hasStoredCredentials();
  }
}