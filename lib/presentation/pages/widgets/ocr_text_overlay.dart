import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/utils/coordinate_converter.dart';
import 'package:luna_arc_sync/core/cache/text_cache.dart';

class OcrTextOverlay extends StatelessWidget {
  final OcrResult ocrResult;
  final double renderedImageWidth;
  final double renderedImageHeight;
  final bool enableInteraction;
  final String? searchQuery;
  final bool showDebugBorders; // 调试模式，显示边界框

  const OcrTextOverlay({
    super.key,
    required this.ocrResult,
    required this.renderedImageWidth,
    required this.renderedImageHeight,
    this.enableInteraction = true,
    this.searchQuery,
    this.showDebugBorders = false, // 默认关闭调试模式
  });

  @override
  Widget build(BuildContext context) {
    // Add check for zero rendered dimensions
    if (renderedImageWidth == 0 || renderedImageHeight == 0) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: Stack(
        children: [
          // 添加全文复制按钮
          if (enableInteraction)
            Positioned(
              top: 8,
              right: 8,
              child: _buildCopyAllButton(context),
            ),
          // 使用CustomPainter绘制透明文字叠加
          Positioned.fill(
            child: CustomPaint(
              painter: OcrTextPainter(
                ocrResult: ocrResult,
                searchQuery: searchQuery,
                imageSize: Size(ocrResult.imageWidth.toDouble(), ocrResult.imageHeight.toDouble()),
                renderedSize: Size(renderedImageWidth, renderedImageHeight),
                showDebugBorders: showDebugBorders,
              ),
            ),
          ),
          // 添加可选择的文字区域
          if (enableInteraction)
            ...ocrResult.lines.map((line) => _buildSelectableTextRegion(context, line)),
        ],
      ),
    );
  }

  Widget _buildSelectableTextRegion(BuildContext context, OcrLine line) {
    final rect = _calculateTextRect(line.bbox);
    if (rect == null) return const SizedBox.shrink();

    // 计算字体大小，与CustomPainter保持一致
    final fontSize = CoordinateConverter.calculateFontSize(
      line.bbox, 
      Size(ocrResult.imageWidth.toDouble(), ocrResult.imageHeight.toDouble()), 
      Size(renderedImageWidth, renderedImageHeight),
      scaleFactor: 0.8,
    );

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: GestureDetector(
        onLongPress: () => _copyLineText(context, line.text),
        child: Center(
          child: SelectableText(
            line.text,
            style: TextStyle(
              color: Colors.transparent, // 完全透明
              fontSize: fontSize,
            ),
            textAlign: TextAlign.left,
            cursorColor: Theme.of(context).primaryColor,
            showCursor: true,
          ),
        ),
      ),
    );
  }

  Rect? _calculateTextRect(Bbox bbox) {
    if (!CoordinateConverter.isValidCoordinates(bbox)) {
      return null;
    }

    final imageSize = Size(ocrResult.imageWidth.toDouble(), ocrResult.imageHeight.toDouble());
    final displaySize = Size(renderedImageWidth, renderedImageHeight);
    
    return CoordinateConverter.convertToDisplayRect(bbox, imageSize, displaySize);
  }

  
  Widget _buildCopyAllButton(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      child: InkWell(
        onTap: () => _copyAllText(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.content_copy, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)?.copyAllText ?? 'Copy all text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _copyAllText(BuildContext context) async {
    final allText = ocrResult.lines.map((line) => line.text).join('\n');
    await Clipboard.setData(ClipboardData(text: allText));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.textCopied ?? 'Text copied to clipboard'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  Future<void> _copyLineText(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.textCopied ?? 'Text copied to clipboard'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class OcrTextPainter extends CustomPainter {
  final OcrResult ocrResult;
  final String? searchQuery;
  final Size imageSize;
  final Size renderedSize;
  final bool showDebugBorders;

  OcrTextPainter({
    required this.ocrResult,
    this.searchQuery,
    required this.imageSize,
    required this.renderedSize,
    this.showDebugBorders = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in ocrResult.lines) {
      _paintTextLine(canvas, line, size);
    }
  }

  void _paintTextLine(Canvas canvas, OcrLine line, Size size) {
    final rect = _calculateTextRect(line.bbox);
    if (rect == null) return;

    // 检查是否匹配搜索查询
    final isHighlighted = searchQuery != null && 
        searchQuery!.isNotEmpty && 
        line.text.toLowerCase().contains(searchQuery!.toLowerCase());

    // 计算字体大小
    final fontSize = CoordinateConverter.calculateFontSize(
      line.bbox, 
      imageSize, 
      renderedSize,
      scaleFactor: 0.8,
    );

    // 尝试从缓存获取TextPainter
    TextPainter? textPainter = TextCache.getCachedTextPainter(
      text: line.text,
      fontSize: fontSize,
      width: rect.width,
      searchQuery: searchQuery,
    );

    if (textPainter == null) {
      // 创建新的TextPainter并缓存
      textPainter = TextPainter(
        text: TextSpan(
          text: line.text,
          style: TextStyle(
            color: Colors.transparent, // 完全透明
            fontSize: fontSize,
            backgroundColor: isHighlighted 
                ? Colors.yellow.withValues(alpha: 0.3) 
                : Colors.transparent,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left, // 确保左对齐
      );
      
      textPainter.layout(maxWidth: rect.width);
      
      // 缓存TextPainter
      TextCache.cacheTextPainter(
        text: line.text,
        fontSize: fontSize,
        width: rect.width,
        searchQuery: searchQuery,
        painter: textPainter,
      );
    }
    
    // 确保文字绘制在正确的矩形区域内，并垂直居中对齐
    final textOffset = Offset(
      rect.left, 
      rect.top + (rect.height - textPainter.height) / 2
    );
    textPainter.paint(canvas, textOffset);
    
    // 调试模式：绘制边界框
    if (showDebugBorders) {
      final paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRect(rect, paint);
      
      // 绘制文字边界框
      final textRect = Rect.fromLTWH(
        textOffset.dx,
        textOffset.dy,
        textPainter.width,
        textPainter.height,
      );
      final textPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRect(textRect, textPaint);
    }
  }

  Rect? _calculateTextRect(Bbox bbox) {
    if (!CoordinateConverter.isValidCoordinates(bbox)) {
      return null;
    }

    return CoordinateConverter.convertToDisplayRect(bbox, imageSize, renderedSize);
  }

  @override
  bool shouldRepaint(OcrTextPainter oldDelegate) {
    return oldDelegate.ocrResult != ocrResult ||
           oldDelegate.searchQuery != searchQuery ||
           oldDelegate.imageSize != imageSize ||
           oldDelegate.renderedSize != renderedSize ||
           oldDelegate.showDebugBorders != showDebugBorders;
  }
}