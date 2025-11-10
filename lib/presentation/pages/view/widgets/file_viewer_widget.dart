import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/cache/image_cache_service_enhanced.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/presentation/pages/view/models/file_load_result.dart';
import 'package:luna_arc_sync/presentation/pages/view/widgets/pdf_vector_renderer.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/highlight_overlay_with_fitted_box.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/ocr_text_overlay_with_fitted_box.dart';

/// 文件查看器组件
/// 支持图片和PDF文件的显示，包含OCR结果叠加
class FileViewerWidget extends StatefulWidget {
  final String fileUrl;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey;
  final void Function(Size)? onImageRendered;
  final OcrResult? ocrResult;
  final String searchQuery;
  final List<Bbox> highlightedBboxes;
  final bool showDebugBorders;

  const FileViewerWidget({
    required this.fileUrl,
    required this.pageId,
    required this.versionId,
    required this.imageKey,
    this.onImageRendered,
    this.ocrResult,
    this.searchQuery = '',
    this.highlightedBboxes = const [],
    this.showDebugBorders = false,
    super.key,
  });

  @override
  State<FileViewerWidget> createState() => _FileViewerWidgetState();
}

class _FileViewerWidgetState extends State<FileViewerWidget>
    with AutomaticKeepAliveClientMixin {
  late Future<FileLoadResult> _loadFuture;
  Size? _imageIntrinsicSize; // 存储图片的固有尺寸
  Size? _calculatedRenderSize; // 存储计算出的实际渲染尺寸

  @override
  bool get wantKeepAlive => true; // 保持状态，避免重建

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadFile();
  }

  Future<Size?> _loadImageIntrinsicSize(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final size = Size(image.width.toDouble(), image.height.toDouble());
      _imageIntrinsicSize = size;

      image.dispose();
      codec.dispose();

      return size;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 图片解码失败: ${e.toString()}');
        if (kDebugMode) {
          debugPrint('数据长度: ${bytes.length} bytes');
        }
        if (bytes.isNotEmpty) {
          print(
            '数据头: ${bytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
          );
        }
      }
      return null;
    }
  }

  Future<FileLoadResult> _loadFile() async {
    try {
      // 首先尝试从缓存加载图片
      final cachedBytes = await ImageCacheServiceEnhanced.getCachedImage(
        widget.fileUrl,
      );
      if (cachedBytes != null) {
        if (kDebugMode) {
          if (kDebugMode) {
            debugPrint('✅ 图片从缓存加载: ${widget.fileUrl}');
          }
        }
        // 缓存命中，返回缓存的数据
        return FileLoadResult(
          bytes: cachedBytes,
          contentType: 'image/jpeg', // 假设缓存的是图片
          fromCache: true,
        );
      }

      // 缓存未命中，从网络加载
      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint('🔄 图片从网络加载: ${widget.fileUrl}');
        }
      }

      final apiClient = getIt<ApiClient>();
      final response = await apiClient.dio.get<Uint8List>(
        widget.fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final bytes = response.data as Uint8List;
      final contentType = response.headers.value('content-type') ?? '';

      // 如果是图片，缓存它
      if (contentType.startsWith('image/')) {
        ImageCacheServiceEnhanced.cacheImage(
          url: widget.fileUrl,
          imageBytes: bytes,
        );
      }

      return FileLoadResult(
        bytes: bytes,
        contentType: contentType,
        fromCache: false,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint('❌ 加载文件失败: ${widget.fileUrl}');
        }
        if (kDebugMode) {
          debugPrint('错误: $e');
        }
        if (kDebugMode) {
          debugPrint('堆栈: $stackTrace');
        }
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以保持状态

    return FutureBuilder<FileLoadResult>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 12),
                Text('Loading file...', style: TextStyle(fontSize: 14)),
              ],
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 8),
                const Text('Failed to load file.'),
                if (snapshot.hasError)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        }

        final result = snapshot.data!;
        return _buildImageWidget(result.bytes, result.contentType);
      },
    );
  }

  Widget _buildImageWidget(Uint8List bytes, String contentType) {
    Widget imageWidget;
    if (contentType.startsWith('image/')) {
      // 对于普通图片，异步加载固有尺寸（addPostFrameCallback 会等待它完成）
      if (_imageIntrinsicSize == null) {
        _loadImageIntrinsicSize(bytes);
      }

      imageWidget = FittedBox(
        key: widget
            .imageKey, // Move key to FittedBox to get actual rendered size
        child: Image.memory(bytes),
      );
    } else if (contentType == 'application/pdf') {
      imageWidget = PdfVectorRenderer(
        bytes: bytes,
        pageId: widget.pageId,
        versionId: widget.versionId,
        imageKey: widget.imageKey,
        onImageRendered: widget.onImageRendered,
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.help_outline, size: 50),
            const SizedBox(height: 8),
            Text('Unsupported file type: $contentType'),
          ],
        ),
      );
    }

    // After the image is built, report its actual rendered size
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 等待固有尺寸加载完成（仅针对普通图片）
      if (contentType.startsWith('image/')) {
        int retries = 0;
        while (_imageIntrinsicSize == null && retries < 20) {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          retries++;
        }
      }

      if (widget.imageKey.currentContext != null &&
          mounted &&
          _imageIntrinsicSize != null) {
        final renderObject = widget.imageKey.currentContext!.findRenderObject();
        if (renderObject is RenderBox && renderObject.hasSize) {
          // 计算 BoxFit.contain 下的实际渲染尺寸
          final containerSize = renderObject.size;
          final imageAspectRatio =
              _imageIntrinsicSize!.width / _imageIntrinsicSize!.height;
          final containerAspectRatio =
              containerSize.width / containerSize.height;

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

          // 更新内部状态和通知父组件
          if (mounted) {
            setState(() {
              _calculatedRenderSize = actualSize;
            });
          }

          if (widget.onImageRendered != null) {
            widget.onImageRendered!(actualSize);
          }
        }
      }
    });

    // 如果有OCR结果，将图片和OCR叠加层包装在Stack中
    if (widget.ocrResult != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final containerSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          // 使用计算好的渲染尺寸，如果还没计算出来则使用容器尺寸作为临时值
          final renderSize = _calculatedRenderSize ?? containerSize;

          return Stack(
            alignment: Alignment.center, // 确保内容居中
            children: [
              imageWidget,
              // OCR 叠加层（始终显示）
              SizedBox(
                width: containerSize.width,
                height: containerSize.height,
                child: Stack(
                  children: [
                    if (widget.highlightedBboxes.isNotEmpty)
                      Positioned.fill(
                        child: HighlightOverlayWithFittedBox(
                          bboxes: widget.highlightedBboxes,
                          imageWidth: widget.ocrResult!.imageWidth,
                          imageHeight: widget.ocrResult!.imageHeight,
                          renderedImageWidth: renderSize.width,
                          renderedImageHeight: renderSize.height,
                          containerSize: containerSize,
                        ),
                      ),
                    Positioned.fill(
                      child: OcrTextOverlayWithFittedBox(
                        ocrResult: widget.ocrResult!,
                        renderedImageWidth: renderSize.width,
                        renderedImageHeight: renderSize.height,
                        containerSize: containerSize,
                        searchQuery: widget.searchQuery.isNotEmpty
                            ? widget.searchQuery
                            : null,
                        showDebugBorders: widget.showDebugBorders,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    return imageWidget; // Return just the image widget
  }
}
