import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:flutter/foundation.dart';

@injectable // This interceptor can now be injected
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
Future<void> onRequest(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  // 我们只为非认证相关的端点添加 Token
  if (options.path != '/accounts/login' && options.path != '/accounts/register') {
    
    // --- START: 关键调试代码 ---
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
      // 打印部分 token 以确认不是空的
      debugPrint('Token starts with: ${token.substring(0, 15)}...'); 
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      debugPrint('Token NOT found in secure storage!');
    }
    debugPrint('-----------------------');
    // --- END: 关键调试代码 ---

  }
  // 继续执行请求
  return super.onRequest(options, handler);
}

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Here we can globally handle 401 Unauthorized errors later
    // For example, trigger a logout
    // if (err.response?.statusCode == 401) {
    //   // getIt<AuthCubit>().logout();
    // }
    super.onError(err, handler);
  }
}