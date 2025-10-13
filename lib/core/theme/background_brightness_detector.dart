import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 背景图片亮度检测器
class BackgroundBrightnessDetector {
  BackgroundBrightnessDetector._();

  /// 从图片数据检测亮度
  /// 返回 true 表示背景是深色的（应使用深色模式）
  static Future<bool> isDarkBackground(Uint8List imageBytes) async {
    try {
      // 解码图片
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: 100, // 缩小尺寸以提高性能
        targetHeight: 100,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // 获取像素数据
      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return false;

      final pixels = byteData.buffer.asUint8List();
      
      // 采样计算平均亮度
      double totalLuminance = 0;
      int sampleCount = 0;
      
      // 每隔4个像素采样一次（RGBA格式）
      for (int i = 0; i < pixels.length; i += 16) {
        if (i + 2 >= pixels.length) break;
        
        final r = pixels[i];
        final g = pixels[i + 1];
        final b = pixels[i + 2];
        
        // 计算相对亮度（使用标准公式）
        final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
        totalLuminance += luminance;
        sampleCount++;
      }

      final averageLuminance = totalLuminance / sampleCount;
      
      // 如果平均亮度小于0.5，认为是深色背景
      return averageLuminance < 0.5;
    } catch (e) {
      debugPrint('Error detecting background brightness: $e');
      return false; // 出错时默认为浅色
    }
  }

  /// 获取推荐的主题模式
  static Future<ThemeMode> getRecommendedThemeMode(Uint8List? imageBytes) async {
    if (imageBytes == null) {
      return ThemeMode.system;
    }

    final isDark = await isDarkBackground(imageBytes);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// 计算图片的主色调
  static Future<Color?> getDominantColor(Uint8List imageBytes) async {
    try {
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: 50,
        targetHeight: 50,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return null;

      final pixels = byteData.buffer.asUint8List();
      
      // 计算平均颜色
      int totalR = 0, totalG = 0, totalB = 0;
      int count = 0;
      
      for (int i = 0; i < pixels.length; i += 4) {
        if (i + 2 >= pixels.length) break;
        
        totalR += pixels[i];
        totalG += pixels[i + 1];
        totalB += pixels[i + 2];
        count++;
      }

      if (count == 0) return null;

      return Color.fromARGB(
        255,
        totalR ~/ count,
        totalG ~/ count,
        totalB ~/ count,
      );
    } catch (e) {
      debugPrint('Error getting dominant color: $e');
      return null;
    }
  }
}

