import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';

class OcrTextOverlay extends StatelessWidget {
  final OcrResult ocrResult;

  const OcrTextOverlay({
    super.key,
    required this.ocrResult,
  });

  @override
  Widget build(BuildContext context) {
    // 使用 LayoutBuilder 来获取父容器的实际尺寸
    return LayoutBuilder(
      builder: (context, constraints) {
        // 如果原始图片宽度为0，避免除零错误
        if (ocrResult.imageWidth == 0) return const SizedBox.shrink();

        // 计算缩放比例
        final scaleX = constraints.maxWidth / ocrResult.imageWidth;

        return Stack(
          children: [
            ...ocrResult.lines.map((line) {
              // 根据缩放比例调整位置和尺寸
              final scaledX1 = line.bbox.x1 * scaleX;
              final scaledY1 = line.bbox.y1 * scaleX; // 使用统一的缩放比例保持宽高比
              final scaledWidth = (line.bbox.x2 - line.bbox.x1) * scaleX;
              final scaledHeight = (line.bbox.y2 - line.bbox.y1) * scaleX;

              return Positioned(
                left: scaledX1,
                top: scaledY1,
                width: scaledWidth,
                height: scaledHeight,
                child: SelectableText(
                  line.text,
                  style: TextStyle(
                    color: Colors.transparent,
                    // 字体大小也需要根据缩放比例调整
                    fontSize: scaledHeight * 0.8,
                  ),
                  textAlign: TextAlign.left,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}