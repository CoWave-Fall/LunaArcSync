import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/effects/kawase_blur.dart';
import 'package:luna_arc_sync/core/rendering/shared_blur_layer_manager.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';

/// 页面级共享模糊容器
/// 
/// 为整个页面或大型区域提供统一的模糊背景层。
/// 这是性能优化的关键组件，通过在页面级别创建单一的 BackdropFilter，
/// 避免子组件创建多个独立的模糊层。
/// 
/// ### 性能优势
/// - **减少 BackdropFilter 数量**：从 N 个减少到 1 个（N = 子组件数量）
/// - **降低 GPU 负载**：模糊计算只执行一次
/// - **提升滚动性能**：列表滚动时不需要重新计算模糊
/// - **减少重绘范围**：使用 RepaintBoundary 隔离变化区域
/// 
/// ### 使用场景
/// 1. **列表页面**：文档列表、页面列表、任务列表等
/// 2. **卡片网格**：多个卡片组成的网格布局
/// 3. **复杂页面**：包含多个毛玻璃组件的页面
/// 
/// ### 使用示例
/// ```dart
/// // 在列表页面中使用
/// PageLevelBlurContainer(
///   layerId: 'document_list',
///   child: ListView.builder(
///     itemBuilder: (context, index) {
///       return OptimizedGlassmorphicContainer(
///         blurGroup: 'document_list', // 必须匹配 layerId
///         child: ListTile(...),
///       );
///     },
///   ),
/// )
/// 
/// // 在卡片网格中使用
/// PageLevelBlurContainer(
///   layerId: 'about_cards',
///   blur: 15.0,
///   child: GridView.builder(
///     itemBuilder: (context, index) {
///       return OptimizedGlassmorphicCard(
///         blurGroup: 'about_cards',
///         child: CardContent(),
///       );
///     },
///   ),
/// )
/// ```
class PageLevelBlurContainer extends StatelessWidget {
  /// 子组件（通常是列表或网格）
  final Widget child;
  
  /// 共享层标识
  /// 
  /// 子组件的 blurGroup 必须匹配此 layerId 才能使用共享渲染
  final String layerId;
  
  /// 模糊强度
  final double? blur;
  
  /// 模糊方法
  final BlurMethod? blurMethod;
  
  /// Kawase 模糊配置
  final KawaseBlurConfig? kawaseConfig;
  
  /// 背景不透明度
  final double? backgroundOpacity;
  
  /// 背景颜色（可选，默认使用主题的 surface 颜色）
  final Color? backgroundColor;
  
  /// 是否启用性能监控
  final bool enablePerformanceMonitoring;
  
  const PageLevelBlurContainer({
    super.key,
    required this.child,
    required this.layerId,
    this.blur,
    this.blurMethod,
    this.kawaseConfig,
    this.backgroundOpacity,
    this.backgroundColor,
    this.enablePerformanceMonitoring = false,
  });
  
  @override
  Widget build(BuildContext context) {
    // 检查是否有自定义背景
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    
    if (!hasCustomBackground) {
      // 无自定义背景时，不需要模糊效果
      return LightweightSharedBlurLayerProvider(
        layerId: layerId,
        child: child,
      );
    }
    
    // 获取性能配置
    final performanceNotifier = context.watch<GlassmorphicPerformanceNotifier>();
    final config = performanceNotifier.config;
    
    // 计算实际的模糊参数
    final actualBlur = config.getActualBlur(blur ?? 10.0);
    final actualOpacity = config.getActualOpacity(backgroundOpacity ?? 0.05);
    final actualBlurMethod = blurMethod ?? config.blurMethod;
    final actualKawaseConfig = actualBlurMethod == BlurMethod.kawase
        ? (kawaseConfig ?? config.getKawaseConfig())
        : null;
    
    // 如果模糊被禁用，使用轻量级提供者
    if (actualBlur == 0) {
      return LightweightSharedBlurLayerProvider(
        layerId: layerId,
        blur: actualBlur,
        blurMethod: actualBlurMethod,
        kawaseConfig: actualKawaseConfig,
        child: child,
      );
    }
    
    // 使用共享模糊层提供者
    return _PerformanceMonitoredBlurLayer(
      layerId: layerId,
      blur: actualBlur,
      blurMethod: actualBlurMethod,
      kawaseConfig: actualKawaseConfig,
      backgroundOpacity: actualOpacity,
      backgroundColor: backgroundColor,
      enableMonitoring: enablePerformanceMonitoring,
      child: child,
    );
  }
}

/// 带性能监控的模糊层
class _PerformanceMonitoredBlurLayer extends StatefulWidget {
  final Widget child;
  final String layerId;
  final double blur;
  final BlurMethod blurMethod;
  final KawaseBlurConfig? kawaseConfig;
  final double backgroundOpacity;
  final Color? backgroundColor;
  final bool enableMonitoring;
  
