import 'package:flutter/material.dart';
import 'dart:io';

/// 自定义滚动行为，移除Android的过度滚动光晕效果
/// 这可以防止毛玻璃效果在过度滚动时失效
class NoOverscrollBehavior extends ScrollBehavior {
  const NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // 在所有平台上都移除过度滚动指示器
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // 使用 ClampingScrollPhysics 防止过度滚动
    return const ClampingScrollPhysics();
  }
}

/// 为带有毛玻璃效果的滚动视图创建自定义配置
/// 保留过度滚动效果，但使用 StretchingOverscrollIndicator 替代 GlowingOverscrollIndicator
class GlassmorphicScrollBehavior extends ScrollBehavior {
  const GlassmorphicScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // 在 Android 上使用 StretchingOverscrollIndicator
    // 它不会产生光晕效果，不会影响毛玻璃渲染
    if (Platform.isAndroid) {
      return StretchingOverscrollIndicator(
        axisDirection: details.direction,
        child: child,
      );
    }
    // iOS 和其他平台使用默认行为
    return super.buildOverscrollIndicator(context, child, details);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // 使用 BouncingScrollPhysics 保留弹性滚动效果
    return const BouncingScrollPhysics();
  }

  /// 创建一个配置了此行为的 ScrollConfiguration
  static Widget wrap({
    required Widget child,
  }) {
    return ScrollConfiguration(
      behavior: const GlassmorphicScrollBehavior(),
      child: child,
    );
  }
}

