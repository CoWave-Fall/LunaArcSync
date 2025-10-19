import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/effects/kawase_blur.dart';

/// 共享模糊层配置
class SharedBlurConfig {
  final double blur;
  final BlurMethod blurMethod;
  final KawaseBlurConfig? kawaseConfig;
  final String layerId;
  
  const SharedBlurConfig({
    required this.blur,
    this.blurMethod = BlurMethod.gaussian,
    this.kawaseConfig,
    required this.layerId,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SharedBlurConfig &&
        other.blur == blur &&
        other.blurMethod == blurMethod &&
        other.kawaseConfig == kawaseConfig &&
        other.layerId == layerId;
  }
  
  @override
  int get hashCode => Object.hash(blur, blurMethod, kawaseConfig, layerId);
}

/// 共享模糊层管理器
/// 
/// 通过 InheritedWidget 在 Widget 树中传递共享模糊层信息，
/// 避免子组件重复创建 BackdropFilter，从而提升性能。
class SharedBlurLayerManager extends InheritedWidget {
  /// 当前激活的共享模糊配置
  final SharedBlurConfig? config;
  
  /// 是否启用共享模糊层
  final bool enabled;
  
  const SharedBlurLayerManager({
    super.key,
    required super.child,
    this.config,
    this.enabled = true,
  });
  
  /// 从上下文获取共享模糊层管理器
  static SharedBlurLayerManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SharedBlurLayerManager>();
  }
  
  /// 检查当前上下文是否在共享模糊层中
  static bool isInSharedBlurLayer(BuildContext context, String? blurGroup) {
    final manager = of(context);
    if (manager == null || !manager.enabled || manager.config == null) {
      return false;
    }
    
    // 如果 blurGroup 与当前共享层的 layerId 匹配，则在共享层中
    return blurGroup != null && manager.config!.layerId == blurGroup;
  }
  
  /// 获取共享模糊配置
  static SharedBlurConfig? getConfig(BuildContext context) {
    final manager = of(context);
    return manager?.config;
  }
  
  @override
  bool updateShouldNotify(SharedBlurLayerManager oldWidget) {
    return config != oldWidget.config || enabled != oldWidget.enabled;
  }
}

/// 共享模糊层提供者
/// 
/// 在页面或区域的顶层使用此组件，为其所有子组件提供统一的模糊背景。
/// 子组件将自动检测并使用共享模糊层，无需创建独立的 BackdropFilter。
/// 
/// ### 使用示例
/// ```dart
/// SharedBlurLayerProvider(
///   blur: 10.0,
///   layerId: 'document_list',
///   child: ListView.builder(
///     itemBuilder: (context, index) {
///       return OptimizedGlassmorphicContainer(
///         blurGroup: 'document_list', // 匹配 layerId
///         child: ListTile(...),
///       );
///     },
///   ),
/// )
/// ```
class SharedBlurLayerProvider extends StatelessWidget {
  final Widget child;
  final double blur;
  final BlurMethod blurMethod;
  final KawaseBlurConfig? kawaseConfig;
  final String layerId;
  final Color? backgroundColor;
  final double backgroundOpacity;
  
  const SharedBlurLayerProvider({
    super.key,
    required this.child,
    required this.layerId,
    this.blur = 10.0,
    this.blurMethod = BlurMethod.gaussian,
    this.kawaseConfig,
    this.backgroundColor,
    this.backgroundOpacity = 0.05,
  });
  
