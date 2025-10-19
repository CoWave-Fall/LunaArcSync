import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/rendering/page_level_blur_container.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';

/// 优化的毛玻璃列表，使用共享背景模糊效果
/// 
/// 使用新的共享渲染系统，性能更优。
class OptimizedGlassmorphicList extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String blurGroup;
  final double blur;
  final double opacity;

  const OptimizedGlassmorphicList({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.blurGroup = 'default_list',
    this.blur = 8.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    if (!hasCustomBackground) {
      // 没有自定义背景时，使用普通列表
      return ListView(
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        children: children,
      );
    }

    // 有自定义背景时，使用新的页面级共享模糊容器
    return PageLevelBlurContainer(
      layerId: blurGroup,
      blur: blur,
      backgroundOpacity: opacity * 0.3, // 页面级背景使用较低的不透明度
      child: ListView(
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        children: children,
      ),
    );
  }
}

/// 优化的毛玻璃列表构建器
/// 
/// 使用新的共享渲染系统，性能更优。
/// 所有子组件会自动使用共享模糊层。
class OptimizedGlassmorphicListBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String blurGroup;
  final double blur;
  final double opacity;

  const OptimizedGlassmorphicListBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.blurGroup = 'default_list',
    this.blur = 8.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    if (!hasCustomBackground) {
      // 没有自定义背景时，使用普通列表构建器
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
      );
    }

    // 有自定义背景时，使用新的页面级共享模糊容器
    return PageLevelBlurContainer(
      layerId: blurGroup,
      blur: blur,
      backgroundOpacity: opacity * 0.3, // 页面级背景使用较低的不透明度
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
      ),
    );
  }
}

/// 毛玻璃列表项包装器
class GlassmorphicListItem extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double opacity;
  final bool useSharedBlur;
  final String? blurGroup;

  const GlassmorphicListItem({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
    this.opacity = 0.1,
    this.useSharedBlur = true,
    this.blurGroup,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    if (!hasCustomBackground) {
      return Container(
        margin: margin,
        padding: padding,
        child: child,
      );
    }

    return OptimizedGlassmorphicContainer(
      opacity: opacity,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: padding,
      useSharedBlur: useSharedBlur,
      blurGroup: blurGroup,
      child: child,
    );
  }
}

/// 性能优化的毛玻璃滚动行为
class OptimizedGlassmorphicScrollBehavior extends ScrollBehavior {
  const OptimizedGlassmorphicScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // 禁用过度滚动指示器以提升性能
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: RangeMaintainingScrollPhysics(),
    );
  }
}


