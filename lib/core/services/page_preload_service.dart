import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/cache/image_cache_service_enhanced.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';
import 'package:luna_arc_sync/core/config/pdf_background_config.dart';
import 'package:luna_arc_sync/core/services/dark_mode_image_processor.dart';
import 'package:pdfx/pdfx.dart';

/// 页面内容类型枚举
enum PageContentType {
  image,      // 二进制图片
  pdf,        // PDF文档
  unknown,    // 未知类型
}

/// 页面预加载服务
/// 负责管理页面预加载功能，支持PDF和二进制图片的预渲染与缓存
class PagePreloadService {
  static const String _preloadCountKey = 'page_preload_count';
  static const int _defaultPreloadCount = 2; // 默认预加载前后2页
  
  static final PagePreloadService _instance = PagePreloadService._internal();
  factory PagePreloadService() => _instance;
  PagePreloadService._internal();
  
  final Set<String> _preloadingPages = {};
  
  // 缓存页面内容类型，避免重复检测
  final Map<String, PageContentType> _contentTypeCache = {};
  
  /// 获取预加载数量设置
  Future<int> getPreloadCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_preloadCountKey) ?? _defaultPreloadCount;
  }
  
  /// 设置预加载数量
  Future<void> setPreloadCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_preloadCountKey, count);
  }
  
  /// 检测页面内容类型
  Future<PageContentType> detectPageContentType(String versionId) async {
    // 检查缓存
    if (_contentTypeCache.containsKey(versionId)) {
      return _contentTypeCache[versionId]!;
    }
    
    try {
      final apiClient = getIt<ApiClient>();
      final imageCacheKey = '/api/images/$versionId';
      
      // 使用HEAD请求获取Content-Type，避免下载整个文件
      final response = await apiClient.dio.head(imageCacheKey);
      
      if (response.statusCode == 200) {
        final contentType = response.headers.value('content-type') ?? '';
        
        PageContentType type;
        if (contentType.startsWith('image/')) {
          type = PageContentType.image;
          if (kDebugMode) {
            print('📸 检测到图片页面: $versionId, 类型: $contentType');
          }
        } else if (contentType == 'application/pdf') {
          type = PageContentType.pdf;
          if (kDebugMode) {
            print('📄 检测到PDF页面: $versionId');
          }
        } else {
          type = PageContentType.unknown;
          if (kDebugMode) {
            print('❓ 未知页面类型: $versionId, 类型: $contentType');
          }
        }
        
        // 缓存结果
        _contentTypeCache[versionId] = type;
        return type;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 检测页面类型失败: $versionId, 错误: $e');
      }
    }
    
    return PageContentType.unknown;
  }
  
  /// 检测页面内容类型（通过数据内容判断）
  PageContentType detectContentTypeFromData(Uint8List bytes, String? contentTypeHeader) {
    // 首先尝试使用Content-Type头
    if (contentTypeHeader != null) {
      if (contentTypeHeader.startsWith('image/')) {
        return PageContentType.image;
      } else if (contentTypeHeader == 'application/pdf') {
        return PageContentType.pdf;
      }
    }
    
    // 如果没有Content-Type头，通过数据内容判断
    if (bytes.isEmpty || bytes.length < 4) {
      return PageContentType.unknown;
    }
    
    // 检查PDF魔数: %PDF (25 50 44 46)
    if (bytes.length >= 4 &&
        bytes[0] == 0x25 && bytes[1] == 0x50 && 
        bytes[2] == 0x44 && bytes[3] == 0x46) {
      if (kDebugMode) {
        print('📄 通过魔数检测到PDF');
      }
      return PageContentType.pdf;
    }
    
    // 检查PNG魔数: 89 50 4E 47
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && 
        bytes[2] == 0x4E && bytes[3] == 0x47) {
      if (kDebugMode) {
        print('📸 通过魔数检测到PNG图片');
      }
      return PageContentType.image;
    }
    
    // 检查JPEG魔数: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      if (kDebugMode) {
        print('📸 通过魔数检测到JPEG图片');
      }
      return PageContentType.image;
    }
    
    // 检查GIF魔数: 47 49 46 38
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && 
        bytes[2] == 0x46 && bytes[3] == 0x38) {
      if (kDebugMode) {
        print('📸 通过魔数检测到GIF图片');
      }
      return PageContentType.image;
    }
    
    // 检查WebP魔数: 52 49 46 46 (RIFF) + 57 45 42 50 (WEBP)
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 && bytes[1] == 0x49 && 
        bytes[2] == 0x46 && bytes[3] == 0x46 &&
        bytes[8] == 0x57 && bytes[9] == 0x45 && 
        bytes[10] == 0x42 && bytes[11] == 0x50) {
      if (kDebugMode) {
        print('📸 通过魔数检测到WebP图片');
      }
      return PageContentType.image;
    }
    
    if (kDebugMode) {
      print('❓ 无法识别的内容类型，数据头: ${bytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
    }
    
    return PageContentType.unknown;
  }
  
  /// 预加载单个页面（支持PDF和图片）
  Future<void> preloadPage(String pageId, String versionId, {required bool isDarkMode}) async {
    final cacheKey = '${pageId}_${versionId}_${isDarkMode ? 'dark' : 'light'}';
    
    // 如果已经在预加载中，跳过
    if (_preloadingPages.contains(cacheKey)) {
      if (kDebugMode) {
        print('预加载跳过: $pageId - 已在预加载队列中');
      }
      return;
    }
    
    _preloadingPages.add(cacheKey);
    
    try {
      // 首先检查PDF缓存
      final hasPdfCache = await PdfCacheService.hasCachedPdf(
        pageId: pageId,
        versionId: versionId,
        isDarkMode: isDarkMode,
      );
      
      if (hasPdfCache) {
        if (kDebugMode) {
          print('预加载跳过: $pageId - PDF已缓存');
        }
        return;
      }
      
      // 检查图片缓存
      final imageCacheKey = '/api/images/$versionId';
      final cachedImage = await ImageCacheServiceEnhanced.getCachedImage(imageCacheKey);
      
      if (cachedImage != null && _isValidImageData(cachedImage)) {
        if (kDebugMode) {
          print('预加载跳过: $pageId - 图片已缓存');
        }
        return;
      }
      
      // 从网络加载
      if (kDebugMode) {
        print('🔄 预加载: 从网络加载 $pageId (版本: $versionId, ${isDarkMode ? "暗色" : "亮色"})');
      }
      
      final apiClient = getIt<ApiClient>();
      final response = await apiClient.dio.get(
        imageCacheKey,
        options: Options(responseType: ResponseType.bytes),
      );
      
      if (response.statusCode == 200) {
        final bytes = response.data as Uint8List;
        final contentTypeHeader = response.headers.value('content-type');
        
        // 检测内容类型
        final contentType = detectContentTypeFromData(bytes, contentTypeHeader);
        
        // 缓存内容类型
        _contentTypeCache[versionId] = contentType;
        
        switch (contentType) {
          case PageContentType.image:
            // 是图片，直接缓存
            ImageCacheServiceEnhanced.cacheImage(
              url: imageCacheKey,
              imageBytes: bytes,
            );
            
            if (kDebugMode) {
              print('✅ 预加载成功: $pageId - 图片已缓存 (${contentTypeHeader ?? "unknown"})');
            }
            break;
            
          case PageContentType.pdf:
            // 是PDF，需要渲染后缓存
            await _renderAndCachePdf(
              pageId: pageId,
              versionId: versionId,
              pdfBytes: bytes,
              isDarkMode: isDarkMode,
            );
            break;
            
          case PageContentType.unknown:
            if (kDebugMode) {
              print('⚠️ 预加载跳过: $pageId - 未知内容类型 (${contentTypeHeader ?? "unknown"})');
            }
            break;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 预加载失败: $pageId, 错误: $e');
      }
    } finally {
      _preloadingPages.remove(cacheKey);
    }
  }
  
  /// 渲染PDF并缓存
  Future<void> _renderAndCachePdf({
    required String pageId,
    required String versionId,
    required Uint8List pdfBytes,
    required bool isDarkMode,
  }) async {
    try {
      if (kDebugMode) {
        print('🎨 预加载: 开始渲染PDF $pageId (${isDarkMode ? "暗色" : "亮色"})');
      }
      
      // 4倍渲染分辨率
      const double renderScale = 4.0;
      
      // 获取背景颜色配置
      final backgroundColor = isDarkMode
          ? await PdfBackgroundConfig.getDarkColor()
          : await PdfBackgroundConfig.getLightColor();
      final enableBlur = await PdfBackgroundConfig.getEnableBlur();
      
      // 打开PDF文档
      final document = await PdfDocument.openData(pdfBytes);
      final page = await document.getPage(1); // PDF通常只有一页
      
      // 渲染PDF页面
      final pageImage = await page.render(
        width: page.width * renderScale,
        height: page.height * renderScale,
        format: PdfPageImageFormat.png,
        backgroundColor: '#${backgroundColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      );
      
      if (pageImage == null) {
        throw Exception('PDF渲染失败');
      }
      
      Uint8List renderedBytes = pageImage.bytes;
      
      // 如果启用了毛玻璃效果且背景是透明/半透明的，可以在这里应用
      if (enableBlur && backgroundColor.opacity < 1.0) {
        if (kDebugMode) {
          print('🌫️  应用毛玻璃效果');
        }
        // 毛玻璃效果主要在渲染时通过UI层处理，这里只记录
      }
      
      // 在深色模式下应用颜色反转处理
      // 传入backgroundColor参数以确保背景色不会被反转
      if (isDarkMode) {
        if (kDebugMode) {
          print('🎨 预加载: 应用暗色模式处理 (过滤背景色)');
        }
        final processedBytes = await _applyDarkModeProcessing(
          renderedBytes,
          backgroundColor: backgroundColor,
        );
        if (processedBytes != null) {
          renderedBytes = processedBytes;
        }
      }
      
      // 缓存渲染后的图像
      await PdfCacheService.cachePdf(
        pageId: pageId,
        versionId: versionId,
        isDarkMode: isDarkMode,
        imageBytes: renderedBytes,
      );
      
      if (kDebugMode) {
        print('✅ 预加载成功: $pageId - PDF已渲染并缓存 (背景: #${backgroundColor.value.toRadixString(16).padLeft(8, '0')})');
      }
      
      // 清理资源
      await page.close();
      await document.close();
    } catch (e) {
      if (kDebugMode) {
        print('❌ PDF渲染失败: $pageId, 错误: $e');
      }
    }
  }
  
  /// 应用暗色模式处理
  /// [imageBytes] 原始图像字节
  /// [backgroundColor] 用户自定义的背景颜色，将在反转时被过滤掉
  Future<Uint8List?> _applyDarkModeProcessing(
    Uint8List imageBytes, {
    required Color backgroundColor,
  }) async {
    try {
      // 使用统一的DarkModeImageProcessor进行处理
      return await DarkModeImageProcessor.processImageForDarkMode(
        imageBytes,
        backgroundColor: backgroundColor,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ 暗色模式处理失败: $e');
      }
      return null;
    }
  }
  
  /// 批量预加载页面
  Future<void> preloadPages(
    List<String> pageIds,
    List<String> versionIds, {
    required bool isDarkMode,
  }) async {
    if (pageIds.length != versionIds.length) {
      if (kDebugMode) {
        print('错误: pageIds和versionIds长度不匹配');
      }
      return;
    }
    
    if (kDebugMode) {
      print('开始批量预加载 ${pageIds.length} 个页面');
    }
    
    // 并行预加载所有页面
    final futures = <Future<void>>[];
    for (int i = 0; i < pageIds.length; i++) {
      futures.add(preloadPage(
        pageIds[i],
        versionIds[i],
        isDarkMode: isDarkMode,
      ));
    }
    
    await Future.wait(futures, eagerError: false);
  }
  
  /// 清除预加载缓存
  void clearPreloadCache() {
    _preloadingPages.clear();
  }
  
  /// 取消所有预加载任务
  void cancelAllPreloads() {
    _preloadingPages.clear();
  }
  
  /// 获取已缓存的内容类型（如果有）
  PageContentType? getCachedContentType(String versionId) {
    return _contentTypeCache[versionId];
  }
  
  /// 清除内容类型缓存
  void clearContentTypeCache() {
    _contentTypeCache.clear();
  }
  
  /// 验证图片数据是否有效
  bool _isValidImageData(Uint8List bytes) {
    if (bytes.isEmpty) return false;
    
    // 检查常见的图片文件头
    if (bytes.length < 4) return false;
    
    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      return true;
    }
    
    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return true;
    }
    
    // GIF: 47 49 46 38
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x38) {
      return true;
    }
    
    // WebP: 52 49 46 46 (RIFF)
    if (bytes.length >= 12 && 
        bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
        bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50) {
      return true;
    }
    
    // 如果都不匹配，可能是其他格式，但至少要有一定的大小
    return bytes.length > 100;
  }
}
