import 'package:flutter/foundation.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';

/// 统一的缓存管理器
/// 管理应用中所有类型的缓存
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  bool _initialized = false;

  /// 初始化所有缓存服务
  Future<void> init() async {
    if (_initialized) return;

    try {
      await PdfCacheService.init();
      
      if (kDebugMode) {
        print('📦 缓存管理器已初始化');
      }
      
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 缓存管理器初始化失败: $e');
      }
    }
  }

  /// 获取所有缓存的统计信息
  Future<Map<String, dynamic>> getAllCacheStats() async {
    await init();

    final pdfStats = await PdfCacheService.getCacheStats();
    
    return {
      'pdf': pdfStats,
    };
  }

  /// 清空所有缓存
  Future<void> clearAllCaches() async {
    await init();

    try {
      await PdfCacheService.clearAllCache();
      
      if (kDebugMode) {
        print('🧹 已清空所有缓存');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 清空缓存失败: $e');
      }
    }
  }

  /// 清空PDF缓存
  Future<void> clearPdfCache() async {
    await init();
    await PdfCacheService.clearAllCache();
  }

  /// 清空特定页面的缓存
  Future<void> clearPageCache(String pageId) async {
    await init();
    await PdfCacheService.clearPageCache(pageId);
  }

  /// 获取缓存大小（字节）
  Future<int> getTotalCacheSize() async {
    await init();

    final pdfStats = await PdfCacheService.getCacheStats();
    return pdfStats['totalSizeBytes'] as int;
  }

  /// 获取缓存大小（可读格式）
  Future<String> getTotalCacheSizeFormatted() async {
    final sizeBytes = await getTotalCacheSize();
    
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}

