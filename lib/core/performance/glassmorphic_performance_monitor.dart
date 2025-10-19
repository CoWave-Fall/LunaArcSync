import 'dart:async';
import 'package:flutter/foundation.dart';

/// 毛玻璃性能监控数据
class GlassmorphicPerformanceData {
  final DateTime timestamp;
  final String componentType;
  final String blurGroup;
  final double blurIntensity;
  final double opacity;
  final int renderTimeMs;
  final bool usedSharedBlur;
  final bool usedCache;

  GlassmorphicPerformanceData({
    required this.timestamp,
    required this.componentType,
    required this.blurGroup,
    required this.blurIntensity,
    required this.opacity,
    required this.renderTimeMs,
    required this.usedSharedBlur,
    required this.usedCache,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'componentType': componentType,
      'blurGroup': blurGroup,
      'blurIntensity': blurIntensity,
      'opacity': opacity,
      'renderTimeMs': renderTimeMs,
      'usedSharedBlur': usedSharedBlur,
      'usedCache': usedCache,
    };
  }
}

/// 毛玻璃性能统计
class GlassmorphicPerformanceStats {
  final int totalRenders;
  final double averageRenderTime;
  final double maxRenderTime;
  final double minRenderTime;
  final Map<String, int> componentTypeCounts;
  final Map<String, int> blurGroupCounts;
  final int sharedBlurUsage;
  final int cacheHits;
  final double performanceScore;

  GlassmorphicPerformanceStats({
    required this.totalRenders,
    required this.averageRenderTime,
    required this.maxRenderTime,
    required this.minRenderTime,
    required this.componentTypeCounts,
    required this.blurGroupCounts,
    required this.sharedBlurUsage,
    required this.cacheHits,
    required this.performanceScore,
  });

  /// 获取性能等级
  String getPerformanceGrade() {
    if (performanceScore >= 90) return '优秀';
    if (performanceScore >= 80) return '良好';
    if (performanceScore >= 70) return '一般';
    if (performanceScore >= 60) return '较差';
    return '很差';
  }

  /// 获取性能建议
  List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    
    if (averageRenderTime > 16) {
      recommendations.add('平均渲染时间过长，建议降低模糊强度');
    }
    
    if (sharedBlurUsage / totalRenders < 0.5) {
      recommendations.add('共享模糊使用率较低，建议启用更多共享模糊');
    }
    
    if (cacheHits / totalRenders < 0.7) {
      recommendations.add('缓存命中率较低，建议预热缓存');
    }
    
    if (maxRenderTime > 50) {
      recommendations.add('存在渲染时间过长的组件，建议优化');
    }
    
    return recommendations;
  }
}

/// 毛玻璃性能监控器
class GlassmorphicPerformanceMonitor {
  static final GlassmorphicPerformanceMonitor _instance = GlassmorphicPerformanceMonitor._internal();
  factory GlassmorphicPerformanceMonitor() => _instance;
  GlassmorphicPerformanceMonitor._internal();

  final List<GlassmorphicPerformanceData> _performanceData = [];
  final StreamController<GlassmorphicPerformanceData> _dataController = StreamController.broadcast();
  
  static const int _maxDataPoints = 1000; // 最大数据点数量
  static const Duration _cleanupInterval = Duration(minutes: 5);

  DateTime? _lastCleanup;

  /// 性能数据流
  Stream<GlassmorphicPerformanceData> get performanceDataStream => _dataController.stream;

  /// 记录性能数据
  void recordPerformance(GlassmorphicPerformanceData data) {
    _performanceData.add(data);
    _dataController.add(data);

    // 定期清理旧数据
    _cleanupIfNeeded();

    if (kDebugMode) {
      debugPrint('📊 毛玻璃性能记录: ${data.componentType} - ${data.renderTimeMs}ms');
    }
  }

  /// 记录渲染时间
  void recordRenderTime({
    required String componentType,
    required String blurGroup,
    required double blurIntensity,
    required double opacity,
    required int renderTimeMs,
    required bool usedSharedBlur,
    required bool usedCache,
  }) {
    final data = GlassmorphicPerformanceData(
      timestamp: DateTime.now(),
      componentType: componentType,
      blurGroup: blurGroup,
      blurIntensity: blurIntensity,
      opacity: opacity,
      renderTimeMs: renderTimeMs,
      usedSharedBlur: usedSharedBlur,
      usedCache: usedCache,
    );

    recordPerformance(data);
  }

