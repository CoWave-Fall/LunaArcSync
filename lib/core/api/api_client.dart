import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'auth_interceptor.dart'; // Import the interceptor

class ApiClient {
  final Dio _dio;

  ApiClient(AuthInterceptor authInterceptor)
      : _dio = Dio(BaseOptions(
          // The baseUrl will be set dynamically
          baseUrl: '', // Start with an empty base URL
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    // Add our custom AuthInterceptor, now passed via constructor
    _dio.interceptors.add(authInterceptor);
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
}