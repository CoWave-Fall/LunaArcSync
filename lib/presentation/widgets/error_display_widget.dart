import 'package:flutter/material.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/global_error_handler.dart';
import '../../core/di/injection.dart';

/// 错误显示组件
/// 
/// 用于在UI中显示友好的错误信息
class ErrorDisplayWidget extends StatelessWidget {
  final AppException exception;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool showDetails;

  const ErrorDisplayWidget({
    Key? key,
    required this.exception,
    this.onRetry,
    this.onDismiss,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorHandler = getIt<GlobalErrorHandler>();
    final icon = errorHandler.getErrorIcon(exception);
    final color = errorHandler.getErrorColor(exception);
    final message = errorHandler.getUserFriendlyMessage(exception, context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 错误图标
            Icon(
              icon,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 24),
            
            // 错误标题
            Text(
              _getErrorTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // 错误消息
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            
            // 显示详细信息（仅在调试模式）
            if (showDetails && exception.originalError != null) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('技术详情'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      exception.originalError.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 24),
            
            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null && _canRetry()) ...[
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('重试'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (onDismiss != null)
                  OutlinedButton(
                    onPressed: onDismiss,
                    child: const Text('关闭'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorTitle() {
    if (exception is NetworkException) {
      final networkException = exception as NetworkException;
      if (networkException.isServerUnreachable) {
        return '服务器不可达';
      } else if (networkException.isAuthenticationError) {
        return '认证失败';
      }
      return '网络错误';
    }
    
    return '出错了';
  }

  bool _canRetry() {
    if (exception is NetworkException) {
      return (exception as NetworkException).canRetry;
    }
    return true;
  }
}

/// 错误提示 SnackBar
class ErrorSnackBar {
  static void show(
    BuildContext context,
    AppException exception, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final errorHandler = getIt<GlobalErrorHandler>();
    final message = errorHandler.getUserFriendlyMessage(exception, context);
    final icon = errorHandler.getErrorIcon(exception);
    final color = errorHandler.getErrorColor(exception);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: duration,
        action: onRetry != null
            ? SnackBarAction(
                label: '重试',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }
}

/// 错误对话框
class ErrorDialog {
  static Future<bool?> show(
    BuildContext context,
    AppException exception, {
    VoidCallback? onRetry,
  }) {
    final errorHandler = getIt<GlobalErrorHandler>();
    final message = errorHandler.getUserFriendlyMessage(exception, context);
    final icon = errorHandler.getErrorIcon(exception);
    final color = errorHandler.getErrorColor(exception);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(icon, size: 48, color: color),
        title: Text(
          _getDialogTitle(exception),
          style: TextStyle(color: color),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('关闭'),
          ),
          if (onRetry != null && _canRetry(exception))
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: const Text('重试'),
            ),
        ],
      ),
    );
  }

  static String _getDialogTitle(AppException exception) {
    if (exception is NetworkException) {
      final networkException = exception;
      if (networkException.isServerUnreachable) {
        return '服务器不可达';
      } else if (networkException.isAuthenticationError) {
        return '认证失败';
      }
      return '网络错误';
    }
    
    return '错误';
  }

  static bool _canRetry(AppException exception) {
    if (exception is NetworkException) {
      return exception.canRetry;
    }
    return true;
  }
}

/// 错误边界组件
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, AppException exception)? errorBuilder;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.errorBuilder,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppException? _exception;

  @override
  Widget build(BuildContext context) {
    if (_exception != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _exception!);
      }
      return ErrorDisplayWidget(
        exception: _exception!,
        onRetry: () {
          setState(() {
            _exception = null;
          });
        },
      );
    }

    return widget.child;
  }

  void setError(AppException exception) {
    setState(() {
      _exception = exception;
    });
  }
}


