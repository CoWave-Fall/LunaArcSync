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
    // Globally handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      debugPrint('AuthInterceptor: Received 401 Unauthorized error. Forcing logout.');
      // Use getIt to access the AuthCubit singleton and trigger logout
      // This will clear user session and navigate to the login screen
      getIt<AuthCubit>().logout();
    }
    super.onError(err, handler);
  }
}