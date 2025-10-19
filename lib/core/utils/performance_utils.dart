import 'package:flutter/foundation.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/performance/glassmorphic_performance_monitor.dart';
import 'package:luna_arc_sync/core/rendering/shared_blur_layer_manager.dart';

/// 性能监控工具类
/// 
/// 提供应用性能监控和诊断功能，特别是针对毛玻璃效果的性能优化
class PerformanceUtils {
  PerformanceUtils._();

  /// 获取毛玻璃缓存统计信息
  static Map<String, dynamic> getGlassmorphicCacheStats() {
    final cache = GlassmorphicCache();
    return cache.getCacheStats();
  }

  /// 获取毛玻璃性能统计信息
  static GlassmorphicPerformanceStats getGlassmorphicPerformanceStats() {
    final monitor = GlassmorphicPerformanceMonitor();
    return monitor.getPerformanceStats();
  }

  /// 获取共享模糊层统计信息
  static Map<String, SharedBlurLayerStats> getSharedBlurStats() {
    final collector = SharedBlurPerformanceCollector();
    return collector.getAllStats();
  }

  /// 生成完整的性能报告
  static String generatePerformanceReport() {
    final buffer = StringBuffer();
    buffer.writeln('╔═══════════════════════════════════════════════════════╗');
    buffer.writeln('║         LunaArcSync 毛玻璃性能监控报告               ║');
    buffer.writeln('╚═══════════════════════════════════════════════════════╝');
    buffer.writeln();

    // 缓存统计
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('📦 毛玻璃缓存统计');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final cacheStats = getGlassmorphicCacheStats();
    buffer.writeln('缓存项数量: ${cacheStats['cacheSize']} / ${cacheStats['maxCacheSize']}');
    buffer.writeln('最后清理时间: ${cacheStats['lastCleanup'] ?? 'N/A'}');
    
    if (cacheStats['items'] is List) {
      final items = cacheStats['items'] as List;
      buffer.writeln('\n缓存项详情:');
      for (final item in items) {
        if (item is Map) {
          buffer.writeln('  • ${item['key']}');
          buffer.writeln('    访问次数: ${item['accessCount']}');
          buffer.writeln('    创建时间: ${item['createdAt']}');
          buffer.writeln('    已过期: ${item['isExpired']}');
        }
      }
    }
    buffer.writeln();

    // 性能统计
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('📊 毛玻璃渲染性能统计');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final perfStats = getGlassmorphicPerformanceStats();
    buffer.writeln('总渲染次数: ${perfStats.totalRenders}');
    buffer.writeln('平均渲染时间: ${perfStats.averageRenderTime.toStringAsFixed(2)} ms');
    buffer.writeln('最短渲染时间: ${perfStats.minRenderTime.toStringAsFixed(2)} ms');
    buffer.writeln('最长渲染时间: ${perfStats.maxRenderTime.toStringAsFixed(2)} ms');
    buffer.writeln('共享模糊使用次数: ${perfStats.sharedBlurUsage}');
    buffer.writeln('缓存命中次数: ${perfStats.cacheHits}');
    if (perfStats.totalRenders > 0) {
      final sharedBlurRate = (perfStats.sharedBlurUsage / perfStats.totalRenders * 100);
      final cacheHitRate = (perfStats.cacheHits / perfStats.totalRenders * 100);
      buffer.writeln('共享模糊使用率: ${sharedBlurRate.toStringAsFixed(1)}%');
      buffer.writeln('缓存命中率: ${cacheHitRate.toStringAsFixed(1)}%');
    }
    
    final recommendation = _getPerformanceRecommendation(perfStats);
    if (recommendation.isNotEmpty) {
      buffer.writeln('\n💡 性能建议:');
      buffer.writeln(recommendation);
    }
    buffer.writeln();

    // 共享模糊层统计
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🔗 共享模糊层统计');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final sharedStats = getSharedBlurStats();
    if (sharedStats.isEmpty) {
      buffer.writeln('暂无共享模糊层数据');
    } else {
      for (final entry in sharedStats.entries) {
        final stats = entry.value;
        buffer.writeln('\n图层ID: ${stats.layerId}');
        buffer.writeln('  组件数量: ${stats.componentCount}');
        buffer.writeln('  使用次数: ${stats.usageCount}');
        buffer.writeln('  渲染次数: ${stats.renderCount}');
        buffer.writeln('  平均渲染时间: ${stats.averageRenderTimeMs.toStringAsFixed(2)} ms');
        buffer.writeln('  性能提升估算: ${stats.estimatePerformanceGain().toStringAsFixed(1)}%');
      }
    }
    buffer.writeln();

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('报告生成时间: ${DateTime.now()}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return buffer.toString();
  }

  /// 获取性能建议
  static String _getPerformanceRecommendation(GlassmorphicPerformanceStats stats) {
    final recommendations = <String>[];

    if (stats.averageRenderTime > 16) {
      recommendations.add('  ⚠️ 平均渲染时间超过16ms，可能影响60fps流畅度。建议降低模糊强度。');
    }

    if (stats.totalRenders > 0) {
      final sharedBlurRate = stats.sharedBlurUsage / stats.totalRenders;
      if (sharedBlurRate < 0.5) {
        recommendations.add('  💡 共享模糊使用率较低，建议在列表页面使用 OptimizedGlassmorphicListBuilder。');
      }

      final cacheHitRate = stats.cacheHits / stats.totalRenders;
      if (cacheHitRate < 0.7) {
        recommendations.add('  💡 缓存命中率较低，考虑预热常用的毛玻璃配置。');
      }
    }

    if (stats.maxRenderTime > 50) {
      recommendations.add('  ⚠️ 存在渲染时间过长的组件，建议优化。');
    }

    if (recommendations.isEmpty) {
      return '  ✅ 性能表现良好，无需优化。';
    }

    return recommendations.join('\n');
  }

  /// 打印性能报告到控制台（仅在调试模式）
  static void printPerformanceReport() {
    if (kDebugMode) {
      debugPrint(generatePerformanceReport());
    }
  }

  /// 清理所有性能数据
  static void clearAllPerformanceData() {
    GlassmorphicCache().clearCache();
    // Note: GlassmorphicPerformanceMonitor 没有 clearPerformanceData 方法
    // 数据会自动清理
    SharedBlurPerformanceCollector().clearStats();
    
    if (kDebugMode) {
      debugPrint('🧹 所有性能数据已清理');
    }
  }

  /// 预热毛玻璃缓存
  static void warmupGlassmorphicCache() {
    GlassmorphicCache().warmupCache();
    
    if (kDebugMode) {
      debugPrint('🔥 毛玻璃缓存预热完成');
    }
  }

  /// 获取性能健康度评分 (0-100)
  static int getPerformanceHealthScore() {
    final stats = getGlassmorphicPerformanceStats();
    int score = 100;

    // 渲染时间评分
    if (stats.averageRenderTime > 20) {
      score -= 30;
    } else if (stats.averageRenderTime > 16) {
      score -= 15;
    } else if (stats.averageRenderTime > 12) {
      score -= 5;
    }

    if (stats.totalRenders > 0) {
      // 共享模糊使用率评分
      final sharedBlurRate = stats.sharedBlurUsage / stats.totalRenders;
      if (sharedBlurRate < 0.3) {
        score -= 20;
      } else if (sharedBlurRate < 0.5) {
        score -= 10;
      }

      // 缓存命中率评分
      final cacheHitRate = stats.cacheHits / stats.totalRenders;
      if (cacheHitRate < 0.5) {
        score -= 20;
      } else if (cacheHitRate < 0.7) {
        score -= 10;
      }
    }

    return score.clamp(0, 100);
  }

  /// 获取性能健康度等级
  static String getPerformanceHealthGrade() {
    final score = getPerformanceHealthScore();
    
    if (score >= 90) return 'A+ 优秀';
    if (score >= 80) return 'A 良好';
    if (score >= 70) return 'B 一般';
    if (score >= 60) return 'C 需要优化';
    return 'D 急需优化';
  }

  /// 获取简短的性能摘要
  static String getPerformanceSummary() {
    final stats = getGlassmorphicPerformanceStats();
    final cacheStats = getGlassmorphicCacheStats();
    final healthGrade = getPerformanceHealthGrade();

    String sharedBlurText = 'N/A';
    if (stats.totalRenders > 0) {
      final sharedBlurRate = (stats.sharedBlurUsage / stats.totalRenders * 100);
      sharedBlurText = '${sharedBlurRate.toStringAsFixed(0)}%';
    }

    return '''
性能评级: $healthGrade
渲染次数: ${stats.totalRenders}
平均耗时: ${stats.averageRenderTime.toStringAsFixed(2)}ms
缓存项数: ${cacheStats['cacheSize']}/${cacheStats['maxCacheSize']}
共享模糊: $sharedBlurText
''';
  }
}

