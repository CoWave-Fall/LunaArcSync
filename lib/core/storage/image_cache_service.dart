import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class ImageCacheService {
  static const String _cacheDirName = 'image_cache';
  late Directory _cacheDir;
  final Dio _dio = Dio();

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${appDir.path}/$_cacheDirName');
    if (!await _cacheDir.exists()) {
      await _cacheDir.create(recursive: true);
    }
  }

  String _getCacheKey(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  String _getCachePath(String url) {
    final key = _getCacheKey(url);
    return '${_cacheDir.path}/$key';
  }

  Future<File?> getCachedImage(String url) async {
    try {
      await init();
      final cachePath = _getCachePath(url);
      final file = File(cachePath);
      if (await file.exists()) {
        return file;
      }
    } catch (e) {
      debugPrint('🔍 获取缓存图片失败: $e');
    }
    return null;
  }

  Future<File?> cacheImage(String url) async {
    try {
      await init();
      final cachePath = _getCachePath(url);
      final file = File(cachePath);
      
      // 如果已经存在，直接返回
      if (await file.exists()) {
        return file;
      }

      // 下载图片
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        // 保存到缓存
        await file.writeAsBytes(response.data);
        debugPrint('🔍 图片已缓存: $url');
        return file;
      }
    } catch (e) {
      debugPrint('🔍 缓存图片失败: $e');
    }
    return null;
  }

  Future<void> clearCache() async {
    try {
      await init();
      if (await _cacheDir.exists()) {
        await _cacheDir.delete(recursive: true);
        await _cacheDir.create(recursive: true);
        debugPrint('🔍 图片缓存已清空');
      }
    } catch (e) {
      debugPrint('🔍 清空缓存失败: $e');
    }
  }

  Future<int> getCacheSize() async {
    try {
      await init();
      if (await _cacheDir.exists()) {
        int totalSize = 0;
        await for (final entity in _cacheDir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
        return totalSize;
      }
    } catch (e) {
      debugPrint('🔍 获取缓存大小失败: $e');
    }
    return 0;
  }
}
