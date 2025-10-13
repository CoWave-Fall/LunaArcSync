import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';

/// PDF预加载服务
/// 在后台预加载PDF，减少用户等待时间
class PreloadService {
  static final PreloadService _instance = PreloadService._internal();
  factory PreloadService() => _instance;
  PreloadService._internal();

  final Set<String> _preloadingKeys = {};
  final Set<String> _preloadedKeys = {};

  /// 预加载PDF
  /// [pageId] 页面ID
  /// [versionId] 版本ID
  /// [url] PDF下载URL
  /// [apiClient] API客户端（用于认证）
  /// [isDarkMode] 是否为暗色模式
  /// [priority] 优先级（数字越小优先级越高）
  Future<void> preloadPdf({
    required String pageId,
    required String versionId,
    required String url,
    required ApiClient apiClient,
    required bool isDarkMode,
    int priority = 5,
  }) async {
    final key = _generatePreloadKey(pageId, versionId, isDarkMode);

    // 如果已经预加载或正在预加载，跳过
    if (_preloadedKeys.contains(key) || _preloadingKeys.contains(key)) {
      if (kDebugMode) {
        print('🔄 预加载跳过（已存在）: $pageId');
      }
      return;
    }

    // 检查缓存是否已存在
    if (await PdfCacheService.hasCachedPdf(
      pageId: pageId,
      versionId: versionId,
      isDarkMode: isDarkMode,
    )) {
      _preloadedKeys.add(key);
      if (kDebugMode) {
        print('🔄 预加载跳过（已缓存）: $pageId');
      }
      return;
    }

    // 标记为正在预加载
    _preloadingKeys.add(key);

    try {
      if (kDebugMode) {
        print('🔄 开始预加载: $pageId (优先级: $priority)');
      }

      // 下载PDF
      final response = await apiClient.dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        throw Exception('下载失败: ${response.statusCode}');
      }

      final pdfBytes = response.data as Uint8List;

      // 使用PdfCacheService的预加载功能
      await PdfCacheService.preloadPdf(
        pageId: pageId,
        versionId: versionId,
        isDarkMode: isDarkMode,
        loader: () async => await _renderPdf(pdfBytes, isDarkMode),
      );

      _preloadedKeys.add(key);

      if (kDebugMode) {
        print('✅ 预加载完成: $pageId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 预加载失败: $pageId, $e');
      }
    } finally {
      _preloadingKeys.remove(key);
    }
  }

  /// 批量预加载PDF
  /// 按优先级顺序预加载
  Future<void> preloadBatch(List<PreloadTask> tasks) async {
    // 按优先级排序
    tasks.sort((a, b) => a.priority.compareTo(b.priority));

    // 并发预加载（最多3个同时进行）
    const maxConcurrent = 3;
    final chunks = <List<PreloadTask>>[];
    
    for (var i = 0; i < tasks.length; i += maxConcurrent) {
      chunks.add(
        tasks.sublist(
          i,
          i + maxConcurrent > tasks.length ? tasks.length : i + maxConcurrent,
        ),
      );
    }

    for (final chunk in chunks) {
      await Future.wait(
        chunk.map((task) => preloadPdf(
          pageId: task.pageId,
          versionId: task.versionId,
          url: task.url,
          apiClient: task.apiClient,
          isDarkMode: task.isDarkMode,
          priority: task.priority,
        )),
      );
    }
  }

  /// 渲染PDF为图像
  Future<Uint8List> _renderPdf(Uint8List pdfBytes, bool isDarkMode) async {
    // 这里需要调用实际的PDF渲染逻辑
    // 由于渲染需要在widget上下文中进行，这里返回原始字节
    // 实际渲染会在PdfxRenderer中进行
    return pdfBytes;
  }

  /// 生成预加载键
  String _generatePreloadKey(String pageId, String versionId, bool isDarkMode) {
    return '${pageId}_${versionId}_${isDarkMode ? "dark" : "light"}';
  }

  /// 清空预加载状态
  void clearPreloadStatus() {
    _preloadingKeys.clear();
    _preloadedKeys.clear();
  }

  /// 获取预加载统计
  Map<String, int> getPreloadStats() {
    return {
      'preloading': _preloadingKeys.length,
      'preloaded': _preloadedKeys.length,
    };
  }
}

/// 预加载任务
class PreloadTask {
  final String pageId;
  final String versionId;
  final String url;
  final ApiClient apiClient;
  final bool isDarkMode;
  final int priority;

  PreloadTask({
    required this.pageId,
    required this.versionId,
    required this.url,
    required this.apiClient,
    required this.isDarkMode,
    this.priority = 5,
  });
}

