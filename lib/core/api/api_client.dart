import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'auth_interceptor.dart'; // Import the interceptor
import 'error_handler_interceptor.dart'; // Import the error handler interceptor

// ApiClient is registered in RegisterModule, not here
class ApiClient {
  final Dio _dio;
  final Map<String, Future<Response>> _pendingRequests = {};

  ApiClient(
    AuthInterceptor authInterceptor,
    ErrorHandlerInterceptor errorHandlerInterceptor,
  ) : _dio = Dio(BaseOptions(
          // The baseUrl will be set dynamically
          baseUrl: '', // Start with an empty base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        )) {
    // Add interceptors in order:
    // 1. Error handler (first to catch all errors)
    // 2. Auth interceptor (for authentication)
    // 3. Log interceptor (for debugging)
    _dio.interceptors.add(errorHandlerInterceptor);
    _dio.interceptors.add(authInterceptor);
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Dio get dio => _dio;

  /// Updates the Dio instance's base URL.
  void setBaseUrl(String newBaseUrl) {
    // Ensure the URL is well-formed
    if (newBaseUrl.isNotEmpty && Uri.tryParse(newBaseUrl)?.isAbsolute == true) {
       _dio.options.baseUrl = newBaseUrl;
    } else {
      // Handle invalid URL, maybe log an error or throw an exception
      if (kDebugMode) {
        print('Error: Invalid base URL provided: $newBaseUrl');
      }
    }
  }

  /// Retrieves the current base URL.
  String getBaseUrl() {
    return _dio.options.baseUrl;
  }

  /// 请求去重方法，避免重复请求
  Future<Response> _deduplicateRequest(String key, Future<Response> Function() request) {
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key]!;
    }
    
    final future = request();
    _pendingRequests[key] = future;
    
    // 请求完成后从pending列表中移除
    future.whenComplete(() {
      _pendingRequests.remove(key);
    });
    
    return future;
  }

  /// 带去重的GET请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    final key = 'GET:$path:${queryParameters?.toString() ?? ''}';
    return _deduplicateRequest(key, () => _dio.get(path, queryParameters: queryParameters, options: options));
  }

  /// 带去重的POST请求
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    final key = 'POST:$path:${data?.toString() ?? ''}';
    return _deduplicateRequest(key, () => _dio.post(path, data: data, queryParameters: queryParameters, options: options));
  }

  /// 清除所有待处理的请求
  void clearPendingRequests() {
    _pendingRequests.clear();
  }
}