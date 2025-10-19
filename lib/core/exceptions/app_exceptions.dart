import 'package:dio/dio.dart';

/// 基础应用异常
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// 网络异常
class NetworkException extends AppException {
  final NetworkExceptionType type;

  NetworkException({
    required String message,
    required this.type,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// 从 DioException 创建 NetworkException
  factory NetworkException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          message: '连接超时，请检查网络连接',
          type: NetworkExceptionType.connectionTimeout,
          originalError: error,
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: '发送请求超时，请检查网络连接',
          type: NetworkExceptionType.sendTimeout,
          originalError: error,
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: '接收数据超时，请检查网络连接',
          type: NetworkExceptionType.receiveTimeout,
          originalError: error,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: '无法连接到服务器，请检查网络或服务器地址',
          type: NetworkExceptionType.connectionError,
          originalError: error,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return NetworkException(
            message: '认证失败，请重新登录',
            type: NetworkExceptionType.unauthorized,
            code: statusCode.toString(),
            originalError: error,
          );
        } else if (statusCode == 403) {
          return NetworkException(
            message: '没有权限访问此资源',
            type: NetworkExceptionType.forbidden,
            code: statusCode.toString(),
            originalError: error,
          );
        } else if (statusCode == 404) {
          return NetworkException(
            message: '请求的资源不存在',
            type: NetworkExceptionType.notFound,
            code: statusCode.toString(),
            originalError: error,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return NetworkException(
            message: '服务器错误，请稍后再试',
            type: NetworkExceptionType.serverError,
            code: statusCode.toString(),
            originalError: error,
          );
        }
        return NetworkException(
          message: '请求失败: ${error.response?.statusMessage ?? "未知错误"}',
          type: NetworkExceptionType.badResponse,
          code: statusCode?.toString(),
          originalError: error,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          message: '请求已取消',
          type: NetworkExceptionType.cancelled,
          originalError: error,
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'SSL证书验证失败',
          type: NetworkExceptionType.badCertificate,
          originalError: error,
        );
      case DioExceptionType.unknown:
        // 检查是否是服务器完全离线的情况
        if (error.message?.contains('SocketException') == true ||
            error.message?.contains('Failed host lookup') == true) {
          return NetworkException(
            message: '服务器离线或无法访问',
            type: NetworkExceptionType.serverOffline,
            originalError: error,
          );
        }
        return NetworkException(
          message: '网络错误: ${error.message ?? "未知错误"}',
          type: NetworkExceptionType.unknown,
          originalError: error,
        );
    }
  }

  /// 是否是服务器不可达的错误
  bool get isServerUnreachable {
    return type == NetworkExceptionType.serverOffline ||
        type == NetworkExceptionType.connectionError ||
        type == NetworkExceptionType.connectionTimeout;
  }

  /// 是否是认证相关的错误
  bool get isAuthenticationError {
    return type == NetworkExceptionType.unauthorized ||
        type == NetworkExceptionType.forbidden;
  }

  /// 是否可以重试
  bool get canRetry {
    return type != NetworkExceptionType.unauthorized &&
        type != NetworkExceptionType.forbidden &&
        type != NetworkExceptionType.cancelled;
  }
}

/// 网络异常类型
enum NetworkExceptionType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  connectionError,
  serverOffline,
  badResponse,
  unauthorized,
  forbidden,
  notFound,
  serverError,
  cancelled,
  badCertificate,
  unknown,
}

/// 认证异常
class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// 数据异常
class DataException extends AppException {
  DataException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// 服务器异常
class ServerException extends AppException {
  final int? statusCode;

  ServerException({
    required String message,
    this.statusCode,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// 缓存异常
class CacheException extends AppException {
  CacheException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}


