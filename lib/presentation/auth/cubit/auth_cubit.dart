import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/auth_repository.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  final SecureStorageService _storageService;

  AuthCubit(this._authRepository, this._storageService) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
  try {
    final token = await _storageService.getToken();

    // --- START: 关键逻辑加固 ---
    // 检查 token 是否为 null 并且不是一个空字符串
    if (token != null && token.isNotEmpty) {
      final userId = await _storageService.getUserId();
      if (userId != null && userId.isNotEmpty) {
         debugPrint('AuthCubit: Token and UserId found in storage. User is authenticated.');
         emit(AuthState.authenticated(userId: userId));
      } else {
         // 虽然有 token，但没有 user id，视为无效状态
         debugPrint('AuthCubit: Token found but UserId is missing. User is unauthenticated.');
         emit(const AuthState.unauthenticated());
      }
    } else {
      // 如果 token 是 null 或空字符串，则用户未登录
      debugPrint('AuthCubit: Token is null or empty. User is unauthenticated.');
      emit(const AuthState.unauthenticated());
    }
    // --- END: 关键逻辑加固 ---

  } catch (e) {
    debugPrint('AuthCubit: Error during checkAuthStatus. User is unauthenticated. Error: $e');
    emit(const AuthState.unauthenticated());
  }
}

  Future<void> login(String email, String password) async {
    try {
      // 1. 发出加载状态
      emit(const AuthState.unauthenticated(isLoading: true));
      final response = await _authRepository.login(email, password);
      // 2. 成功后，发出认证成功状态
      emit(AuthState.authenticated(userId: response.userId));
    } catch (e) {
      // 3. 失败后，发出带有错误信息的状态
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

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthState.unauthenticated());
  }
}