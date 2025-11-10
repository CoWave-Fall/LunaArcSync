import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:luna_arc_sync/core/config/pdf_render_backend.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/pdfx_renderer.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/pdfrx_renderer.dart';

/// PDF矢量渲染器组件
/// 支持多种渲染后端：PDF.js、pdfx、pdfrx
class PdfVectorRenderer extends StatefulWidget {
  final Uint8List bytes;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey;
  final void Function(Size)? onImageRendered;

  const PdfVectorRenderer({
    required this.bytes,
    required this.pageId,
    required this.versionId,
    required this.imageKey,
    this.onImageRendered,
    super.key,
  });

  @override
  State<PdfVectorRenderer> createState() => _PdfVectorRendererState();
}

class _PdfVectorRendererState extends State<PdfVectorRenderer> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _errorMessage;
  PdfRenderBackend? _currentBackend;

  @override
  void initState() {
    super.initState();
    _loadBackendConfig();
  }

  Future<void> _loadBackendConfig() async {
    final backend = await PdfRenderBackendService.getBackend();
    if (mounted) {
      setState(() {
        _currentBackend = backend;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果还没加载配置，显示加载中
    if (_currentBackend == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 根据配置选择渲染器
    switch (_currentBackend!) {
      case PdfRenderBackend.pdfx:
        return _buildPdfxRenderer();
      case PdfRenderBackend.pdfrx:
        return _buildPdfrxRenderer();
      case PdfRenderBackend.pdfjs:
        return _buildPdfjsRenderer();
    }
  }

  Widget _buildPdfxRenderer() {
    return Column(
      children: [
        Expanded(
          child: PdfxRenderer(
            pdfBytes: widget.bytes,
            pageId: widget.pageId,
            versionId: widget.versionId,
            imageKey: widget.imageKey,
            onImageRendered: widget.onImageRendered,
          ),
        ),
        _buildBackendSwitcher(),
      ],
    );
  }

  Widget _buildPdfrxRenderer() {
    return Column(
      children: [
        Expanded(
          child: PdfrxRenderer(
            pdfBytes: widget.bytes,
            pageId: widget.pageId,
            versionId: widget.versionId,
            imageKey: widget.imageKey,
            onImageRendered: widget.onImageRendered,
          ),
        ),
        _buildBackendSwitcher(),
      ],
    );
  }

  Widget _buildPdfjsRenderer() {
    if (_errorMessage != null) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                        _isLoading = true;
                      });
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
          _buildBackendSwitcher(),
        ],
      );
    }

    // 使用InAppWebView + PDF.js渲染PDF
    // 这是真正的矢量渲染，支持文本选择、复制和搜索
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: _generatePdfViewerHtml(),
                  baseUrl: WebUri('about:blank'),
                  encoding: 'utf-8',
                ),
                initialSettings: InAppWebViewSettings(
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  transparentBackground: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                  // 将PDF数据传递给WebView
                  _loadPdfData();
                },
                onLoadStop: (controller, url) {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                onReceivedError: (controller, request, error) {
                  if (kDebugMode) {
                    if (kDebugMode) {
                      debugPrint(
                        'PDF WebView load error: ${error.description}',
                      );
                    }
                  }
                  if (mounted) {
                    setState(() {
                      _errorMessage = 'PDF加载失败: ${error.description}';
                      _isLoading = false;
                    });
                  }
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (kDebugMode) {
                    if (kDebugMode) {
                      debugPrint('PDF.js: ${consoleMessage.message}');
                    }
                  }
                },
              ),
              if (_isLoading)
                ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(height: 12),
                        Text('Loading PDF...', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        _buildBackendSwitcher(),
      ],
    );
  }

  Widget _buildBackendSwitcher() {
    IconData backendIcon;
    switch (_currentBackend!) {
      case PdfRenderBackend.pdfx:
        backendIcon = Icons.high_quality;
        break;
      case PdfRenderBackend.pdfrx:
        backendIcon = Icons.touch_app;
        break;
      case PdfRenderBackend.pdfjs:
        backendIcon = Icons.text_fields;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(backendIcon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              PdfRenderBackendService.getBackendDisplayName(_currentBackend!),
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          TextButton.icon(
            onPressed: _switchBackend,
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('切换', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _switchBackend() async {
    // 循环切换后端: pdfjs -> pdfx -> pdfrx -> pdfjs
    PdfRenderBackend newBackend;
    switch (_currentBackend!) {
      case PdfRenderBackend.pdfjs:
        newBackend = PdfRenderBackend.pdfx;
        break;
      case PdfRenderBackend.pdfx:
        newBackend = PdfRenderBackend.pdfrx;
        break;
      case PdfRenderBackend.pdfrx:
        newBackend = PdfRenderBackend.pdfjs;
        break;
    }

    await PdfRenderBackendService.setBackend(newBackend);

    if (mounted) {
      setState(() {
        _currentBackend = newBackend;
        _isLoading = true;
        _errorMessage = null;
      });

      // 显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '已切换到 ${PdfRenderBackendService.getBackendDisplayName(newBackend)}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadPdfData() async {
    if (_webViewController == null) return;

    try {
      // 将PDF字节数据转换为Base64
      final base64Data = base64Encode(widget.bytes);

      // 通过JavaScript将PDF数据传递给PDF.js
      await _webViewController!.evaluateJavascript(
        source:
            '''
        loadPdfFromBase64('$base64Data');
      ''',
      );
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint('Error loading PDF data: $e');
        }
      }
      if (mounted) {
        setState(() {
          _errorMessage = 'PDF数据加载失败: $e';
        });
      }
    }
  }

  String _generatePdfViewerHtml() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? '#1e1e1e' : '#ffffff';

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
  <title>PDF Viewer</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    html, body {
      width: 100%;
      height: 100%;
      overflow: hidden;
      background-color: $backgroundColor;
    }
    #pdfContainer {
      width: 100%;
      height: 100%;
      overflow: auto;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 16px;
    }
    .pdfPage {
      margin-bottom: 16px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    #loadingIndicator {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: ${isDarkMode ? '#ffffff' : '#000000'};
      font-family: sans-serif;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div id="loadingIndicator">Loading PDF.js...</div>
  <div id="pdfContainer"></div>
  
  <!-- 使用PDF.js的CDN版本 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js" 
    onerror="handleScriptError('PDF.js main library')"></script>
  <script>
    function handleScriptError(scriptName) {
      const indicator = document.getElementById('loadingIndicator');
      indicator.textContent = 'Failed to load ' + scriptName + '. Please check your internet connection.';
      indicator.style.color = 'red';
      console.error('Script load error:', scriptName);
    }
    
    // 配置PDF.js的worker
    if (typeof pdfjsLib !== 'undefined') {
      pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
    } else {
      console.error('PDF.js library not loaded');
      document.getElementById('loadingIndicator').textContent = 'PDF.js library failed to load. Please check your internet connection.';
      document.getElementById('loadingIndicator').style.color = 'red';
    }
    
    let pdfDoc = null;
    
    async function loadPdfFromBase64(base64Data) {
      try {
        // 检查 PDF.js 是否已加载
        if (typeof pdfjsLib === 'undefined') {
          throw new Error('PDF.js library not loaded. Please check your internet connection.');
        }
        
        document.getElementById('loadingIndicator').textContent = 'Loading PDF...';
        
        // 将Base64转换为Uint8Array
        const binaryString = atob(base64Data);
        const bytes = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
          bytes[i] = binaryString.charCodeAt(i);
        }
        
        // 加载PDF文档
        const loadingTask = pdfjsLib.getDocument({ data: bytes });
        pdfDoc = await loadingTask.promise;
        
        document.getElementById('loadingIndicator').style.display = 'none';
        
        // 渲染所有页面
        await renderAllPages();
      } catch (error) {
        console.error('Error loading PDF:', error);
        const indicator = document.getElementById('loadingIndicator');
        indicator.textContent = 'Error loading PDF: ' + error.message;
        indicator.style.color = 'red';
      }
    }
    
    async function renderAllPages() {
      const container = document.getElementById('pdfContainer');
      container.innerHTML = '';
      
      for (let pageNum = 1; pageNum <= pdfDoc.numPages; pageNum++) {
        await renderPage(pageNum, container);
      }
    }
    
    async function renderPage(pageNum, container) {
      try {
        const page = await pdfDoc.getPage(pageNum);
        
        // 创建canvas容器
        const pageDiv = document.createElement('div');
        pageDiv.className = 'pdfPage';
        
        // 设置合适的缩放比例
        const viewport = page.getViewport({ scale: 1.5 });
        
        // 创建canvas用于渲染PDF
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        canvas.width = viewport.width;
        canvas.height = viewport.height;
        
        // 创建文本层容器（用于文本选择）
        const textLayerDiv = document.createElement('div');
        textLayerDiv.style.position = 'absolute';
        textLayerDiv.style.left = '0';
        textLayerDiv.style.top = '0';
        textLayerDiv.style.right = '0';
        textLayerDiv.style.bottom = '0';
        textLayerDiv.style.overflow = 'hidden';
        textLayerDiv.style.lineHeight = '1.0';
        
        const pageContainer = document.createElement('div');
        pageContainer.style.position = 'relative';
        pageContainer.style.width = viewport.width + 'px';
        pageContainer.style.height = viewport.height + 'px';
        
        pageContainer.appendChild(canvas);
        pageContainer.appendChild(textLayerDiv);
        pageDiv.appendChild(pageContainer);
        container.appendChild(pageDiv);
        
        // 渲染PDF页面到canvas
        await page.render({
          canvasContext: context,
          viewport: viewport
        }).promise;
        
        // 渲染文本层以支持文本选择
        const textContent = await page.getTextContent();
        pdfjsLib.renderTextLayer({
          textContentSource: textContent,
          container: textLayerDiv,
          viewport: viewport,
          textDivs: []
        });
        
      } catch (error) {
        console.error('Error rendering page ' + pageNum + ':', error);
      }
    }
    
    // 全局函数，供Flutter调用
    window.loadPdfFromBase64 = loadPdfFromBase64;
  </script>
</body>
</html>
    ''';
  }
}
