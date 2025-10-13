import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 图片缓存条目元数据
class ImageCacheEntry {
  final String url;
  final DateTime timestamp;
  final int fileSize;
  final String filePath;

  ImageCacheEntry({
    required this.url,
    required this.timestamp,
    required this.fileSize,
    required this.filePath,
  });

  Map<String, dynamic> toJson() => {
        'url': url,
        'timestamp': timestamp.toIso8601String(),
        'fileSize': fileSize,
        'filePath': filePath,
      };

  factory ImageCacheEntry.fromJson(Map<String, dynamic> json) => ImageCacheEntry(
        url: json['url'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        fileSize: json['fileSize'] as int,
        filePath: json['filePath'] as String,
      );
}

/// 增强的图片缓存服务
/// 特性：
/// - 基于文件系统的持久化缓存
/// - LRU缓存策略
/// - 自动清理过期缓存
/// - 支持预加载
class ImageCacheServiceEnhanced {
  static const String _cacheDirName = 'image_render_cache';
  static const String _metadataKey = 'image_cache_metadata';
  static const Duration _cacheExpiry = Duration(days: 7); // 7天过期
  static const int _maxCacheSize = 200; // 最多缓存200张图片
  static const int _maxCacheSizeBytes = 300 * 1024 * 1024; // 300MB最大缓存

  static Directory? _cacheDir;
  static final Map<String, ImageCacheEntry> _metadata = {};
  static bool _initialized = false;

  /// 初始化缓存服务
  static Future<void> init() async {
    if (_initialized) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDir = Directory('${appDir.path}/$_cacheDirName');
      
      if (!await _cacheDir!.exists()) {
        await _cacheDir!.create(recursive: true);
      }

      // 加载元数据
      await _loadMetadata();
      
      // 清理过期缓存
      await _cleanExpiredCache();
      
      _initialized = true;
      
      if (kDebugMode) {
        print('📦 图片缓存服务已初始化: ${_metadata.length} 个缓存条目');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 图片缓存服务初始化失败: $e');
      }
    }
  }

  /// 生成缓存键
  static String _generateCacheKey(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 获取缓存文件路径
  static String _getCacheFilePath(String cacheKey) {
    return '${_cacheDir!.path}/$cacheKey.img';
  }

  /// 获取缓存的图片
  static Future<Uint8List?> getCachedImage(String url) async {
    await init();

    try {
      final cacheKey = _generateCacheKey(url);
      final entry = _metadata[cacheKey];

      if (entry == null) {
        if (kDebugMode) {
          print('📦 图片缓存未命中: $url');
        }
        return null;
      }

      // 检查是否过期
      final now = DateTime.now();
      if (now.difference(entry.timestamp) > _cacheExpiry) {
        if (kDebugMode) {
          print('📦 图片缓存已过期: $url');
        }
        await _removeCacheEntry(cacheKey);
        return null;
      }

      // 读取缓存文件
      final file = File(entry.filePath);
      if (!await file.exists()) {
        if (kDebugMode) {
          print('📦 图片缓存文件不存在: ${entry.filePath}');
        }
        await _removeCacheEntry(cacheKey);
        return null;
      }

      final bytes = await file.readAsBytes();
      
      // 更新访问时间（LRU）
      _metadata[cacheKey] = ImageCacheEntry(
        url: entry.url,
        timestamp: now,
        fileSize: entry.fileSize,
        filePath: entry.filePath,
      );
      await _saveMetadata();

      if (kDebugMode) {
        print('✅ 图片缓存命中: $url, ${bytes.length} bytes');
      }

      return bytes;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 获取图片缓存失败: $e');
      }
      return null;
    }
  }

  /// 缓存图片
  static Future<void> cacheImage({
    required String url,
    required Uint8List imageBytes,
  }) async {
    await init();

    try {
      final cacheKey = _generateCacheKey(url);
      final filePath = _getCacheFilePath(cacheKey);
      final file = File(filePath);

      // 写入文件
      await file.writeAsBytes(imageBytes);

      // 添加元数据
      _metadata[cacheKey] = ImageCacheEntry(
        url: url,
        timestamp: DateTime.now(),
        fileSize: imageBytes.length,
        filePath: filePath,
      );

      await _saveMetadata();

      // 检查并清理超限缓存
      await _cleanOversizeCache();

      if (kDebugMode) {
        print('💾 图片已缓存: $url, ${imageBytes.length} bytes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 缓存图片失败: $e');
      }
    }
  }

