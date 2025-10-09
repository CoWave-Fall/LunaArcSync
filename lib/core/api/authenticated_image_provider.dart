import 'dart:collection';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';

// A simple in-memory cache for the image bytes with LRU eviction.
class _ImageCache {
  static const int _maxCacheSize = 20; // 限制缓存大小
  static const Duration _cacheExpiry = Duration(hours: 2); // 缓存过期时间
  
  final LinkedHashMap<String, _CacheEntry> _cache = LinkedHashMap<String, _CacheEntry>();
  
  Uint8List? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    
    // 检查是否过期
    if (DateTime.now().difference(entry.timestamp) > _cacheExpiry) {
      _cache.remove(key);
      return null;
    }
    
    // 移动到末尾（LRU）
    _cache.remove(key);
    _cache[key] = entry;
    return entry.data;
  }
  
  void put(String key, Uint8List data) {
    // 如果已存在，先移除
    _cache.remove(key);
    
    // 检查缓存大小，移除最旧的条目
    while (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    
    _cache[key] = _CacheEntry(data, DateTime.now());
  }
  
  void clear() {
    _cache.clear();
  }
  
  int get size => _cache.length;
}

class _CacheEntry {
  final Uint8List data;
  final DateTime timestamp;
  
  _CacheEntry(this.data, this.timestamp);
}

final _ImageCache _inMemoryCache = _ImageCache();

@immutable
class AuthenticatedImageProvider extends ImageProvider<AuthenticatedImageProvider> {
  final String url;
  final ApiClient apiClient;

  const AuthenticatedImageProvider(this.url, this.apiClient);

  @override
  Future<AuthenticatedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AuthenticatedImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    AuthenticatedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () => [
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<AuthenticatedImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    AuthenticatedImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    try {
      Uint8List? bytes;
      // 1. Check in-memory cache
      bytes = _inMemoryCache.get(url);
      
      if (bytes == null) {
        // 2. If not in cache, fetch from network
        final response = await apiClient.dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.statusCode != 200) {
          throw NetworkImageLoadException(
            statusCode: response.statusCode ?? 0,
            uri: Uri.parse(url),
          );
        }
        bytes = response.data as Uint8List;
        // 3. Store in cache
        _inMemoryCache.put(url, bytes);
      }

      if (bytes.isEmpty) {
        throw Exception('AuthenticatedImageProvider: Empty response for $url');
      }

      return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } catch (e) {
      // On error, evict from both Flutter's cache and our in-memory cache.
      PaintingBinding.instance.imageCache.evict(key);
      _inMemoryCache.clear();
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AuthenticatedImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '$runtimeType("$url")';
}
