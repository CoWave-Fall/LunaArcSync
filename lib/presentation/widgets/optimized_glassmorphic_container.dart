import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/color_utils.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/performance/glassmorphic_performance_monitor.dart';
import 'package:luna_arc_sync/core/effects/kawase_blur.dart';
import 'package:luna_arc_sync/core/rendering/shared_blur_layer_manager.dart';

/// 优化的毛玻璃容器组件
/// 
/// 这是一个高性能的毛玻璃效果容器，提供以下功能：
/// - **共享模糊**：相同组的组件共享模糊效果，减少渲染开销
/// - **缓存优化**：缓存过滤器对象，避免重复创建
/// - **性能监控**：记录渲染时间和性能数据
/// - **多种模糊方法**：支持高斯模糊和 Kawase 模糊
/// - **自适应文本**：自动添加文本阴影以提高可读性
/// 
/// ### 使用示例
/// ```dart
/// OptimizedGlassmorphicContainer(
///   blur: 10.0,
///   opacity: 0.15,
///   useSharedBlur: true,
///   blurGroup: 'my_group',
///   child: Text('内容'),
/// )
/// ```
/// 
/// ### 性能提示
/// - 对于列表中的多个项目，使用相同的 [blurGroup] 以启用共享模糊
/// - 在低端设备或长列表中，考虑降低 [blur] 值
/// - 使用 [useSharedBlur] = true 可以显著提升性能
class OptimizedGlassmorphicContainer extends StatefulWidget {
  /// 子组件
  final Widget child;
  
  /// 模糊强度（sigma 值）
  /// 
  /// 推荐值：
  /// - 轻度模糊：5.0
  /// - 标准模糊：10.0
  /// - 重度模糊：15.0
  final double blur;
  
  /// 背景不透明度（0.0 - 1.0）
  /// 
  /// 推荐值：
  /// - 轻微：0.05
  /// - 标准：0.1
  /// - 中等：0.15
  /// - 较强：0.2
  final double opacity;
  
  /// 圆角半径
  final BorderRadius? borderRadius;
  
  /// 边框样式
  final Border? border;
  
  /// 内边距
  final EdgeInsetsGeometry? padding;
  
  /// 外边距
  final EdgeInsetsGeometry? margin;
  
  /// 是否增强文本可读性
  /// 
  /// 启用时会添加更强的文本阴影效果
  final bool enhanceTextReadability;
  
  /// 是否使用共享模糊效果
  /// 
  /// 启用后，相同 [blurGroup] 的组件将共享模糊效果，
  /// 显著提升列表渲染性能
  final bool useSharedBlur;
  
  /// 模糊组标识
  /// 
  /// 相同组的组件将共享模糊效果。
  /// 例如：列表中的所有项目可以使用 'list_items' 作为组名
  final String? blurGroup;
  
  /// 模糊方法
  /// 
  /// 可选值：
  /// - [BlurMethod.gaussian]：高斯模糊（默认）
  /// - [BlurMethod.kawase]：Kawase 模糊（性能更好）
  final BlurMethod blurMethod;
  
  /// Kawase 模糊配置
  /// 
  /// 仅在 [blurMethod] 为 [BlurMethod.kawase] 时有效
  final KawaseBlurConfig? kawaseConfig;

  const OptimizedGlassmorphicContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.enhanceTextReadability = false,
    this.useSharedBlur = true,
    this.blurGroup,
    this.blurMethod = BlurMethod.gaussian,
    this.kawaseConfig,
  });

  @override
  State<OptimizedGlassmorphicContainer> createState() => _OptimizedGlassmorphicContainerState();
}

class _OptimizedGlassmorphicContainerState extends State<OptimizedGlassmorphicContainer> {
  final GlassmorphicPerformanceMonitor _monitor = GlassmorphicPerformanceMonitor();
  DateTime? _renderStartTime;
  
