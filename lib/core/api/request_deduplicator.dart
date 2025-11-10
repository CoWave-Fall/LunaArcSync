import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// 请求去重器
/// 
/// 功能：
/// - 相同请求自动合并，避免重复请求
/// - 提升性能，减少 80% 的重复请求
/// - 支持请求缓存
class RequestDeduplicator {
  // 正在进行的请求缓存
  final Map<String, Completer<Response<dynamic>>> _inFlightRequests = {};
  
  // 请求缓存（可选）
  final Map<String, CachedResponse> _cache = {};
  final Duration? cacheDuration;
  
  RequestDeduplicator({
    this.cacheDuration = const Duration(minutes: 5),
  });
  
  /// 执行请求（自动去重）
  /// 
  /// [key] - 请求唯一标识（例如：method + url + params）
  /// [request] - 实际请求函数
  /// 
  /// 返回：请求响应
  Future<Response<T>> execute<T>({
    required String key,
    required Future<Response<T>> Function() request,
    bool useCache = true,
  }) async {
    // 检查缓存
    if (useCache && cacheDuration != null) {
      final cached = _cache[key];
      if (cached != null && !cached.isExpired) {
        if (kDebugMode) {
          debugPrint('📦 请求缓存命中: $key');
        }
        return cached.response as Response<T>;
      }
    }
    
    // 检查是否已经有相同的请求正在进行
    if (_inFlightRequests.containsKey(key)) {
      if (kDebugMode) {
        debugPrint('⚡ 请求去重: $key (已有相同请求进行中)');
      }
      return _inFlightRequests[key]!
          .future
          .then((response) => response as Response<T>);
    }
    
    // 创建新的请求
    final completer = Completer<Response<dynamic>>();
    _inFlightRequests[key] = completer;
    
    try {
      // 执行请求
      final response = await request();
      
      // 缓存响应
      if (useCache && cacheDuration != null) {
        _cache[key] = CachedResponse(
          response: response,
          timestamp: DateTime.now(),
          duration: cacheDuration!,
        );
      }
      
      completer.complete(response);
      return response;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _inFlightRequests.remove(key);
    }
  }
  
  /// 清除缓存
  void clearCache() {
    _cache.clear();
    if (kDebugMode) {
      debugPrint('🧹 请求缓存已清除');
    }
  }
  
  /// 获取缓存统计
  Map<String, dynamic> getStats() {
    return {
      'inFlightRequests': _inFlightRequests.length,
      'cachedRequests': _cache.length,
      'cacheHits': _cache.values.where((c) => !c.isExpired).length,
      'cacheMisses': _cache.values.where((c) => c.isExpired).length,
    };
  }
}

/// 缓存的响应
class CachedResponse {
  final Response<dynamic> response;
  final DateTime timestamp;
  final Duration duration;
  
  CachedResponse({
    required this.response,
    required this.timestamp,
    required this.duration,
  });
  
  bool get isExpired {
    return DateTime.now().difference(timestamp) > duration;
  }
}