  /// 检查缓存是否存在
  static Future<bool> hasCachedImage(String url) async {
    await init();
    
    final cacheKey = _generateCacheKey(url);
    final entry = _metadata[cacheKey];
    
    if (entry == null) return false;
    
    // 检查是否过期
    final now = DateTime.now();
    if (now.difference(entry.timestamp) > _cacheExpiry) {
      return false;
    }
    
    // 检查文件是否存在
    final file = File(entry.filePath);
    return await file.exists();
  }

  /// 删除特定缓存条目
  static Future<void> _removeCacheEntry(String cacheKey) async {
    try {
      final entry = _metadata[cacheKey];
      if (entry != null) {
        final file = File(entry.filePath);
        if (await file.exists()) {
          await file.delete();
        }
        _metadata.remove(cacheKey);
        await _saveMetadata();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 删除缓存条目失败: $e');
      }
    }
  }

  /// 清理过期缓存
  static Future<void> _cleanExpiredCache() async {
    try {
      final now = DateTime.now();
      final expiredKeys = <String>[];

      for (final entry in _metadata.entries) {
        if (now.difference(entry.value.timestamp) > _cacheExpiry) {
          expiredKeys.add(entry.key);
        }
      }

      for (final key in expiredKeys) {
        await _removeCacheEntry(key);
      }

      if (expiredKeys.isNotEmpty && kDebugMode) {
        print('🧹 清理了 ${expiredKeys.length} 个过期图片缓存');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 清理过期缓存失败: $e');
      }
    }
  }

  /// 清理超限缓存（LRU策略）
  static Future<void> _cleanOversizeCache() async {
    try {
      // 检查数量限制
      if (_metadata.length > _maxCacheSize) {
        // 按时间戳排序，删除最旧的
        final sortedEntries = _metadata.entries.toList()
          ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

        final toRemove = sortedEntries.take(_metadata.length - _maxCacheSize);
        for (final entry in toRemove) {
          await _removeCacheEntry(entry.key);
        }

        if (kDebugMode) {
          print('🧹 清理了 ${toRemove.length} 个旧图片缓存（数量超限）');
        }
      }

      // 检查大小限制
      final totalSize = _metadata.values.fold<int>(
        0,
        (sum, entry) => sum + entry.fileSize,
      );

      if (totalSize > _maxCacheSizeBytes) {
        // 按时间戳排序，删除最旧的直到满足大小限制
        final sortedEntries = _metadata.entries.toList()
          ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

        int currentSize = totalSize;
        int removedCount = 0;

        for (final entry in sortedEntries) {
          if (currentSize <= _maxCacheSizeBytes) break;
          
          currentSize -= entry.value.fileSize;
          await _removeCacheEntry(entry.key);
          removedCount++;
        }

        if (kDebugMode) {
          print('🧹 清理了 $removedCount 个旧图片缓存（大小超限）');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 清理超限缓存失败: $e');
      }
    }
  }

  /// 加载元数据
  static Future<void> _loadMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadataJson = prefs.getString(_metadataKey);

      if (metadataJson != null) {
        final List<dynamic> metadataList = jsonDecode(metadataJson);
        _metadata.clear();

        for (final item in metadataList) {
          final entry = ImageCacheEntry.fromJson(item as Map<String, dynamic>);
          final cacheKey = _generateCacheKey(entry.url);
          _metadata[cacheKey] = entry;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 加载元数据失败: $e');
      }
    }
  }

  /// 保存元数据
  static Future<void> _saveMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadataList = _metadata.values.map((e) => e.toJson()).toList();
      final metadataJson = jsonEncode(metadataList);
      await prefs.setString(_metadataKey, metadataJson);
    } catch (e) {
      if (kDebugMode) {
        print('❌ 保存元数据失败: $e');
      }
    }
  }

  /// 清空所有缓存
  static Future<void> clearAllCache() async {
    await init();

    try {
      // 删除所有缓存文件
      if (_cacheDir != null && await _cacheDir!.exists()) {
        await _cacheDir!.delete(recursive: true);
        await _cacheDir!.create(recursive: true);
      }

      // 清空元数据
      _metadata.clear();
      await _saveMetadata();

      if (kDebugMode) {
        print('🧹 已清空所有图片缓存');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 清空缓存失败: $e');
      }
    }
  }

  /// 获取缓存统计信息
  static Future<Map<String, dynamic>> getCacheStats() async {
    await init();

    final totalSize = _metadata.values.fold<int>(
      0,
      (sum, entry) => sum + entry.fileSize,
    );

    return {
      'totalCount': _metadata.length,
      'totalSizeBytes': totalSize,
      'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      'maxCacheSize': _maxCacheSize,
      'maxCacheSizeMB': (_maxCacheSizeBytes / (1024 * 1024)).toStringAsFixed(0),
    };
  }
}