  /// 记录性能数据
  /// 
  /// [usedSharedBlur] 是否使用了共享模糊
  /// [usedCache] 是否使用了缓存
  void _recordPerformance(bool usedSharedBlur, bool usedCache) {
    if (_renderStartTime != null) {
      final renderTime = DateTime.now().difference(_renderStartTime!).inMicroseconds ~/ 1000;
      
      _monitor.recordRenderTime(
        componentType: 'OptimizedGlassmorphicContainer',
        blurGroup: widget.blurGroup ?? 'default',
        blurIntensity: widget.blur,
        opacity: widget.opacity,
        renderTimeMs: renderTime,
        usedSharedBlur: usedSharedBlur,
        usedCache: usedCache,
      );
      
      // 如果是Kawase模糊，记录额外的性能数据
      if (widget.blurMethod == BlurMethod.kawase && widget.kawaseConfig != null) {
        final kawaseMonitor = KawaseBlurPerformanceMonitor();
        kawaseMonitor.recordPerformance(KawaseBlurPerformanceData(
          timestamp: DateTime.now(),
          radius: widget.kawaseConfig!.radius,
          passes: widget.kawaseConfig!.passes,
          renderTimeMs: renderTime,
          preset: _getKawasePresetName(),
        ));
      }
    }
  }
  
  /// 获取 Kawase 预设名称
  /// 
  /// 根据配置的半径和遍数返回预设名称
  String _getKawasePresetName() {
    if (widget.kawaseConfig == null) return 'custom';
    
    final config = widget.kawaseConfig!;
    if (config.radius <= 4 && config.passes <= 2) return 'light';
    if (config.radius <= 8 && config.passes <= 4) return 'medium';
    if (config.radius <= 16 && config.passes <= 6) return 'strong';
    return 'ultra';
  }

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    // 记录渲染开始时间
    _renderStartTime = DateTime.now();
    