  const _PerformanceMonitoredBlurLayer({
    required this.child,
    required this.layerId,
    required this.blur,
    required this.blurMethod,
    this.kawaseConfig,
    required this.backgroundOpacity,
    this.backgroundColor,
    required this.enableMonitoring,
  });
  
  @override
  State<_PerformanceMonitoredBlurLayer> createState() => 
      _PerformanceMonitoredBlurLayerState();
}

class _PerformanceMonitoredBlurLayerState 
    extends State<_PerformanceMonitoredBlurLayer> {
  DateTime? _renderStartTime;
  final _collector = SharedBlurPerformanceCollector();
  int _componentCount = 0;
  
  @override
  void initState() {
    super.initState();
    if (widget.enableMonitoring) {
      _renderStartTime = DateTime.now();
      // 在下一帧记录性能数据
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recordPerformance();
      });
    }
  }
  
  @override
  void didUpdateWidget(_PerformanceMonitoredBlurLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableMonitoring) {
      _renderStartTime = DateTime.now();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recordPerformance();
      });
    }
  }
  
  void _recordPerformance() {
    if (_renderStartTime != null) {
      final renderTime = DateTime.now()
          .difference(_renderStartTime!)
          .inMicroseconds ~/ 1000;
      
      _collector.recordRenderPerformance(widget.layerId, renderTime);
      _renderStartTime = null;
    }
  }
  
  void _updateComponentCount(int count) {
    if (_componentCount != count) {
      _componentCount = count;
      _collector.recordLayerUsage(widget.layerId, count);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SharedBlurLayerProvider(
      layerId: widget.layerId,
      blur: widget.blur,
      blurMethod: widget.blurMethod,
      kawaseConfig: widget.kawaseConfig,
      backgroundColor: widget.backgroundColor,
      backgroundOpacity: widget.backgroundOpacity,
      child: _ComponentCounter(
        onCountChanged: _updateComponentCount,
        child: widget.child,
      ),
    );
  }
}

/// 组件计数器
/// 
/// 统计共享模糊层中的组件数量，用于性能分析
class _ComponentCounter extends StatefulWidget {
  final Widget child;
  final ValueChanged<int> onCountChanged;
  
  const _ComponentCounter({
    required this.child,
    required this.onCountChanged,
  });
  
  @override
  State<_ComponentCounter> createState() => _ComponentCounterState();
}

class _ComponentCounterState extends State<_ComponentCounter> {
  int _count = 0;
  
  void incrementCount() {
    setState(() {
      _count++;
      widget.onCountChanged(_count);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _ComponentCountProvider(
      counter: this,
      child: widget.child,
    );
  }
}

/// 组件计数提供者
class _ComponentCountProvider extends InheritedWidget {
  final _ComponentCounterState counter;
  
  const _ComponentCountProvider({
    required this.counter,
    required super.child,
  });
  
  @override
  bool updateShouldNotify(_ComponentCountProvider oldWidget) {
    return counter != oldWidget.counter;
  }
}

/// 滚动视图共享模糊容器
/// 
/// 专门为滚动视图（ListView、GridView等）优化的共享模糊容器。
/// 包含额外的滚动性能优化。
class ScrollViewBlurContainer extends StatelessWidget {
  final Widget child;
  final String layerId;
  final double? blur;
  final double? backgroundOpacity;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  
  const ScrollViewBlurContainer({
    super.key,
    required this.child,
    required this.layerId,
    this.blur,
    this.backgroundOpacity,
    this.controller,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    return PageLevelBlurContainer(
      layerId: layerId,
      blur: blur,
      backgroundOpacity: backgroundOpacity,
      child: RepaintBoundary(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// 网格视图共享模糊容器
/// 
/// 专门为网格视图优化的共享模糊容器
class GridViewBlurContainer extends StatelessWidget {
  final Widget child;
  final String layerId;
  final double? blur;
  final double? backgroundOpacity;
  final EdgeInsetsGeometry? padding;
  
  const GridViewBlurContainer({
    super.key,
    required this.child,
    required this.layerId,
    this.blur,
    this.backgroundOpacity,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    return PageLevelBlurContainer(
      layerId: layerId,
      blur: blur,
      backgroundOpacity: backgroundOpacity,
      child: RepaintBoundary(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// 多区域共享模糊容器
/// 
/// 支持在一个页面中创建多个独立的共享模糊区域
class MultiRegionBlurContainer extends StatelessWidget {
  final List<BlurRegion> regions;
  final Widget child;
  
  const MultiRegionBlurContainer({
    super.key,
    required this.regions,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget current = child;
    
    // 从内到外嵌套多个共享模糊层
    for (final region in regions.reversed) {
      current = PageLevelBlurContainer(
        layerId: region.layerId,
        blur: region.blur,
        backgroundOpacity: region.backgroundOpacity,
        child: current,
      );
    }
    
    return current;
  }
}

/// 模糊区域配置
class BlurRegion {
  final String layerId;
  final double? blur;
  final double? backgroundOpacity;
  
  const BlurRegion({
    required this.layerId,
    this.blur,
    this.backgroundOpacity,
  });
}

