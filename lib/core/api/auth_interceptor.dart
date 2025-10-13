import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';

@injectable // This interceptor can now be injected
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // We only add tokens for non-authentication related endpoints
    if (options.path != '/accounts/login' &&
        options.path != '/accounts/register') {
      // --- START: Key Debugging Code ---
      debugPrint('--- AuthInterceptor ---');
      debugPrint('Intercepting request to: ${options.path}');
      final token = await _storageService.getToken();
      final expiration = await _storageService.getExpiration();

      if (expiration != null && expiration.isBefore(DateTime.now())) {
        debugPrint('Token has expired. Rejecting request.');
        // Optionally, perform logout action here
        await _storageService.deleteToken();
        await _storageService.deleteExpiration();

        // Reject the request with an error
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              statusMessage: 'Token expired',
            ),
            error: 'Token has expired. Please log in again.',
            type: DioExceptionType.badResponse,
          ),
        );
        return; // Stop further processing
      }

      if (token != null) {
        debugPrint('Token found. Attaching to header.');
        // Print part of the token to confirm it's not empty
        if (token.length > 15) {
          debugPrint('Token starts with: ${token.substring(0, 15)}...');
        }
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint('Token NOT found in secure storage!');
      }
      debugPrint('-----------------------');
      // --- END: Key Debugging Code ---
    }
    // Continue with the request
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('🔐 AuthInterceptor: Error intercepted - Type: ${err.type}, Status: ${err.response?.statusCode}');
    
    // 处理认证错误（401 未授权，403 禁止访问）
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      debugPrint('🔐 AuthInterceptor: Authentication error. Forcing logout.');
      // 清除会话并触发登出
      getIt<AuthCubit>().logout(clearCredentials: false); // 保留凭据，允许重新登录
    }
    
    // 处理连接失败（网络错误、超时等）
    else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      debugPrint('🔐 AuthInterceptor: Connection error detected - ${err.message}');
      // 连接错误不自动登出，但会在页面层面处理
    }
    
    super.onError(err, handler);
  }
}