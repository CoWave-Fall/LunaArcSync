import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';

/// PDF预加载管理器
/// 负责将相邻页面提前加载到内存，避免用户看到加载闪烁
class PdfPreloadManager {
  static final PdfPreloadManager _instance = PdfPreloadManager._internal();
  factory PdfPreloadManager() => _instance;
  PdfPreloadManager._internal();
  
  // 内存缓存：pageId_versionId_theme -> Uint8List
  final Map<String, Uint8List> _memoryCache = {};
  
  // 预加载队列：正在预加载的页面
  final Set<String> _preloadingPages = {};
  
  // 最大内存缓存数量（相邻页面）
  static const int _maxMemoryCache = 6; // 当前页 + 前后各2页 + 1个备用
  
  /// 生成缓存键
  String _generateCacheKey(String pageId, String versionId, bool isDarkMode) {
    return '${pageId}_${versionId}_${isDarkMode ? 'dark' : 'light'}';
  }
  
  /// 从内存缓存获取PDF渲染数据
  Uint8List? getFromMemory({
    required String pageId,
    required String versionId,
    required bool isDarkMode,
  }) {
    final cacheKey = _generateCacheKey(pageId, versionId, isDarkMode);
    final data = _memoryCache[cacheKey];
    
    if (data != null && kDebugMode) {
      print('📦 PDF内存缓存命中: $pageId (${isDarkMode ? "暗色" : "亮色"})');
    }
    
    return data;
  }
  
  /// 将PDF渲染数据放入内存缓存
  void putToMemory({
    required String pageId,
    required String versionId,
    required bool isDarkMode,
    required Uint8List data,
  }) {
    final cacheKey = _generateCacheKey(pageId, versionId, isDarkMode);
    
    // 如果缓存已满，移除最旧的条目（简单的FIFO策略）
    if (_memoryCache.length >= _maxMemoryCache) {
      final firstKey = _memoryCache.keys.first;
      _memoryCache.remove(firstKey);
      if (kDebugMode) {
        print('📦 PDF内存缓存已满，移除最旧条目: $firstKey');
      }
    }
    
    _memoryCache[cacheKey] = data;
    
    if (kDebugMode) {
      print('📦 PDF放入内存缓存: $pageId (${isDarkMode ? "暗色" : "亮色"}), 大小: ${data.length} bytes, 缓存数: ${_memoryCache.length}');
    }
  }
  
  /// 预加载相邻页面到内存
  Future<void> preloadAdjacentPages({
    required List<String> adjacentPageIds,
    required List<String> adjacentVersionIds,
    required bool isDarkMode,
  }) async {
    if (adjacentPageIds.length != adjacentVersionIds.length) {
      if (kDebugMode) {
        print('❌ 预加载失败: pageIds和versionIds长度不匹配');
      }
      return;
    }
    
    if (kDebugMode) {
      print('🔄 开始预加载 ${adjacentPageIds.length} 个相邻页面到内存');
    }
    
    // 并行预加载
    final futures = <Future<void>>[];
    
    for (int i = 0; i < adjacentPageIds.length; i++) {
      final pageId = adjacentPageIds[i];
      final versionId = adjacentVersionIds[i];
      final cacheKey = _generateCacheKey(pageId, versionId, isDarkMode);
      
      // 跳过已在内存中的
      if (_memoryCache.containsKey(cacheKey)) {
        if (kDebugMode) {
          print('⏭️  跳过已在内存的页面: $pageId');
        }
        continue;
      }
      
      // 跳过正在预加载的
      if (_preloadingPages.contains(cacheKey)) {
        if (kDebugMode) {
          print('⏭️  跳过正在预加载的页面: $pageId');
        }
        continue;
      }
      
      futures.add(_preloadSinglePage(pageId, versionId, isDarkMode));
    }
    
    if (futures.isNotEmpty) {
      await Future.wait(futures, eagerError: false);
      if (kDebugMode) {
        print('✅ 预加载完成，内存缓存数: ${_memoryCache.length}');
      }
    }
  }
  
  /// 预加载单个页面
  Future<void> _preloadSinglePage(String pageId, String versionId, bool isDarkMode) async {
    final cacheKey = _generateCacheKey(pageId, versionId, isDarkMode);
    _preloadingPages.add(cacheKey);
    
    try {
      // 从磁盘缓存加载
      final cachedData = await PdfCacheService.getCachedPdf(
        pageId: pageId,
        versionId: versionId,
        isDarkMode: isDarkMode,
      );
      
      if (cachedData != null) {
        putToMemory(
          pageId: pageId,
          versionId: versionId,
          isDarkMode: isDarkMode,
          data: cachedData,
        );
        if (kDebugMode) {
          print('✅ 从磁盘加载到内存: $pageId');
        }
      } else {
        if (kDebugMode) {
          print('⚠️  磁盘缓存未命中，需要重新渲染: $pageId');
        }
        // 磁盘缓存未命中，依赖预加载服务去渲染
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 预加载页面失败: $pageId, 错误: $e');
      }
    } finally {
      _preloadingPages.remove(cacheKey);
    }
  }
  
  /// 清除内存缓存
  void clearMemoryCache() {
    _memoryCache.clear();
    if (kDebugMode) {
      print('🧹 已清除PDF内存缓存');
    }
  }
  
  /// 移除特定页面的内存缓存
  void removeFromMemory({
    required String pageId,
    required String versionId,
    required bool isDarkMode,
  }) {
    final cacheKey = _generateCacheKey(pageId, versionId, isDarkMode);
    _memoryCache.remove(cacheKey);
  }
  
  /// 获取内存缓存统计信息
  Map<String, dynamic> getMemoryCacheStats() {
    int totalBytes = 0;
    for (final data in _memoryCache.values) {
      totalBytes += data.length;
    }
    
    return {
      'count': _memoryCache.length,
      'maxCount': _maxMemoryCache,
      'totalBytes': totalBytes,
      'totalMB': (totalBytes / (1024 * 1024)).toStringAsFixed(2),
    };
  }
}

