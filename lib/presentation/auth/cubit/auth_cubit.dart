import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/auth_repository.dart';
import 'package:luna_arc_sync/core/services/auto_login_service.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  final AutoLoginService _autoLoginService;

  AuthCubit(
    this._authRepository,
    this._autoLoginService,
  ) : super(const AuthState.initial());

  /// 检查认证状态
  /// 在应用启动时调用，检查是否有有效的会话
  Future<void> checkAuthStatus() async {
    try {
      debugPrint('🔐 AuthCubit: Checking auth status...');
      
      // 使用 AutoLoginService 检查会话有效性
      final userId = await _autoLoginService.checkValidSession();
      
      if (userId != null) {
        debugPrint('🔐 AuthCubit: Valid session found for user $userId');
        emit(AuthState.authenticated(userId: userId));
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
      
      debugPrint('🔐 AuthCubit: Auto-login successful for user ${response.userId}');
      emit(AuthState.authenticated(userId: response.userId));
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
      
      debugPrint('🔐 AuthCubit: Login successful for user ${response.userId}');
      emit(AuthState.authenticated(userId: response.userId));
    } catch (e) {
      debugPrint('🔐 AuthCubit: Login failed - $e');
      emit(AuthState.unauthenticated(error: e.toString()));
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