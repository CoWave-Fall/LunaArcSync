import 'package:flutter/material.dart';

/// 文本缓存管理器
/// 用于缓存已渲染的文本组件，提高OCR叠加层的性能
class TextCache {
  static final Map<String, Widget> _textWidgetCache = {};
  static final Map<String, TextPainter> _textPainterCache = {};
  
  /// 缓存键生成器
  static String _generateCacheKey({
    required String text,
    required double fontSize,
    required double width,
    required double height,
    String? searchQuery,
  }) {
    return '${text}_${fontSize}_${width}_${height}_${searchQuery ?? ''}';
  }

  /// 获取缓存的文本组件
  static Widget? getCachedTextWidget({
    required String text,
    required double fontSize,
    required double width,
    required double height,
    String? searchQuery,
  }) {
    final key = _generateCacheKey(
      text: text,
      fontSize: fontSize,
      width: width,
      height: height,
      searchQuery: searchQuery,
    );
    return _textWidgetCache[key];
  }

  /// 缓存文本组件
  static void cacheTextWidget({
    required String text,
    required double fontSize,
    required double width,
    required double height,
    String? searchQuery,
    required Widget widget,
  }) {
    final key = _generateCacheKey(
      text: text,
      fontSize: fontSize,
      width: width,
      height: height,
      searchQuery: searchQuery,
    );
    _textWidgetCache[key] = widget;
  }

  /// 获取缓存的TextPainter
  static TextPainter? getCachedTextPainter({
    required String text,
    required double fontSize,
    required double width,
    String? searchQuery,
  }) {
    final key = _generateCacheKey(
      text: text,
      fontSize: fontSize,
      width: width,
      height: 0, // TextPainter不需要height
      searchQuery: searchQuery,
    );
    return _textPainterCache[key];
  }

  /// 缓存TextPainter
  static void cacheTextPainter({
    required String text,
    required double fontSize,
    required double width,
    String? searchQuery,
    required TextPainter painter,
  }) {
    final key = _generateCacheKey(
      text: text,
      fontSize: fontSize,
      width: width,
      height: 0,
      searchQuery: searchQuery,
    );
    _textPainterCache[key] = painter;
  }

  /// 清理缓存
  static void clearCache() {
    _textWidgetCache.clear();
    _textPainterCache.clear();
  }

  /// 清理特定OCR结果的缓存
  static void clearOcrCache(String pageId) {
    final keysToRemove = _textWidgetCache.keys
        .where((key) => key.contains(pageId))
        .toList();
    
    for (final key in keysToRemove) {
      _textWidgetCache.remove(key);
    }
    
    final painterKeysToRemove = _textPainterCache.keys
        .where((key) => key.contains(pageId))
        .toList();
    
    for (final key in painterKeysToRemove) {
      _textPainterCache.remove(key);
    }
  }

  /// 获取缓存统计信息
  static Map<String, int> getCacheStats() {
    return {
      'textWidgets': _textWidgetCache.length,
      'textPainters': _textPainterCache.length,
    };
  }
}
