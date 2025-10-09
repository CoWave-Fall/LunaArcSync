import 'package:shared_preferences/shared_preferences.dart';

/// PDF渲染后端类型
enum PdfRenderBackend {
  /// PDF.js - 基于WebView的矢量渲染，支持文本选择和搜索
  pdfjs,
  
  /// pdfx - 原生高质量光栅渲染，4倍分辨率，适合打印和高清查看
  pdfx,
  
  /// pdfrx - 现代PDF渲染引擎，支持缩放、平移和高级交互
  pdfrx,
}

/// PDF渲染后端配置服务
class PdfRenderBackendService {
  static const String _prefKey = 'pdf_render_backend';
  
  /// 获取当前选择的PDF渲染后端
  static Future<PdfRenderBackend> getBackend() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backendStr = prefs.getString(_prefKey);
      
      if (backendStr == 'pdfjs') {
        return PdfRenderBackend.pdfjs;
      } else if (backendStr == 'pdfrx') {
        return PdfRenderBackend.pdfrx;
      }
      
      // 默认使用 pdfx (4倍高清)
      return PdfRenderBackend.pdfx;
    } catch (e) {
      return PdfRenderBackend.pdfx;
    }
  }
  
  /// 设置PDF渲染后端
  static Future<void> setBackend(PdfRenderBackend backend) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String backendStr;
      switch (backend) {
        case PdfRenderBackend.pdfx:
          backendStr = 'pdfx';
          break;
        case PdfRenderBackend.pdfrx:
          backendStr = 'pdfrx';
          break;
        case PdfRenderBackend.pdfjs:
          backendStr = 'pdfjs';
          break;
      }
      await prefs.setString(_prefKey, backendStr);
    } catch (e) {
      // 静默失败
    }
  }
  
  /// 获取后端的显示名称
  static String getBackendDisplayName(PdfRenderBackend backend) {
    switch (backend) {
      case PdfRenderBackend.pdfjs:
        return 'PDF.js';
      case PdfRenderBackend.pdfx:
        return 'pdfx';
      case PdfRenderBackend.pdfrx:
        return 'pdfrx';
    }
  }
  
  /// 获取后端的描述
  static String getBackendDescription(PdfRenderBackend backend) {
    switch (backend) {
      case PdfRenderBackend.pdfjs:
        return '基于WebView的矢量渲染，支持文本选择、复制和搜索。适合阅读文本内容。';
      case PdfRenderBackend.pdfx:
        return '原生高质量光栅渲染，4倍分辨率超清显示。适合查看图表、公式和精细内容。需要更多内存。';
      case PdfRenderBackend.pdfrx:
        return '现代PDF渲染引擎，支持流畅的缩放、平移和手势操作。提供最佳的交互体验和性能平衡。';
    }
  }
}

