import 'dart:async';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/presentation/pages/view/version_history_Page.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/highlight_overlay_with_fitted_box.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/ocr_text_overlay_with_fitted_box.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:luna_arc_sync/core/config/pdf_render_backend.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/pdfx_renderer.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/pdfrx_renderer.dart';

// PDF Cache Service
class PdfCacheService {
  static const String _cachePrefix = 'pdf_cache_';
  static const String _timestampPrefix = 'pdf_timestamp_';
  static const int _maxCacheSize = 50; // Maximum number of cached PDFs
  static const Duration _cacheExpiry = Duration(hours: 24); // 缓存过期时间
  
  static Future<Uint8List?> getCachedPdf(String pageId, String versionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix${pageId}_$versionId';
      final timestampKey = '$_timestampPrefix${pageId}_$versionId';
      
      final cachedData = prefs.getString(cacheKey);
      final timestampStr = prefs.getString(timestampKey);
      
      if (cachedData != null && timestampStr != null) {
        final timestamp = DateTime.parse(timestampStr);
        final now = DateTime.now();
        
        // 检查是否过期
        if (now.difference(timestamp) > _cacheExpiry) {
          // 过期，删除缓存
          await prefs.remove(cacheKey);
          await prefs.remove(timestampKey);
          if (kDebugMode) {
            print('PDF缓存已过期，已删除: $cacheKey');
          }
          return null;
        }
        
        return base64Decode(cachedData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cached PDF: $e');
      }
    }
    return null;
  }
  
  static Future<void> cachePdf(String pageId, String versionId, Uint8List imageBytes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix${pageId}_$versionId';
      final timestampKey = '$_timestampPrefix${pageId}_$versionId';
      final base64Data = base64Encode(imageBytes);
      final timestamp = DateTime.now().toIso8601String();
      
      // Clean old cache if needed
      await _cleanOldCache(prefs);
      
      await prefs.setString(cacheKey, base64Data);
      await prefs.setString(timestampKey, timestamp);
    } catch (e) {
      if (kDebugMode) {
        print('Error caching PDF: $e');
      }
    }
  }
  
  static Future<void> _cleanOldCache(SharedPreferences prefs) async {
    final cacheKeys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix)).toList();
    if (cacheKeys.length >= _maxCacheSize) {
      // Remove oldest entries (simple implementation)
      final keysToRemove = cacheKeys.take(cacheKeys.length - _maxCacheSize + 1);
      for (final key in keysToRemove) {
        await prefs.remove(key);
        // 同时删除对应的时间戳
        final timestampKey = key.replaceFirst(_cachePrefix, _timestampPrefix);
        await prefs.remove(timestampKey);
      }
    }
  }
}

// Dark Mode Image Processor
class DarkModeImageProcessor {
  static int _blackThreshold = 180; // Adjustable threshold for dark text detection (lowered for better text capture)
  static int _whiteThreshold = 15; // Adjustable threshold for white detection
  static double _darkenFactor = 0.7; // Adjustable factor for darkening other colors
  static double _lightenFactor = 0.3; // Adjustable factor for lightening other colors
  static bool _initialized = false;
  
  // Getters for settings
  static int get blackThreshold => _blackThreshold;
  static int get whiteThreshold => _whiteThreshold;
  static double get darkenFactor => _darkenFactor;
  static double get lightenFactor => _lightenFactor;
  
  // Setters for settings
  static void setBlackThreshold(int value) {
    _blackThreshold = value.clamp(0, 255);
    _saveSettings();
  }
  
  static void setWhiteThreshold(int value) {
    _whiteThreshold = value.clamp(0, 255);
    _saveSettings();
  }
  
  static void setDarkenFactor(double value) {
    _darkenFactor = value.clamp(0.0, 1.0);
    _saveSettings();
  }
  
  static void setLightenFactor(double value) {
    _lightenFactor = value.clamp(0.0, 1.0);
    _saveSettings();
  }
  
