import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/core/utils/coordinate_converter.dart';

class HighlightOverlay extends StatelessWidget {
  final List<Bbox> bboxes;
  final int imageWidth; // Original OCR image width
  final int imageHeight; // Original OCR image height
  final double renderedImageWidth; // NEW: Actual rendered width of the image
  final double renderedImageHeight; // NEW: Actual rendered height of the image
  final Color highlightColor;

  const HighlightOverlay({
    super.key,
    required this.bboxes,
    required this.imageWidth,
    required this.imageHeight,
    required this.renderedImageWidth, // Make required
    required this.renderedImageHeight, // Make required
    this.highlightColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    // Avoid division by zero if rendered dimensions are 0
    if (renderedImageWidth == 0 || renderedImageHeight == 0) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: bboxes.map((bbox) {
        if (!CoordinateConverter.isValidCoordinates(bbox)) {
          return const SizedBox.shrink();
        }

        final imageSize = Size(imageWidth.toDouble(), imageHeight.toDouble());
        final displaySize = Size(renderedImageWidth, renderedImageHeight);
        
        final rect = CoordinateConverter.convertToDisplayRect(bbox, imageSize, displaySize);

        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: Container(
            color: highlightColor.withValues(alpha: 0.4),
          ),
        );
      }).toList(),
    );
  }
}