  /// 获取性能统计
  GlassmorphicPerformanceStats getPerformanceStats() {
    if (_performanceData.isEmpty) {
      return GlassmorphicPerformanceStats(
        totalRenders: 0,
        averageRenderTime: 0,
        maxRenderTime: 0,
        minRenderTime: 0,
        componentTypeCounts: {},
        blurGroupCounts: {},
        sharedBlurUsage: 0,
        cacheHits: 0,
        performanceScore: 0,
      );
    }

    final renderTimes = _performanceData.map((d) => d.renderTimeMs.toDouble()).toList();
    final averageRenderTime = renderTimes.reduce((a, b) => a + b) / renderTimes.length;
    final maxRenderTime = renderTimes.reduce((a, b) => a > b ? a : b);
    final minRenderTime = renderTimes.reduce((a, b) => a < b ? a : b);

    // 统计组件类型
    final componentTypeCounts = <String, int>{};
    for (final data in _performanceData) {
      componentTypeCounts[data.componentType] = (componentTypeCounts[data.componentType] ?? 0) + 1;
    }

    // 统计模糊组
    final blurGroupCounts = <String, int>{};
    for (final data in _performanceData) {
      blurGroupCounts[data.blurGroup] = (blurGroupCounts[data.blurGroup] ?? 0) + 1;
    }

    // 统计共享模糊使用
    final sharedBlurUsage = _performanceData.where((d) => d.usedSharedBlur).length;

    // 统计缓存命中
    final cacheHits = _performanceData.where((d) => d.usedCache).length;

    // 计算性能分数 (0-100)
    double performanceScore = 100;
    
    // 渲染时间评分 (40%) - 16ms是60fps的目标
    if (averageRenderTime > 16) {
      final timePenalty = (averageRenderTime - 16) * 1.5;
      performanceScore -= timePenalty.clamp(0, 40);
    }
    
    // 共享模糊使用率评分 (30%)
    final sharedBlurRatio = _performanceData.isNotEmpty ? sharedBlurUsage / _performanceData.length : 0;
    performanceScore -= (1 - sharedBlurRatio) * 30.0;
    
    // 缓存命中率评分 (30%)
    final cacheHitRatio = _performanceData.isNotEmpty ? cacheHits / _performanceData.length : 0;
    performanceScore -= (1 - cacheHitRatio) * 30.0;
    
    performanceScore = performanceScore.clamp(0, 100);

    return GlassmorphicPerformanceStats(
      totalRenders: _performanceData.length,
      averageRenderTime: averageRenderTime,
      maxRenderTime: maxRenderTime,
      minRenderTime: minRenderTime,
      componentTypeCounts: componentTypeCounts,
      blurGroupCounts: blurGroupCounts,
      sharedBlurUsage: sharedBlurUsage,
      cacheHits: cacheHits,
      performanceScore: performanceScore,
    );
  }

  /// 清理旧数据
  void _cleanupIfNeeded() {
    final now = DateTime.now();
    if (_lastCleanup != null && 
        now.difference(_lastCleanup!) < _cleanupInterval) {
      return;
    }

    _lastCleanup = now;

    // 移除超过最大数量的旧数据
    if (_performanceData.length > _maxDataPoints) {
      final toRemove = _performanceData.length - _maxDataPoints;
      _performanceData.removeRange(0, toRemove);
    }

    // 移除超过1小时的旧数据
    final oneHourAgo = now.subtract(const Duration(hours: 1));
    _performanceData.removeWhere((data) => data.timestamp.isBefore(oneHourAgo));
  }

  /// 清理所有数据
  void clearAllData() {
    _performanceData.clear();
    _lastCleanup = DateTime.now();
  }

  /// 添加测试数据（用于调试）
  void addTestData() {
    final testData = [
      GlassmorphicPerformanceData(
        timestamp: DateTime.now().subtract(const Duration(seconds: 10)),
        componentType: 'OptimizedGlassmorphicContainer',
        blurGroup: 'document_list',
        blurIntensity: 8.0,
        opacity: 0.15,
        renderTimeMs: 12,
        usedSharedBlur: true,
        usedCache: true,
      ),
      GlassmorphicPerformanceData(
        timestamp: DateTime.now().subtract(const Duration(seconds: 8)),
        componentType: 'OptimizedGlassmorphicCard',
        blurGroup: 'document_list',
        blurIntensity: 8.0,
        opacity: 0.15,
        renderTimeMs: 15,
        usedSharedBlur: true,
        usedCache: true,
      ),
      GlassmorphicPerformanceData(
        timestamp: DateTime.now().subtract(const Duration(seconds: 5)),
        componentType: 'OptimizedGlassmorphicContainer',
        blurGroup: 'settings',
        blurIntensity: 10.0,
        opacity: 0.2,
        renderTimeMs: 18,
        usedSharedBlur: false,
        usedCache: true,
      ),
    ];
    
    for (final data in testData) {
      _performanceData.add(data);
    }
  }

  /// 获取最近的数据
  List<GlassmorphicPerformanceData> getRecentData({int count = 50}) {
    final sortedData = List<GlassmorphicPerformanceData>.from(_performanceData)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return sortedData.take(count).toList();
  }

  /// 获取指定时间范围内的数据
  List<GlassmorphicPerformanceData> getDataInRange({
    required DateTime start,
    required DateTime end,
  }) {
    return _performanceData.where((data) => 
      data.timestamp.isAfter(start) && data.timestamp.isBefore(end)
    ).toList();
  }

  /// 释放资源
  void dispose() {
    _dataController.close();
  }
}

/// 性能监控混入
mixin GlassmorphicPerformanceMixin {
  final GlassmorphicPerformanceMonitor _monitor = GlassmorphicPerformanceMonitor();

  /// 记录组件渲染时间
  void recordComponentRender({
    required String componentType,
    required String blurGroup,
    required double blurIntensity,
    required double opacity,
    required int renderTimeMs,
    required bool usedSharedBlur,
    required bool usedCache,
  }) {
    _monitor.recordRenderTime(
      componentType: componentType,
      blurGroup: blurGroup,
      blurIntensity: blurIntensity,
      opacity: opacity,
      renderTimeMs: renderTimeMs,
      usedSharedBlur: usedSharedBlur,
      usedCache: usedCache,
    );
  }

  /// 获取性能统计
  GlassmorphicPerformanceStats getPerformanceStats() {
    return _monitor.getPerformanceStats();
  }
}
