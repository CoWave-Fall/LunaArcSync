import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:luna_arc_sync/core/effects/kawase_blur.dart';
import 'package:flutter/material.dart';

/// 模糊方法枚举
enum BlurMethod {
  gaussian,  // 高斯模糊（默认）
  kawase,    // 双Kawase模糊
}

/// 毛玻璃效果缓存项
class GlassmorphicCacheItem {
  final ImageFilter filter;
  final String key;
  final BlurMethod blurMethod;
  final KawaseBlurConfig? kawaseConfig;
  late final DateTime createdAt;
  late int accessCount;

  GlassmorphicCacheItem({
    required this.filter,
    required this.key,
    this.blurMethod = BlurMethod.gaussian,
    this.kawaseConfig,
  }) {
    createdAt = DateTime.now();
    accessCount = 0;
  }

  /// 增加访问次数
  void incrementAccess() {
    accessCount++;
  }

  /// 检查是否过期（超过5分钟）
  bool get isExpired {
    return DateTime.now().difference(createdAt).inMinutes > 5;
  }
}

/// 毛玻璃效果缓存管理器
class GlassmorphicCache {
  static final GlassmorphicCache _instance = GlassmorphicCache._internal();
  factory GlassmorphicCache() => _instance;
  GlassmorphicCache._internal();

  final Map<String, GlassmorphicCacheItem> _cache = {};
  static const int _maxCacheSize = 20; // 最大缓存数量
  static const Duration _cleanupInterval = Duration(minutes: 2);

  DateTime? _lastCleanup;

  /// 生成缓存键
  String _generateKey(double blurX, double blurY, double opacity, Color color) {
    return '${blurX.toStringAsFixed(1)}_${blurY.toStringAsFixed(1)}_${opacity.toStringAsFixed(2)}_${color.value.toRadixString(16)}';
  }

  /// 生成包含模糊方法的缓存键
  String _generateKeyWithMethod(
    double blurX, 
    double blurY, 
    double opacity, 
    Color color, 
    BlurMethod blurMethod,
    KawaseBlurConfig? kawaseConfig,
  ) {
    final baseKey = _generateKey(blurX, blurY, opacity, color);
    final methodKey = blurMethod.name;
    final configKey = kawaseConfig != null 
        ? '${kawaseConfig.radius}_${kawaseConfig.passes}_${kawaseConfig.scaleFactor}'
        : '';
    return '${baseKey}_${methodKey}_$configKey';
  }

  /// 创建过滤器
  ImageFilter _createFilter(
    double blurX, 
    double blurY, 
    BlurMethod blurMethod,
    KawaseBlurConfig? kawaseConfig,
  ) {
    switch (blurMethod) {
      case BlurMethod.gaussian:
        return ImageFilter.blur(sigmaX: blurX, sigmaY: blurY);
      case BlurMethod.kawase:
        // 对于Kawase模糊，我们仍然使用高斯模糊作为基础
        // 实际的Kawase算法需要在渲染层面实现
        final effectiveBlur = kawaseConfig?.radius ?? blurX;
        return ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur);
    }
  }

  /// 获取或创建毛玻璃过滤器
  ImageFilter getOrCreateFilter({
    required double blurX,
    required double blurY,
    double opacity = 0.1,
    Color color = Colors.white,
    BlurMethod blurMethod = BlurMethod.gaussian,
    KawaseBlurConfig? kawaseConfig,
  }) {
    final key = _generateKeyWithMethod(blurX, blurY, opacity, color, blurMethod, kawaseConfig);
    
    // 检查缓存
    if (_cache.containsKey(key)) {
      final item = _cache[key]!;
      if (!item.isExpired) {
        item.incrementAccess();
        return item.filter;
      } else {
        _cache.remove(key);
      }
    }

    // 创建新的过滤器
    final filter = _createFilter(blurX, blurY, blurMethod, kawaseConfig);
    
    // 添加到缓存
    _cache[key] = GlassmorphicCacheItem(
      filter: filter,
      key: key,
      blurMethod: blurMethod,
      kawaseConfig: kawaseConfig,
    );

    // 定期清理缓存
    _cleanupIfNeeded();
    
    return filter;
  }

  /// 预生成常用毛玻璃效果
  void preloadCommonFilters() {
    final commonConfigs = [
      {'blurX': 5.0, 'blurY': 5.0, 'opacity': 0.1},
      {'blurX': 8.0, 'blurY': 8.0, 'opacity': 0.15},
      {'blurX': 10.0, 'blurY': 10.0, 'opacity': 0.2},
      {'blurX': 15.0, 'blurY': 15.0, 'opacity': 0.25},
      {'blurX': 20.0, 'blurY': 20.0, 'opacity': 0.3},
    ];

    for (final config in commonConfigs) {
      getOrCreateFilter(
        blurX: config['blurX']!,
        blurY: config['blurY']!,
        opacity: config['opacity']!,
      );
    }
  }

  /// 清理过期和最少使用的缓存项
  void _cleanupIfNeeded() {
    final now = DateTime.now();
    if (_lastCleanup != null && 
        now.difference(_lastCleanup!) < _cleanupInterval) {
      return;
    }

    _lastCleanup = now;

    // 移除过期项
    _cache.removeWhere((key, item) => item.isExpired);

    // 如果缓存仍然过大，移除最少使用的项
    if (_cache.length > _maxCacheSize) {
      final sortedItems = _cache.entries.toList()
        ..sort((a, b) => a.value.accessCount.compareTo(b.value.accessCount));

      final itemsToRemove = sortedItems.take(_cache.length - _maxCacheSize);
      for (final entry in itemsToRemove) {
        _cache.remove(entry.key);
      }
    }
  }

  /// 手动清理所有缓存
  void clearCache() {
    _cache.clear();
    _lastCleanup = DateTime.now();
  }

  /// 获取缓存统计信息
  Map<String, dynamic> getCacheStats() {
    return {
      'cacheSize': _cache.length,
      'maxCacheSize': _maxCacheSize,
      'lastCleanup': _lastCleanup,
      'items': _cache.entries.map((entry) => {
        'key': entry.key,
        'accessCount': entry.value.accessCount,
        'createdAt': entry.value.createdAt,
        'isExpired': entry.value.isExpired,
      }).toList(),
    };
  }

  /// 预热缓存（在应用启动时调用）
  void warmupCache() {
    if (kDebugMode) {
      debugPrint('🔥 预热毛玻璃效果缓存...');
    }
    
    preloadCommonFilters();
    
    if (kDebugMode) {
      debugPrint('🔥 毛玻璃效果缓存预热完成，缓存项数量: ${_cache.length}');
    }
  }
}

/// 毛玻璃效果缓存混入
mixin GlassmorphicCacheMixin {
  final GlassmorphicCache _cache = GlassmorphicCache();

  /// 获取缓存的毛玻璃过滤器
  ImageFilter getCachedFilter({
    required double blurX,
    required double blurY,
    double opacity = 0.1,
    Color color = Colors.white,
  }) {
    return _cache.getOrCreateFilter(
      blurX: blurX,
      blurY: blurY,
      opacity: opacity,
      color: color,
    );
  }

  /// 预热缓存
  void warmupGlassmorphicCache() {
    _cache.warmupCache();
  }

  /// 清理缓存
  void clearGlassmorphicCache() {
    _cache.clearCache();
  }

  /// 获取缓存统计
  Map<String, dynamic> getGlassmorphicCacheStats() {
    return _cache.getCacheStats();
  }
}
