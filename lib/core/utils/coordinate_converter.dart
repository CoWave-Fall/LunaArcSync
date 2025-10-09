import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';

/// 坐标转换工具类
/// 用于处理OCR边界框坐标在不同屏幕尺寸下的转换
class CoordinateConverter {
  /// 将边界框坐标转换为显示坐标
  static Offset convertToDisplayCoordinates(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
  ) {
    if (bbox.normalizedX1 != null && 
        bbox.normalizedY1 != null && 
        bbox.normalizedX2 != null && 
        bbox.normalizedY2 != null) {
      // 使用归一化坐标进行转换
      return Offset(
        bbox.normalizedX1! * displaySize.width,
        bbox.normalizedY1! * displaySize.height,
      );
    } else {
      // 使用绝对像素坐标进行转换
      final scaleX = displaySize.width / imageSize.width;
      final scaleY = displaySize.height / imageSize.height;
      return Offset(
        bbox.x1 * scaleX,
        bbox.y1 * scaleY,
      );
    }
  }

  /// 将边界框坐标转换为显示坐标（考虑FittedBox居中效果）
  static Offset convertToDisplayCoordinatesWithFittedBox(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
    Size containerSize,
  ) {
    // 计算FittedBox的实际缩放比例（始终使用较小的缩放比例保持宽高比）
    final scaleX = displaySize.width / imageSize.width;
    final scaleY = displaySize.height / imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    
    // 计算实际渲染后的图片尺寸和居中偏移
    final scaledImageWidth = imageSize.width * scale;
    final scaledImageHeight = imageSize.height * scale;
    final offsetX = (containerSize.width - scaledImageWidth) / 2;
    final offsetY = (containerSize.height - scaledImageHeight) / 2;
    
    if (bbox.normalizedX1 != null && 
        bbox.normalizedY1 != null && 
        bbox.normalizedX2 != null && 
        bbox.normalizedY2 != null) {
      // 使用归一化坐标：先转换为绝对坐标，再应用统一的缩放比例和偏移
      final x1 = bbox.normalizedX1! * imageSize.width;
      final y1 = bbox.normalizedY1! * imageSize.height;
      
      return Offset(
        x1 * scale + offsetX,
        y1 * scale + offsetY,
      );
    } else {
      // 使用绝对坐标：直接应用统一的缩放比例和偏移
      return Offset(
        bbox.x1 * scale + offsetX,
        bbox.y1 * scale + offsetY,
      );
    }
  }

  /// 将边界框尺寸转换为显示尺寸
  static Size convertToDisplaySize(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
  ) {
    if (bbox.normalizedX1 != null && 
        bbox.normalizedY1 != null && 
        bbox.normalizedX2 != null && 
        bbox.normalizedY2 != null) {
      // 使用归一化坐标进行转换
      return Size(
        (bbox.normalizedX2! - bbox.normalizedX1!) * displaySize.width,
        (bbox.normalizedY2! - bbox.normalizedY1!) * displaySize.height,
      );
    } else {
      // 使用绝对像素坐标进行转换
      final scaleX = displaySize.width / imageSize.width;
      final scaleY = displaySize.height / imageSize.height;
      return Size(
        (bbox.x2 - bbox.x1) * scaleX,
        (bbox.y2 - bbox.y1) * scaleY,
      );
    }
  }

  /// 将边界框尺寸转换为显示尺寸（考虑FittedBox居中效果）
  static Size convertToDisplaySizeWithFittedBox(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
    Size containerSize,
  ) {
    // 计算FittedBox的实际缩放比例（始终使用较小的缩放比例保持宽高比）
    final scaleX = displaySize.width / imageSize.width;
    final scaleY = displaySize.height / imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    
    if (bbox.normalizedX1 != null && 
        bbox.normalizedY1 != null && 
        bbox.normalizedX2 != null && 
        bbox.normalizedY2 != null) {
      // 使用归一化坐标：先转换为绝对坐标，再应用统一的缩放比例
      final bboxWidth = (bbox.normalizedX2! - bbox.normalizedX1!) * imageSize.width;
      final bboxHeight = (bbox.normalizedY2! - bbox.normalizedY1!) * imageSize.height;
      
      return Size(
        bboxWidth * scale,
        bboxHeight * scale,
      );
    } else {
      // 使用绝对坐标：直接应用统一的缩放比例
      return Size(
        (bbox.x2 - bbox.x1) * scale,
        (bbox.y2 - bbox.y1) * scale,
      );
    }
  }

  /// 将边界框转换为显示矩形
  static Rect convertToDisplayRect(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
  ) {
    final offset = convertToDisplayCoordinates(bbox, imageSize, displaySize);
    final size = convertToDisplaySize(bbox, imageSize, displaySize);
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }

  /// 将边界框转换为显示矩形（考虑FittedBox居中效果）
  static Rect convertToDisplayRectWithFittedBox(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
    Size containerSize,
  ) {
    final offset = convertToDisplayCoordinatesWithFittedBox(bbox, imageSize, displaySize, containerSize);
    final size = convertToDisplaySizeWithFittedBox(bbox, imageSize, displaySize, containerSize);
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }

  /// 计算字体大小，根据边界框高度自适应
  static double calculateFontSize(
    Bbox bbox,
    Size imageSize,
    Size displaySize, {
    double scaleFactor = 0.8,
  }) {
    final convertedSize = convertToDisplaySize(bbox, imageSize, displaySize);
    return convertedSize.height * scaleFactor;
  }

  /// 计算字体大小，根据边界框高度自适应（考虑FittedBox居中效果）
  static double calculateFontSizeWithFittedBox(
    Bbox bbox,
    Size imageSize,
    Size displaySize,
    Size containerSize, {
    double scaleFactor = 0.8,
  }) {
    // 计算FittedBox的实际缩放比例（始终使用较小的缩放比例保持宽高比）
    final scaleX = displaySize.width / imageSize.width;
    final scaleY = displaySize.height / imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    
    // 获取边界框的高度并应用统一的缩放比例
    double bboxHeight;
    if (bbox.normalizedY1 != null && bbox.normalizedY2 != null) {
      // 归一化坐标：先转换为绝对高度
      bboxHeight = (bbox.normalizedY2! - bbox.normalizedY1!) * imageSize.height;
    } else {
      // 绝对坐标：直接使用
      bboxHeight = (bbox.y2 - bbox.y1).toDouble();
    }
    
    return bboxHeight * scale * scaleFactor;
  }

  /// 检查坐标是否有效
  static bool isValidCoordinates(Bbox bbox) {
    if (bbox.normalizedX1 != null && 
        bbox.normalizedY1 != null && 
        bbox.normalizedX2 != null && 
        bbox.normalizedY2 != null) {
      // 检查归一化坐标是否在有效范围内
      return bbox.normalizedX1! >= 0 && bbox.normalizedX1! <= 1 &&
             bbox.normalizedY1! >= 0 && bbox.normalizedY1! <= 1 &&
             bbox.normalizedX2! >= 0 && bbox.normalizedX2! <= 1 &&
             bbox.normalizedY2! >= 0 && bbox.normalizedY2! <= 1 &&
             bbox.normalizedX2! > bbox.normalizedX1! &&
             bbox.normalizedY2! > bbox.normalizedY1!;
    } else {
      // 检查绝对像素坐标是否有效
      return bbox.x1 >= 0 && bbox.y1 >= 0 &&
             bbox.x2 > bbox.x1 && bbox.y2 > bbox.y1;
    }
  }
}
