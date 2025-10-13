import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/color_utils.dart';

/// 毛玻璃容器，仅在启用自定义背景时显示毛玻璃效果
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool enhanceTextReadability;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.enhanceTextReadability = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    if (!hasCustomBackground) {
      // 没有自定义背景时，使用普通容器
      return Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
        ),
        child: child,
      );
    }

    // 有自定义背景时，使用毛玻璃效果
    final surfaceColor = Theme.of(context).colorScheme.surface;
    
    // 自动为所有毛玻璃容器添加文字阴影以提高可读性
    Widget contentChild = DefaultTextStyle.merge(
      style: TextStyle(
        shadows: ColorUtils.getTextShadowsForBackground(
          backgroundColor: ColorUtils.isDark(surfaceColor) ? Colors.black : Colors.white,
          blurRadius: 2.0,
          opacity: 0.3,
        ),
      ),
      child: child,
    );
    
    // 如果显式要求增强可读性，添加更强的效果
    if (enhanceTextReadability) {
      final textStyle = ColorUtils.getTextStyleForGlassmorphism(
        context,
        baseStyle: Theme.of(context).textTheme.bodyMedium,
        addShadow: true,
      );
      
      if (textStyle != null) {
        contentChild = DefaultTextStyle(
          style: textStyle,
          child: contentChild,
        );
      }
    }
    
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: RepaintBoundary(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(opacity),
                borderRadius: borderRadius,
                border: border ?? Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: contentChild,
            ),
          ),
        ),
      ),
    );
  }
}

/// 毛玻璃卡片
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final content = GlassmorphicContainer(
      blur: blur,
      opacity: opacity,
      borderRadius: BorderRadius.circular(12),
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    }

    return content;
  }
}

/// 毛玻璃列表项
class GlassmorphicListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? margin;

  const GlassmorphicListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.blur = 8.0,
    this.opacity = 0.1,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      blur: blur,
      opacity: opacity,
      borderRadius: BorderRadius.circular(8),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

