import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';
import 'package:luna_arc_sync/core/cache/pdf_preload_manager.dart';
import 'package:luna_arc_sync/core/services/dark_mode_image_processor.dart';
import 'package:luna_arc_sync/core/config/pdf_background_config.dart';

/// pdfx高清渲染器
/// 使用4倍分辨率渲染，提供超清显示效果
/// 支持昼间/夜间主题双版本缓存
class PdfxRenderer extends StatefulWidget {
  final Uint8List pdfBytes;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey;
  final Function(Size)? onImageRendered;
  
  const PdfxRenderer({
    super.key,
    required this.pdfBytes,
    required this.pageId,
    required this.versionId,
    required this.imageKey,
    this.onImageRendered,
  });

  @override
  State<PdfxRenderer> createState() => _PdfxRendererState();
}


class _PdfxRendererState extends State<PdfxRenderer> with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true; // 保持状态，避免重建


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (!_dependenciesInitialized) {
      _isDarkMode = newDarkMode;
      if (kDebugMode) {
        print('pdfx: Dark mode detected: $_isDarkMode');
      }
      _dependenciesInitialized = true;
      _loadFromCacheOrRender();
    } else if (_isDarkMode != newDarkMode) {
      // 主题切换，重新加载
      if (kDebugMode) {
        print('pdfx: 主题切换检测到 (${_isDarkMode ? "暗" : "亮"} -> ${newDarkMode ? "暗" : "亮"})');
      }
      _isDarkMode = newDarkMode;
      setState(() {
        _isLoading = true;
        _renderedImage = null;
        _errorMessage = null;
      });
      _loadFromCacheOrRender();
    }
  }

  /// 首先尝试从缓存加载，如果没有缓存则渲染
  Future<void> _loadFromCacheOrRender() async {
    try {
      // 首先尝试从内存缓存加载（最快）
      final memoryCache = PdfPreloadManager().getFromMemory(
        pageId: widget.pageId,
        versionId: widget.versionId,
        isDarkMode: _isDarkMode,
      );
      
      if (memoryCache != null) {
        if (kDebugMode) {
          print('pdfx: ⚡ 从内存缓存加载成功（无闪烁）');
        }
        
        // 解码图像以获取尺寸
        final codec = await ui.instantiateImageCodec(memoryCache);
        final frameInfo = await codec.getNextFrame();
        final image = frameInfo.image;
        
        // 由于图像是4倍分辨率渲染的，需要除以4得到原始PDF尺寸
        _imageIntrinsicSize = Size(
          image.width / _renderScale,
          image.height / _renderScale,
        );
        
        if (mounted) {
          setState(() {
            _renderedImage = memoryCache;
            _isLoading = false;
          });
          
          // 报告渲染尺寸
          _reportImageSize();
        }
        return;
      }
      
      // 尝试从磁盘缓存加载
      final cachedImage = await PdfCacheService.getCachedPdf(
        pageId: widget.pageId,
        versionId: widget.versionId,
        isDarkMode: _isDarkMode,
      );

      if (cachedImage != null) {
        if (kDebugMode) {
          print('pdfx: ✅ 从磁盘缓存加载成功');
        }
        
        // 放入内存缓存供下次使用
        PdfPreloadManager().putToMemory(
          pageId: widget.pageId,
          versionId: widget.versionId,
          isDarkMode: _isDarkMode,
          data: cachedImage,
        );
        
        // 解码图像以获取尺寸
        final codec = await ui.instantiateImageCodec(cachedImage);
        final frameInfo = await codec.getNextFrame();
        final image = frameInfo.image;
        
        // 由于图像是4倍分辨率渲染的，需要除以4得到原始PDF尺寸
        _imageIntrinsicSize = Size(
          image.width / _renderScale,
          image.height / _renderScale,
        );
        
        if (mounted) {
          setState(() {
            _renderedImage = cachedImage;
            _isLoading = false;
          });
          
          // 报告渲染尺寸
          _reportImageSize();
        }
        return;
      }

      // 缓存未命中，开始渲染
      if (kDebugMode) {
        print('pdfx: 缓存未命中，开始渲染');
      }
      await _loadAndRenderPdf();
    } catch (e) {
      if (kDebugMode) {
        print('pdfx: 缓存加载失败: $e');
      }
      await _loadAndRenderPdf();
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
      
      // 获取背景颜色配置
      final backgroundColor = _isDarkMode
          ? await PdfBackgroundConfig.getDarkColor()
          : await PdfBackgroundConfig.getLightColor();
      
      // 正确转换包含alpha通道的颜色值（ARGB格式）
      final backgroundColorHex = '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}';
      
      if (kDebugMode) {
        print('pdfx: 使用背景颜色: $backgroundColorHex (${_isDarkMode ? "暗色" : "亮色"}, alpha: ${backgroundColor.alpha})');
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
        backgroundColor: backgroundColorHex,
      );
      
      if (pageImage == null) {
        throw Exception(AppLocalizations.of(context)?.renderFailed ?? 'Render failed');
      }
      
      Uint8List finalBytes = pageImage.bytes;
      
      // 在深色模式下应用颜色反转处理（根据"深色模式图像处理"配置）
      // 注意：这里反转的是PDF内容颜色，背景颜色已经在渲染时设置
      // 传入backgroundColor参数以确保背景色不会被反转
      if (_isDarkMode) {
        if (kDebugMode) {
          print('pdfx: Applying dark mode processing to PDF content (filtering background color)');
        }
        finalBytes = await DarkModeImageProcessor.processImageForDarkMode(
          finalBytes,
          backgroundColor: backgroundColor,
        );
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
      
      // 缓存渲染结果到磁盘
      PdfCacheService.cachePdf(
        pageId: widget.pageId,
        versionId: widget.versionId,
        isDarkMode: _isDarkMode,
        imageBytes: finalBytes,
      );
      
      // 同时放入内存缓存
      PdfPreloadManager().putToMemory(
        pageId: widget.pageId,
        versionId: widget.versionId,
        isDarkMode: _isDarkMode,
        data: finalBytes,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // 报告渲染尺寸
        _reportImageSize();
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

  /// 报告图像渲染尺寸
  void _reportImageSize() {
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以保持状态
    
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