  // Initialize settings from storage
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _blackThreshold = prefs.getInt('dark_mode_black_threshold') ?? 180;
      _whiteThreshold = prefs.getInt('dark_mode_white_threshold') ?? 15;
      _darkenFactor = prefs.getDouble('dark_mode_darken_factor') ?? 0.7;
      _lightenFactor = prefs.getDouble('dark_mode_lighten_factor') ?? 0.3;
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading dark mode settings: $e');
      }
    }
  }
  
  // Save settings to storage
  static Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dark_mode_black_threshold', _blackThreshold);
      await prefs.setInt('dark_mode_white_threshold', _whiteThreshold);
      await prefs.setDouble('dark_mode_darken_factor', _darkenFactor);
      await prefs.setDouble('dark_mode_lighten_factor', _lightenFactor);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving dark mode settings: $e');
      }
    }
  }
  
  static Future<Uint8List> processImageForDarkMode(Uint8List imageBytes) async {
    // Initialize settings if not already done
    await initialize();
    
    if (kDebugMode) {
      print('DarkModeImageProcessor: Processing image for dark mode');
      print('Black threshold: $_blackThreshold, White threshold: $_whiteThreshold');
      print('Darken factor: $_darkenFactor, Lighten factor: $_lightenFactor');
    }
    
    try {
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      
      final width = image.width;
      final height = image.height;
      final pixelData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      
      if (pixelData == null) return imageBytes;
      
      final bytes = pixelData.buffer.asUint8List();
      
      // Process each pixel
      for (int i = 0; i < bytes.length; i += 4) {
        final r = bytes[i];
        final g = bytes[i + 1];
        final b = bytes[i + 2];
        // final a = bytes[i + 3]; // Alpha channel, not used in processing
        
        // Calculate brightness for better text detection
        final brightness = (r + g + b) / 3;
        
        // Check if pixel is dark (text or dark elements) - use lower threshold for better text detection
        if (brightness <= _blackThreshold) {
          // Convert dark colors (including text) to white
          bytes[i] = 255;     // R
          bytes[i + 1] = 255; // G
          bytes[i + 2] = 255; // B
          // Keep alpha unchanged
        } else if (brightness >= (255 - _whiteThreshold)) {
          // Convert very light colors to black
          bytes[i] = 0;       // R
          bytes[i + 1] = 0;   // G
          bytes[i + 2] = 0;   // B
          // Keep alpha unchanged
        } else {
          // Process medium brightness colors based on their brightness
          if (brightness > 128) {
            // Light colors - darken them
            bytes[i] = (r * _darkenFactor).round().clamp(0, 255);     // R
            bytes[i + 1] = (g * _darkenFactor).round().clamp(0, 255); // G
            bytes[i + 2] = (b * _darkenFactor).round().clamp(0, 255); // B
          } else {
            // Medium-dark colors - lighten them
            bytes[i] = (255 - (255 - r) * _lightenFactor).round().clamp(0, 255);     // R
            bytes[i + 1] = (255 - (255 - g) * _lightenFactor).round().clamp(0, 255); // G
            bytes[i + 2] = (255 - (255 - b) * _lightenFactor).round().clamp(0, 255); // B
          }
          // Keep alpha unchanged
        }
      }
      
      // Create a completer to capture the processed image
      final completer = Completer<ui.Image>();
      ui.decodeImageFromPixels(
        bytes,
        width,
        height,
        ui.PixelFormat.rgba8888,
        (ui.Image img) {
          completer.complete(img);
        },
      );
      
      final processedImage = await completer.future;
      final processedBytes = await processedImage.toByteData(format: ui.ImageByteFormat.png);
      // Dispose images properly
      image.dispose();
      processedImage.dispose();
      
      return processedBytes?.buffer.asUint8List() ?? imageBytes;
    } catch (e) {
      if (kDebugMode) {
        print('Error processing image for dark mode: $e');
      }
      return imageBytes;
    }
  }
}

class PageDetailPage extends StatefulWidget {
  final String pageId;
  const PageDetailPage({super.key, required this.pageId});

  @override
  State<PageDetailPage> createState() => _PageDetailPageState();
}

class _PageDetailPageState extends State<PageDetailPage> {
  bool _isSearchVisible = false;
  final _searchController = TextEditingController();
  late final GlobalKey _imageKey; // NEW: Key to get rendered size - made unique per page
  Size? _renderedImageSize; // NEW: Stores the actual rendered size of the image
  JobStatusEnum? _previousOcrStatus; // Track previous OCR status to detect transitions
  bool _showDebugBorders = false; // 调试模式开关

