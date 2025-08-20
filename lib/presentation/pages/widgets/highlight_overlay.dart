import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';

class HighlightOverlay extends StatelessWidget {
  final List<Bbox> bboxes;
  final int imageWidth;
  final int imageHeight;
  final Color highlightColor;

  const HighlightOverlay({
    super.key,
    required this.bboxes,
    required this.imageWidth,
    required this.imageHeight,
    this.highlightColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 同样，使用 LayoutBuilder 来确保高亮框的位置在缩放后依然准确
        final scaleX = constraints.maxWidth / imageWidth;
        final scaleY = constraints.maxHeight / imageHeight;

        return Stack(
          children: bboxes.map((bbox) {
            final scaledX1 = bbox.x1 * scaleX;
            final scaledY1 = bbox.y1 * scaleY;
            final scaledWidth = (bbox.x2 - bbox.x1) * scaleX;
            final scaledHeight = (bbox.y2 - bbox.y1) * scaleY;

            return Positioned(
              left: scaledX1,
              top: scaledY1,
              width: scaledWidth,
              height: scaledHeight,
              child: Container(
                // 使用半透明的颜色，这样既能高亮，又不完全遮挡文字
                color: highlightColor.withOpacity(0.4),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}