  @override
  Widget build(BuildContext context) {
    final config = SharedBlurConfig(
      blur: blur,
      blurMethod: blurMethod,
      kawaseConfig: kawaseConfig,
      layerId: layerId,
    );
    
    // 使用缓存的模糊过滤器
    final filter = GlassmorphicCache().getOrCreateFilter(
      blurX: blur,
      blurY: blur,
      blurMethod: blurMethod,
      kawaseConfig: kawaseConfig,
    );
    
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    
    return SharedBlurLayerManager(
      config: config,
      enabled: true,
      child: RepaintBoundary(
        child: ClipRect(
          child: BackdropFilter(
            filter: filter,
            child: Container(
              color: bgColor.withOpacity(backgroundOpacity),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 轻量级共享模糊层提供者
/// 
/// 不创建 BackdropFilter，仅提供共享层标识。
/// 适用于已经有外部模糊效果的场景。
class LightweightSharedBlurLayerProvider extends StatelessWidget {
  final Widget child;
  final String layerId;
  final double blur;
  final BlurMethod blurMethod;
  final KawaseBlurConfig? kawaseConfig;
  
  const LightweightSharedBlurLayerProvider({
    super.key,
    required this.child,
    required this.layerId,
    this.blur = 10.0,
    this.blurMethod = BlurMethod.gaussian,
    this.kawaseConfig,
  });
  
  @override
  Widget build(BuildContext context) {
    final config = SharedBlurConfig(
      blur: blur,
      blurMethod: blurMethod,
      kawaseConfig: kawaseConfig,
      layerId: layerId,
    );
    
    return SharedBlurLayerManager(
      config: config,
      enabled: true,
      child: child,
    );
  }
}

/// 共享模糊层混入
/// 
/// 为 StatefulWidget 提供共享模糊层相关的辅助方法
mixin SharedBlurLayerMixin<T extends StatefulWidget> on State<T> {
  /// 检查是否在共享模糊层中
  bool isInSharedBlurLayer(String? blurGroup) {
    return SharedBlurLayerManager.isInSharedBlurLayer(context, blurGroup);
  }
  
  /// 获取共享模糊配置
  SharedBlurConfig? getSharedBlurConfig() {
    return SharedBlurLayerManager.getConfig(context);
  }
  
  /// 应该使用共享模糊
  bool shouldUseSharedBlur(bool useSharedBlur, String? blurGroup) {
    return useSharedBlur && isInSharedBlurLayer(blurGroup);
  }
}

/// 性能统计收集器
class SharedBlurPerformanceCollector {
  static final SharedBlurPerformanceCollector _instance = 
      SharedBlurPerformanceCollector._internal();
  
  factory SharedBlurPerformanceCollector() => _instance;
  
  SharedBlurPerformanceCollector._internal();
  
  final Map<String, SharedBlurLayerStats> _stats = {};
  
  /// 记录共享层使用情况
  void recordLayerUsage(String layerId, int componentCount) {
    final stats = _stats.putIfAbsent(
      layerId, 
      () => SharedBlurLayerStats(layerId: layerId),
    );
    stats.componentCount = componentCount;
    stats.usageCount++;
    stats.lastUsedAt = DateTime.now();
  }
  
  /// 记录渲染性能
  void recordRenderPerformance(String layerId, int renderTimeMs) {
    final stats = _stats[layerId];
    if (stats != null) {
      stats.totalRenderTimeMs += renderTimeMs;
      stats.renderCount++;
    }
  }
  
  /// 获取统计信息
  SharedBlurLayerStats? getStats(String layerId) => _stats[layerId];
  
  /// 获取所有统计信息
  Map<String, SharedBlurLayerStats> getAllStats() => Map.unmodifiable(_stats);
  
  /// 清除统计信息
  void clearStats() => _stats.clear();
  
  /// 生成性能报告
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('=== 共享模糊层性能报告 ===\n');
    
    if (_stats.isEmpty) {
      buffer.writeln('暂无数据');
      return buffer.toString();
    }
    
    for (final entry in _stats.entries) {
      final stats = entry.value;
      final avgRenderTime = stats.renderCount > 0
          ? stats.totalRenderTimeMs / stats.renderCount
          : 0.0;
      
      buffer.writeln('图层ID: ${stats.layerId}');
      buffer.writeln('  - 组件数量: ${stats.componentCount}');
      buffer.writeln('  - 使用次数: ${stats.usageCount}');
      buffer.writeln('  - 渲染次数: ${stats.renderCount}');
      buffer.writeln('  - 平均渲染时间: ${avgRenderTime.toStringAsFixed(2)} ms');
      buffer.writeln('  - 总渲染时间: ${stats.totalRenderTimeMs} ms');
      buffer.writeln('  - 最后使用: ${stats.lastUsedAt}');
      buffer.writeln();
    }
    
    return buffer.toString();
  }
}

/// 共享模糊层统计信息
class SharedBlurLayerStats {
  final String layerId;
  int componentCount = 0;
  int usageCount = 0;
  int renderCount = 0;
  int totalRenderTimeMs = 0;
  DateTime? lastUsedAt;
  
  SharedBlurLayerStats({required this.layerId});
  
  double get averageRenderTimeMs {
    return renderCount > 0 ? totalRenderTimeMs / renderCount : 0.0;
  }
  
  /// 估算性能提升
  /// 
  /// 返回使用共享渲染相比独立渲染节省的时间百分比
  double estimatePerformanceGain() {
    if (componentCount <= 1) return 0.0;
    
    // 假设每个独立 BackdropFilter 的开销是共享层的 1 倍
    // 共享渲染只需要 1 个 BackdropFilter，独立渲染需要 N 个
    final independentCost = componentCount;
    const sharedCost = 1;
    
    return ((independentCost - sharedCost) / independentCost) * 100;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'layerId': layerId,
      'componentCount': componentCount,
      'usageCount': usageCount,
      'renderCount': renderCount,
      'totalRenderTimeMs': totalRenderTimeMs,
      'averageRenderTimeMs': averageRenderTimeMs,
      'lastUsedAt': lastUsedAt?.millisecondsSinceEpoch,
      'estimatedPerformanceGain': '${estimatePerformanceGain().toStringAsFixed(1)}%',
    };
  }
}