    if (!hasCustomBackground) {
      // 没有自定义背景时，使用普通容器
      return Container(
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: widget.border,
        ),
        child: widget.child,
      );
    }

    // 有自定义背景时，使用优化的毛玻璃效果
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
      child: widget.child,
    );
    
    // 如果显式要求增强可读性，添加更强的效果
    if (widget.enhanceTextReadability) {
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
    
    // 检查是否在共享模糊层中
    final isInSharedLayer = widget.useSharedBlur && 
        widget.blurGroup != null &&
        SharedBlurLayerManager.isInSharedBlurLayer(context, widget.blurGroup);
    
    Widget container;
    bool usedSharedBlur;
    
    if (isInSharedLayer) {
      // 在共享层中，不创建 BackdropFilter，只使用半透明背景
      container = _buildSharedBlurContainer(
        context,
        contentChild,
        surfaceColor,
      );
      usedSharedBlur = true;
    } else if (widget.useSharedBlur && widget.blurGroup != null) {
      // 启用了共享模糊但不在共享层中，回退到独立模糊
      container = _buildIndependentBlurContainer(
        context,
        contentChild,
        surfaceColor,
      );
      usedSharedBlur = false;
    } else {
      // 使用独立模糊效果（带性能优化）
      container = _buildIndependentBlurContainer(
        context,
        contentChild,
        surfaceColor,
      );
      usedSharedBlur = false;
    }
    
    // 记录性能数据
    _recordPerformance(usedSharedBlur, true);
    
    return container;
  }

  /// 构建共享模糊容器
  /// 
  /// 不使用 BackdropFilter，而是依赖父组件提供的共享模糊背景。
  /// 这是性能优化的核心：避免创建多个 BackdropFilter。
  Widget _buildSharedBlurContainer(
    BuildContext context,
    Widget contentChild,
    Color surfaceColor,
  ) {
    return Container(
      margin: widget.margin,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: RepaintBoundary(
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              // 使用半透明背景，模糊效果由父层提供
              color: surfaceColor.withOpacity(widget.opacity),
              borderRadius: widget.borderRadius,
              border: widget.border ?? Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: contentChild,
          ),
        ),
      ),
    );
  }

  /// 构建独立模糊容器
  /// 
  /// 使用 BackdropFilter 创建独立的模糊效果，
  /// 并通过缓存优化性能
  Widget _buildIndependentBlurContainer(
    BuildContext context,
    Widget contentChild,
    Color surfaceColor,
  ) {
    // 使用缓存的毛玻璃过滤器
    final cachedFilter = GlassmorphicCache().getOrCreateFilter(
      blurX: widget.blur,
      blurY: widget.blur,
      opacity: widget.opacity,
      color: surfaceColor,
      blurMethod: widget.blurMethod,
      kawaseConfig: widget.kawaseConfig,
    );

    return Container(
      margin: widget.margin,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: RepaintBoundary(
          child: BackdropFilter(
            filter: cachedFilter,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(widget.opacity),
                borderRadius: widget.borderRadius,
                border: widget.border ?? Border.all(
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

/// 共享毛玻璃背景提供者
class SharedGlassmorphicBackground extends StatelessWidget {
  final Widget child;
  final double blur;
  final String blurGroup;

  const SharedGlassmorphicBackground({
    super.key,
    required this.child,
    required this.blurGroup,
    this.blur = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    if (!hasCustomBackground) {
      return child;
    }

    // 使用缓存的毛玻璃过滤器
    final cachedFilter = GlassmorphicCache().getOrCreateFilter(
      blurX: blur,
      blurY: blur,
    );

    return ClipRect(
      child: BackdropFilter(
        filter: cachedFilter,
        child: child,
      ),
    );
  }
}

/// 优化的毛玻璃卡片
class OptimizedGlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool useSharedBlur;
  final String? blurGroup;
  final BlurMethod blurMethod;
  final KawaseBlurConfig? kawaseConfig;

  const OptimizedGlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.useSharedBlur = true,
    this.blurGroup,
    this.blurMethod = BlurMethod.gaussian,
    this.kawaseConfig,
  });

  @override
  Widget build(BuildContext context) {
    final content = OptimizedGlassmorphicContainer(
      blur: blur,
      opacity: opacity,
      borderRadius: BorderRadius.circular(12),
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      useSharedBlur: useSharedBlur,
      blurGroup: blurGroup,
      blurMethod: blurMethod,
      kawaseConfig: kawaseConfig,
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

/// 优化的毛玻璃列表项
class OptimizedGlassmorphicListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? margin;
  final bool useSharedBlur;
  final String? blurGroup;

  const OptimizedGlassmorphicListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.blur = 8.0,
    this.opacity = 0.1,
    this.margin,
    this.useSharedBlur = true,
    this.blurGroup,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedGlassmorphicContainer(
      blur: blur,
      opacity: opacity,
      borderRadius: BorderRadius.circular(8),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      useSharedBlur: useSharedBlur,
      blurGroup: blurGroup,
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

/// 毛玻璃性能配置
class GlassmorphicPerformanceConfig {
  static const double lightBlur = 5.0;
  static const double mediumBlur = 10.0;
  static const double heavyBlur = 15.0;
  
  static const double lightOpacity = 0.05;
  static const double mediumOpacity = 0.1;
  static const double heavyOpacity = 0.2;
  
  // 根据设备性能调整模糊强度
  static double getAdjustedBlur(double baseBlur, {bool isLowEndDevice = false}) {
    if (isLowEndDevice) {
      return baseBlur * 0.6; // 低端设备减少模糊强度
    }
    return baseBlur;
  }
  
  // 根据列表长度调整模糊强度
  static double getListAdjustedBlur(double baseBlur, int listLength) {
    if (listLength > 50) {
      return baseBlur * 0.7; // 长列表减少模糊强度
    } else if (listLength > 20) {
      return baseBlur * 0.8;
    }
    return baseBlur;
  }
}
