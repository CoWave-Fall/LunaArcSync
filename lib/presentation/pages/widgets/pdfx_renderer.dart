import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';

/// pdfx高清渲染器
/// 使用4倍分辨率渲染，提供超清显示效果
class PdfxRenderer extends StatefulWidget {
  final Uint8List pdfBytes;
  final GlobalKey imageKey;
  final Function(Size)? onImageRendered;
  
  const PdfxRenderer({
    super.key,
    required this.pdfBytes,
    required this.imageKey,
    this.onImageRendered,
  });

  @override
  State<PdfxRenderer> createState() => _PdfxRendererState();
}

class _PdfxRendererState extends State<PdfxRenderer> {
  PdfDocument? _document;
  PdfPage? _page;
  Uint8List? _renderedImage;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isDarkMode = false;
  bool _dependenciesInitialized = false;
  Size? _imageIntrinsicSize; // 存储PDF渲染后的固有尺寸
  
  // 4倍渲染分辨率
  static const double _renderScale = 4.0;

  @override
  void initState() {
    super.initState();
    // Don't call _loadAndRenderPdf here to avoid Theme.of() in initState
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dependenciesInitialized) {
      _isDarkMode = Theme.of(context).brightness == Brightness.dark;
      if (kDebugMode) {
        print('pdfx: Dark mode detected: $_isDarkMode');
      }
      _dependenciesInitialized = true;
      _loadAndRenderPdf();
    }
  }

  @override
  void dispose() {
    _page?.close();
    _document?.close();
    super.dispose();
  }

  Future<void> _loadAndRenderPdf() async {
    try {
      if (kDebugMode) {
        print('pdfx: 开始加载PDF，大小: ${widget.pdfBytes.length} bytes');
      }
      
      // 加载PDF文档
      _document = await PdfDocument.openData(widget.pdfBytes);
      
      if (_document == null) {
        throw Exception('无法打开PDF文档');
      }
      
      if (kDebugMode) {
        print('pdfx: PDF加载成功，页数: ${_document!.pagesCount}');
      }
      
      // 加载第一页
      _page = await _document!.getPage(1);
      
      if (_page == null) {
        throw Exception('无法获取PDF页面');
      }
      
      if (kDebugMode) {
        print('pdfx: 页面加载成功，尺寸: ${_page!.width}x${_page!.height}');
      }
      
      // 计算渲染尺寸（4倍分辨率）
      final width = (_page!.width * _renderScale).toInt();
      final height = (_page!.height * _renderScale).toInt();
      
      if (kDebugMode) {
        print('pdfx: 开始渲染，目标尺寸: ${width}x$height (${_renderScale}x)');
      }
      
      // 渲染页面为图像
      final pageImage = await _page!.render(
        width: width.toDouble(),
        height: height.toDouble(),
        format: PdfPageImageFormat.png,
        backgroundColor: '#FFFFFF',
      );
      
      if (pageImage == null) {
        throw Exception(AppLocalizations.of(context)?.renderFailed ?? 'Render failed');
      }
      
      Uint8List finalBytes = pageImage.bytes;
      
      // Apply dark mode processing if needed
      if (_isDarkMode) {
        if (kDebugMode) {
          print('pdfx: Applying dark mode processing');
        }
        finalBytes = await DarkModeImageProcessor.processImageForDarkMode(finalBytes);
      } else {
        if (kDebugMode) {
          print('pdfx: Skipping dark mode processing (light mode)');
        }
      }
      
      _renderedImage = finalBytes;
      
      // 存储图片的固有尺寸（原始PDF页面尺寸）
      _imageIntrinsicSize = Size(_page!.width, _page!.height);
      
      if (kDebugMode) {
        print('pdfx: 渲染完成，图像大小: ${_renderedImage!.length} bytes');
        print('pdfx: PDF页面固有尺寸: $_imageIntrinsicSize');
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // 等待图像渲染后报告实际渲染尺寸
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.onImageRendered != null && 
              widget.imageKey.currentContext != null && 
              mounted &&
              _imageIntrinsicSize != null) {
            final renderObject = widget.imageKey.currentContext!.findRenderObject();
            if (renderObject is RenderBox && renderObject.hasSize) {
              // 计算 BoxFit.contain 下的实际渲染尺寸
              final containerSize = renderObject.size;
              final imageAspectRatio = _imageIntrinsicSize!.width / _imageIntrinsicSize!.height;
              final containerAspectRatio = containerSize.width / containerSize.height;
              
              Size actualSize;
              if (imageAspectRatio > containerAspectRatio) {
                // 图片更宽，以宽度为准
                final width = containerSize.width;
                final height = width / imageAspectRatio;
                actualSize = Size(width, height);
              } else {
                // 图片更高，以高度为准
                final height = containerSize.height;
                final width = height * imageAspectRatio;
                actualSize = Size(width, height);
              }
              
              widget.onImageRendered!(actualSize);
            }
          }
        });
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('pdfx: 错误 - $e');
        print('pdfx: 堆栈 - $stackTrace');
      }
      
      if (mounted) {
        setState(() {
          _errorMessage = 'PDF渲染失败: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
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
              Text('渲染高清PDF...', style: TextStyle(fontSize: 14)),
              SizedBox(height: 4),
              Text('4x 分辨率', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
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
                _loadAndRenderPdf();
              },
              child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_renderedImage == null) {
      return const Center(child: Text('无法加载PDF'));
    }
    
    return FittedBox(
      key: widget.imageKey,
      fit: BoxFit.contain,
      alignment: Alignment.center, // 明确设置图片居中
      child: Image.memory(
        _renderedImage!,
        gaplessPlayback: true,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

