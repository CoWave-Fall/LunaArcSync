import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../exceptions/app_exceptions.dart';
import '../di/injection.dart';
import '../../presentation/auth/cubit/auth_cubit.dart';

/// 错误事件
class ErrorEvent {
  final AppException exception;
  final DateTime timestamp;
  final String? context;

  ErrorEvent({
    required this.exception,
    required this.timestamp,
    this.context,
  });
}

/// 全局错误处理服务
/// 
/// 此服务负责：
/// 1. 统一处理应用中的所有错误
/// 2. 提供错误恢复建议
/// 3. 管理错误历史记录
/// 4. 触发相应的错误处理动作（如自动登出）
@lazySingleton
class GlobalErrorHandler {
  final StreamController<ErrorEvent> _errorController = StreamController<ErrorEvent>.broadcast();
  final List<ErrorEvent> _errorHistory = [];
  
  /// 最大错误历史记录数
  static const int maxErrorHistory = 100;

  /// 错误事件流
  Stream<ErrorEvent> get errorStream => _errorController.stream;

  /// 错误历史记录
  List<ErrorEvent> get errorHistory => List.unmodifiable(_errorHistory);

  /// 处理错误
  Future<void> handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    bool showToUser = true,
  }) async {
    debugPrint('🔴 GlobalErrorHandler: Handling error');
    debugPrint('   Context: ${context ?? "N/A"}');
    debugPrint('   Error: $error');

    // 将错误转换为 AppException
    final appException = _convertToAppException(error, stackTrace);

    // 创建错误事件
    final event = ErrorEvent(
      exception: appException,
      timestamp: DateTime.now(),
      context: context,
    );

    // 添加到历史记录
    _addToHistory(event);

    // 发送错误事件
    _errorController.add(event);

    // 执行特定的错误处理逻辑
    await _executeErrorHandling(appException);

    // 记录错误日志
    _logError(event);
  }

  /// 将任意错误转换为 AppException
  AppException _convertToAppException(dynamic error, StackTrace? stackTrace) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return NetworkException.fromDioException(error);
    }

    // 检查是否是 DioException 包装的 NetworkException
    if (error is DioException && error.error is NetworkException) {
      return error.error as NetworkException;
    }

    // 其他类型的错误
    return DataException(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// 执行错误处理逻辑
  Future<void> _executeErrorHandling(AppException exception) async {
    if (exception is NetworkException) {
      // 处理网络异常
      if (exception.isAuthenticationError) {
        debugPrint('🔴 GlobalErrorHandler: Authentication error detected, triggering logout');
        try {
          // 触发登出
          final authCubit = getIt<AuthCubit>();
          await authCubit.logout(clearCredentials: false);
        } catch (e) {
          debugPrint('🔴 GlobalErrorHandler: Error during forced logout - $e');
        }
      } else if (exception.isServerUnreachable) {
        debugPrint('🔴 GlobalErrorHandler: Server unreachable');
        // 可以在这里添加自动切换服务器的逻辑
      }
    }
  }

  /// 添加到错误历史记录
  void _addToHistory(ErrorEvent event) {
    _errorHistory.add(event);
    
    // 保持历史记录在限制范围内
    if (_errorHistory.length > maxErrorHistory) {
      _errorHistory.removeAt(0);
    }
  }

  /// 记录错误日志
  void _logError(ErrorEvent event) {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('🔴 Error Log:');
      debugPrint('   Time: ${event.timestamp}');
      debugPrint('   Context: ${event.context ?? "N/A"}');
      debugPrint('   Exception Type: ${event.exception.runtimeType}');
      debugPrint('   Message: ${event.exception.message}');
      debugPrint('   Code: ${event.exception.code ?? "N/A"}');
      debugPrint('═══════════════════════════════════════');
    }
  }

  /// 获取错误的用户友好消息
  String getUserFriendlyMessage(AppException exception, BuildContext? context) {
    if (exception is NetworkException) {
      switch (exception.type) {
        case NetworkExceptionType.serverOffline:
          return '服务器离线或无法访问\n\n建议：\n1. 检查网络连接\n2. 尝试切换服务器\n3. 稍后重试';
        case NetworkExceptionType.connectionError:
          return '无法连接到服务器\n\n建议：\n1. 检查服务器地址是否正确\n2. 检查网络连接\n3. 检查防火墙设置';
        case NetworkExceptionType.connectionTimeout:
          return '连接超时\n\n建议：\n1. 检查网络连接速度\n2. 尝试切换到更稳定的网络\n3. 稍后重试';
        case NetworkExceptionType.unauthorized:
          return '认证失败\n\n您的登录已过期，请重新登录';
        case NetworkExceptionType.forbidden:
          return '权限不足\n\n您没有权限访问此资源';
        case NetworkExceptionType.notFound:
          return '资源不存在\n\n请求的资源未找到';
        case NetworkExceptionType.serverError:
          return '服务器错误\n\n服务器遇到了问题，请稍后重试';
        default:
          return exception.message;
      }
    }

    return exception.message;
  }

  /// 获取错误图标
  IconData getErrorIcon(AppException exception) {
    if (exception is NetworkException) {
      if (exception.isServerUnreachable) {
        return Icons.cloud_off;
      } else if (exception.isAuthenticationError) {
        return Icons.lock_outline;
      }
      return Icons.wifi_off;
    }

    return Icons.error_outline;
  }

  /// 获取错误颜色
  Color getErrorColor(AppException exception) {
    if (exception is NetworkException) {
      if (exception.isAuthenticationError) {
        return Colors.orange;
      } else if (exception.isServerUnreachable) {
        return Colors.red;
      }
    }

    return Colors.red;
  }

  /// 清除错误历史
  void clearHistory() {
    _errorHistory.clear();
  }

  /// 释放资源
  void dispose() {
    _errorController.close();
  }
}