  @override
  void initState() {
    super.initState();
    // Create unique GlobalKey for this page instance
    _imageKey = GlobalKey(debugLabel: 'page_image_${widget.pageId}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PageDetailCubit>()..fetchPage(widget.pageId),
      child: BlocConsumer<PageDetailCubit, PageDetailState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (_, ocrStatus, ocrErrorMessage, _, _) {
              final l10n = AppLocalizations.of(context)!;
              
              // Only show notification when transitioning from Processing to Completed/Failed
              if (_previousOcrStatus == JobStatusEnum.Processing) {
                if (ocrStatus == JobStatusEnum.Completed) {
                  // OCR完成通知
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text(l10n.ocrTaskCompleted),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3)));
                } else if (ocrStatus == JobStatusEnum.Failed && ocrErrorMessage != null) {
                  // OCR失败通知
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text(ocrErrorMessage), 
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4)));
                }
              }
              
              // Update previous status for next comparison
              _previousOcrStatus = ocrStatus;
            },
          );
        },
        builder: (context, state) {
          final docTitle =
              state.whenOrNull(success: (doc, _, _, _, _) => doc.title) ??
                  'Loading...';

          return Scaffold(
            appBar: AppBar(
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _isSearchVisible
                    ? TextField(
                        key: const ValueKey('SearchField'),
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search in page...',
                          hintStyle:
                              TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        onChanged: (query) =>
                            context.read<PageDetailCubit>().search(query),
                      )
                    : Text(docTitle, key: const ValueKey('TitleText')),
              ),
              actions: [
                state.whenOrNull(success: (doc, _, _, _, _) {
                      if (doc.currentVersion?.ocrResult != null) {
                        return IconButton(
                          icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
                          tooltip: 'Search in page',
                          onPressed: () {
                            setState(() {
                              _isSearchVisible = !_isSearchVisible;
                              if (!_isSearchVisible) {
                                context.read<PageDetailCubit>().search('');
                                _searchController.clear();
                              }
                            });
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }) ??
                    const SizedBox.shrink(),
                // 调试按钮 - 只在开发模式下显示
                if (kDebugMode)
                  IconButton(
                    icon: Icon(_showDebugBorders ? Icons.bug_report : Icons.bug_report_outlined),
                    tooltip: _showDebugBorders ? 'Hide debug borders' : 'Show debug borders',
                    onPressed: () {
                      setState(() {
                        _showDebugBorders = !_showDebugBorders;
                      });
                    },
                  ),
                state.whenOrNull(success: (doc, _, _, _, _) {
                      return IconButton(
                        icon: const Icon(Icons.history),


                        tooltip: AppLocalizations.of(context)?.viewVersionHistory ?? 'View version history',
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VersionHistoryPage(
                                pageId: doc.pageId,
                                currentVersionId: doc.currentVersion?.versionId,
                              ),
                            ),
                          );
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            context
                                .read<PageDetailCubit>()
                                .fetchPage(widget.pageId);
                          }
                        },
                      );
                    }) ??
                    const SizedBox.shrink(),
                state.whenOrNull(success: (doc, ocrStatus, _, _, _) {
                      // 显示OCR按钮或处理状态
                      if (ocrStatus == JobStatusEnum.Processing) {
                        // 处理中：显示小转圈
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // 未处理：显示OCR按钮
                        return IconButton(
                          icon: const Icon(Icons.document_scanner_outlined),
                          tooltip: 'Start OCR',
                          onPressed: () async {
                            try {
                              await context.read<PageDetailCubit>().startOcrJob();
                            } catch (e) {
                              if (mounted) {
                                // ignore: use_build_context_synchronously
                                final l10n = AppLocalizations.of(context)!;
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.ocrTaskStartFailed(e.toString())),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }
                    }) ??
                    const SizedBox.shrink(),
              ],
            ),
            body: state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PageDetailCubit>().fetchPage(widget.pageId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              success: (page, ocrStatus, _, searchQuery, highlightedBboxes) {
                if (page.currentVersion == null) {
                  return const Center(child: Text('This page has no content yet.'));
                }
                final versionId = page.currentVersion!.versionId;
                final fileUrl = '/api/images/$versionId';

                final ocrResult = page.currentVersion!.ocrResult;
                final l10n = AppLocalizations.of(context)!;
                
                return Column(
                  children: [
                    // 顶部进度横幅（非阻塞式）
                    if (ocrStatus == JobStatusEnum.Processing)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.ocrProcessingInProgress,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // 页面内容区域
                    Expanded(
                      child: InteractiveViewer(
                        maxScale: 5.0,
                        child: SizedBox.expand(
                          child: FileViewer(
                            fileUrl: fileUrl,
                            pageId: page.pageId,
                            versionId: versionId,
                            imageKey: _imageKey,
                            onImageRendered: (size) {
                              if (_renderedImageSize != size) {
                                setState(() {
                                  _renderedImageSize = size;
                                  if (kDebugMode) {
                                    print('Rendered image size: $size');
                                  }
                                });
                              }
                            },
                            ocrResult: ocrResult,
                            searchQuery: searchQuery,
                            highlightedBboxes: highlightedBboxes,
                            showDebugBorders: _showDebugBorders,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FileViewer extends StatefulWidget {
  final String fileUrl;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey; // NEW: Key to get rendered size
  final Function(Size)? onImageRendered; // NEW: Callback for rendered size
  final OcrResult? ocrResult;
  final String searchQuery;
  final List<Bbox> highlightedBboxes;
  final bool showDebugBorders;

  const FileViewer({
    super.key,
    required this.fileUrl,
    required this.pageId,
    required this.versionId,
    required this.imageKey, // Make it required
    this.onImageRendered,
    this.ocrResult,
    this.searchQuery = '',
    this.highlightedBboxes = const [],
    this.showDebugBorders = false,
  });

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  Future<Response<dynamic>>? _fileFuture;
  Size? _imageIntrinsicSize; // 存储图片的固有尺寸
  Size? _calculatedRenderSize; // 存储计算出的实际渲染尺寸

  @override
  void initState() {
    super.initState();
    _loadFile();
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
      return null;
    }
  }


  void _loadFile() {
    final apiClient = getIt<ApiClient>();
    _fileFuture = apiClient.dio.get(
      widget.fileUrl,
      options: Options(responseType: ResponseType.bytes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: _fileFuture,
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
                const Text("Failed to load file."),
                if (snapshot.hasError)
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        }

        final response = snapshot.data!;
        final contentType = response.headers.value('content-type') ?? '';
        final bytes = response.data as Uint8List;

        if (kDebugMode) {
          print('FileViewer: contentType=$contentType, bytes.length=${bytes.length}');
        }

        Widget imageWidget;
        if (contentType.startsWith('image/')) {
          // 对于普通图片，异步加载固有尺寸（addPostFrameCallback 会等待它完成）
          if (_imageIntrinsicSize == null) {
            _loadImageIntrinsicSize(bytes);
          }
          
          imageWidget = FittedBox(
            key: widget.imageKey, // Move key to FittedBox to get actual rendered size
            fit: BoxFit.contain,
            alignment: Alignment.center, // 明确设置图片居中
            child: Image.memory(bytes),
          );
        } else if (contentType == 'application/pdf') {
          imageWidget = _PdfVectorRenderer(
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
              await Future.delayed(const Duration(milliseconds: 50));
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
              final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
              
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
                            searchQuery: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
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
      },
    );
  }
}

// A widget that renders a PDF using the configured backend
// Supports multiple rendering engines:
// - PDF.js: Vector rendering with text selection (WebView-based)
// - pdfx: High-quality raster rendering at 4x resolution (Native)
class _PdfVectorRenderer extends StatefulWidget {
  final Uint8List bytes;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey;
  final Function(Size)? onImageRendered;
  
  const _PdfVectorRenderer({
    required this.bytes,
    required this.pageId,
    required this.versionId,
    required this.imageKey,
    this.onImageRendered,
  });

  @override
  State<_PdfVectorRenderer> createState() => _PdfVectorRendererState();
}

class _PdfVectorRendererState extends State<_PdfVectorRenderer> {
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
                  mimeType: 'text/html',
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useHybridComposition: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  supportZoom: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  transparentBackground: true,
                  // 启用文本选择
                  disableLongPressContextMenuOnLinks: false,
                  // 允许复制
                  allowsLinkPreview: true,
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
                    print('PDF WebView load error: ${error.description}');
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
                    print('PDF.js: ${consoleMessage.message}');
                  }
                },
              ),
              if (_isLoading)
                Container(
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
          Icon(
            backendIcon,
            size: 20,
            color: Colors.grey[600],
          ),
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
      await _webViewController!.evaluateJavascript(source: '''
        loadPdfFromBase64('$base64Data');
      ''');
    } catch (e) {
      if (kDebugMode) {
        print('Error loading PDF data: $e');
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
