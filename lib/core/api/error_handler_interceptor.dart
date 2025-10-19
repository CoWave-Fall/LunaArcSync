import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../exceptions/app_exceptions.dart';

/// 网络错误处理拦截器
/// 
/// 此拦截器负责：
/// 1. 捕获和转换所有网络错误为统一的应用异常
/// 2. 提供智能重试机制
/// 3. 记录错误日志
/// 4. 处理服务器离线等特殊情况
@injectable
class ErrorHandlerInterceptor extends Interceptor {
  /// 最大重试次数
  static const int maxRetries = 3;
  
  /// 重试延迟（毫秒）
  static const List<int> retryDelays = [1000, 2000, 3000];

  ErrorHandlerInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('🔴 ErrorHandlerInterceptor: Error occurred');
    debugPrint('   Type: ${err.type}');
    debugPrint('   Message: ${err.message}');
    debugPrint('   Status Code: ${err.response?.statusCode}');
    debugPrint('   URL: ${err.requestOptions.uri}');

    // 将 DioException 转换为 NetworkException
    final networkException = NetworkException.fromDioException(err);
    
    // 检查是否可以重试
    if (networkException.canRetry && _shouldRetry(err.requestOptions)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
      
      if (retryCount < maxRetries) {
        debugPrint('⚠️ ErrorHandlerInterceptor: Retrying request (${retryCount + 1}/$maxRetries)');
        
        // 等待一段时间后重试
        await Future.delayed(Duration(milliseconds: retryDelays[retryCount]));
        
        try {
          // 更新重试计数
          err.requestOptions.extra['retryCount'] = retryCount + 1;
          
          // 重新发起请求
          final response = await Dio().fetch(err.requestOptions);
          
          debugPrint('✅ ErrorHandlerInterceptor: Retry succeeded');
          return handler.resolve(response);
        } catch (e) {
          debugPrint('❌ ErrorHandlerInterceptor: Retry failed - $e');
          // 如果重试失败，继续处理错误
        }
      } else {
        debugPrint('❌ ErrorHandlerInterceptor: Max retries reached');
      }
    }

    // 记录错误详情
    _logError(networkException);
    
    // 传递转换后的异常
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: networkException,
        message: networkException.message,
      ),
    );
  }

  /// 判断请求是否应该重试
  bool _shouldRetry(RequestOptions options) {
    // 不重试 POST/PUT/PATCH 请求（除非明确标记为可重试）
    if (options.method == 'POST' || 
        options.method == 'PUT' || 
        options.method == 'PATCH') {
      return options.extra['allowRetry'] == true;
    }
    
    // 默认重试 GET/DELETE 请求
    return true;
  }

  /// 记录错误信息
  void _logError(NetworkException exception) {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('🔴 Network Error Details:');
      debugPrint('   Type: ${exception.type}');
      debugPrint('   Message: ${exception.message}');
      debugPrint('   Code: ${exception.code ?? "N/A"}');
      debugPrint('   Can Retry: ${exception.canRetry}');
      debugPrint('   Is Server Unreachable: ${exception.isServerUnreachable}');
      debugPrint('   Is Auth Error: ${exception.isAuthenticationError}');
      if (exception.originalError != null) {
        debugPrint('   Original Error: ${exception.originalError}');
      }
      debugPrint('═══════════════════════════════════════');
    }
  }
}


