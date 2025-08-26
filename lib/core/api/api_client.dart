import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/di/injection.dart'; // Import getIt
import 'auth_interceptor.dart'; // Import the interceptor

@lazySingleton
class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://localhost:7135/api',
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    // Add our custom AuthInterceptor
    // We resolve it from getIt because it has its own dependencies
    _dio.interceptors.add(getIt<AuthInterceptor>());
  }

  Dio get dio => _dio;
}