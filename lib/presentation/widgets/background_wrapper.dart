import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';

/// 背景图片包装器 - 为页面添加背景图片支持
/// 
/// 用法：
/// ```dart
/// Scaffold(
///   body: BackgroundWrapper(
///     child: YourContent(),
///   ),
/// )
/// ```
class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final bool extendBody;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;

    if (!hasCustomBackground || backgroundNotifier.backgroundImageBytes == null) {
      // 没有自定义背景时，直接返回子组件
      return child;
    }

    // 有自定义背景时，添加背景图片层
    return Stack(
      children: [
        // 背景图片层
        Positioned.fill(
          child: Image.memory(
            backgroundNotifier.backgroundImageBytes!,
            fit: BoxFit.cover,
            // 添加错误处理
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading background image: $error');
              return const SizedBox.shrink();
            },
          ),
        ),
        
        // 内容层
        child,
      ],
    );
  }
}

/// 带背景的Scaffold
/// 
/// 用法：
/// ```dart
/// BackgroundScaffold(
///   appBar: AppBar(...),
///   body: YourContent(),
/// )
/// ```
class BackgroundScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const BackgroundScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body != null ? BackgroundWrapper(child: body!) : null,
    );
  }
}

