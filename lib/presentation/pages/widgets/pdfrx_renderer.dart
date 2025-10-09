import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// pdfrx现代渲染器
/// 支持缩放、平移和高级交互功能
class PdfrxRenderer extends StatefulWidget {
  final Uint8List pdfBytes;
  final GlobalKey imageKey;
  final Function(Size)? onImageRendered;
  
  const PdfrxRenderer({
    super.key,
    required this.pdfBytes,
    required this.imageKey,
    this.onImageRendered,
  });

  @override
  State<PdfrxRenderer> createState() => _PdfrxRendererState();
}

class _PdfrxRendererState extends State<PdfrxRenderer> {
  final _controller = PdfViewerController();

  @override
  void initState() {
    super.initState();
    
    // 报告渲染尺寸
    // 注意：pdfrx 使用自己的渲染逻辑，容器大小就是实际渲染大小
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onImageRendered != null && 
          widget.imageKey.currentContext != null && 
          mounted) {
        final renderObject = widget.imageKey.currentContext!.findRenderObject();
        if (renderObject is RenderBox && renderObject.hasSize) {
          // pdfrx 的容器尺寸就是PDF的实际渲染尺寸
          widget.onImageRendered!(renderObject.size);
        }
      }
    });
  }

  @override
  void dispose() {
    // _controller.dispose(); // pdfrx控制器不需要手动dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('pdfrx: 开始渲染PDF，大小: ${widget.pdfBytes.length} bytes');
    }
    
    return Container(
      key: widget.imageKey,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: PdfViewer.data(
        widget.pdfBytes,
        sourceName: 'PDF Document',
        controller: _controller,
        params: PdfViewerParams(
          // 加载指示器
          loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      totalBytes != null
                          ? '加载中... ${(bytesDownloaded / totalBytes * 100).toStringAsFixed(0)}%'
                          : '加载中...',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '支持缩放和平移',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
          // 错误页面构建器
          errorBannerBuilder: (context, error, stackTrace, pageNumber) {
            if (kDebugMode) {
              print('pdfrx: 页面 $pageNumber 加载错误 - $error');
            }
            return Container(
              color: Colors.red.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    '页面 $pageNumber 加载失败',
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 4),
                    Text(
                      error.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 触发重新加载
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          },
          // 页面间距
          margin: 8,
        ),
      ),
    );
  }
}

