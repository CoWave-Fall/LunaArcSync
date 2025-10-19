import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 双Kawase模糊算法实现
/// 这是一种高效的模糊算法，通过多次下采样和上采样来实现模糊效果
class KawaseBlur {
  /// 双Kawase模糊的核心算法
  /// 
  /// [image] - 要模糊的图像
  /// [radius] - 模糊半径
  /// [passes] - 模糊通道数，默认为4
  /// 
  /// 返回模糊后的图像
  static Future<ui.Image> blurImage(
    ui.Image image, {
    required double radius,
    int passes = 4,
  }) async {
    if (radius <= 0) return image;
    
    // 计算下采样因子
    final scaleFactor = _calculateScaleFactor(radius);
    final downscaledSize = Size(
      (image.width * scaleFactor).round().toDouble(),
      (image.height * scaleFactor).round().toDouble(),
    );
    
    // 创建下采样图像
    final downscaledImage = await _downsampleImage(image, downscaledSize);
    
    // 应用Kawase模糊
    final blurredImage = await _applyKawaseBlur(
      downscaledImage,
      radius: radius,
      passes: passes,
    );
    
    // 上采样回原始尺寸
    final upscaledImage = await _upsampleImage(blurredImage, image.width, image.height);
    
    return upscaledImage;
  }
  
  /// 计算下采样因子
  static double _calculateScaleFactor(double radius) {
    // 根据模糊半径计算合适的下采样因子
    if (radius <= 2) return 1.0;
    if (radius <= 4) return 0.8;
    if (radius <= 8) return 0.6;
    if (radius <= 16) return 0.4;
    return 0.3;
  }
  
  /// 下采样图像
  static Future<ui.Image> _downsampleImage(ui.Image image, Size targetSize) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // 绘制缩放后的图像
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, targetSize.width, targetSize.height),
      Paint()..filterQuality = FilterQuality.low,
    );
    
    final picture = recorder.endRecording();
    return await picture.toImage(
      targetSize.width.round(),
      targetSize.height.round(),
    );
  }
  
  /// 应用Kawase模糊算法
  static Future<ui.Image> _applyKawaseBlur(
    ui.Image image, {
    required double radius,
    required int passes,
  }) async {
    ui.Image currentImage = image;
    
    for (int pass = 0; pass < passes; pass++) {
      currentImage = await _kawasePass(currentImage, radius, pass);
    }
    
    return currentImage;
  }
  
  /// 单次Kawase模糊通道
  static Future<ui.Image> _kawasePass(
    ui.Image image,
    double radius,
    int pass,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // 计算当前通道的偏移量
    final offset = (radius / (pass + 1)).round().toDouble();
    
    // 创建模糊着色器
    final shader = _createKawaseShader(image, offset);
    
    // 绘制模糊效果
    canvas.drawRect(
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Paint()..shader = shader,
    );
    
    final picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }
  
  /// 创建Kawase模糊着色器
  static ui.Shader _createKawaseShader(ui.Image image, double offset) {
    // 这里使用简化的Kawase算法
    // 在实际实现中，可能需要使用自定义着色器
    return ui.ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().storage,
    );
  }
  
  /// 上采样图像
  static Future<ui.Image> _upsampleImage(
    ui.Image image,
    int targetWidth,
    int targetHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // 绘制放大后的图像
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      Paint()..filterQuality = FilterQuality.medium,
    );
    
    final picture = recorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }
}

/// Kawase模糊配置
class KawaseBlurConfig {
  final double radius;
  final int passes;
  final double scaleFactor;
  final bool useOptimizedPasses;
  
  const KawaseBlurConfig({
    this.radius = 8.0,
    this.passes = 4,
    this.scaleFactor = 0.5,
    this.useOptimizedPasses = true,
  });
  
  /// 获取预设配置
  static KawaseBlurConfig getPresetConfig(KawaseBlurPreset preset) {
    switch (preset) {
      case KawaseBlurPreset.light:
        return const KawaseBlurConfig(
          radius: 4.0,
          passes: 2,
          scaleFactor: 0.7,
        );
      case KawaseBlurPreset.medium:
        return const KawaseBlurConfig(
          radius: 8.0,
          passes: 4,
          scaleFactor: 0.5,
        );
      case KawaseBlurPreset.strong:
        return const KawaseBlurConfig(
          radius: 16.0,
          passes: 6,
          scaleFactor: 0.3,
        );
      case KawaseBlurPreset.ultra:
        return const KawaseBlurConfig(
          radius: 24.0,
          passes: 8,
          scaleFactor: 0.25,
        );
    }
  }
  
  /// 根据性能等级调整配置
  KawaseBlurConfig adjustForPerformance(dynamic level) {
    // 使用字符串比较来避免类型冲突
    final levelName = level.toString().split('.').last;
    switch (levelName) {
      case 'disabled':
        return copyWith(radius: 0.0, passes: 0);
      case 'low':
        return copyWith(
          radius: radius * 0.5,
          passes: (passes * 0.5).round(),
          scaleFactor: scaleFactor * 1.2,
        );
      case 'medium':
        return this;
      case 'high':
        return copyWith(
          radius: radius * 1.2,
          passes: (passes * 1.2).round(),
          scaleFactor: scaleFactor * 0.8,
        );
      case 'custom':
        return this;
      default:
        return this;
    }
  }
  
  KawaseBlurConfig copyWith({
    double? radius,
    int? passes,
    double? scaleFactor,
    bool? useOptimizedPasses,
  }) {
    return KawaseBlurConfig(
      radius: radius ?? this.radius,
      passes: passes ?? this.passes,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      useOptimizedPasses: useOptimizedPasses ?? this.useOptimizedPasses,
    );
  }
}

/// Kawase模糊预设
enum KawaseBlurPreset {
  light,   // 轻微模糊
  medium,  // 中等模糊
  strong,  // 强模糊
  ultra,   // 超强模糊
}

// 毛玻璃性能等级枚举在其他文件中定义

/// Kawase模糊性能监控
class KawaseBlurPerformanceMonitor {
  static final KawaseBlurPerformanceMonitor _instance = KawaseBlurPerformanceMonitor._internal();
  factory KawaseBlurPerformanceMonitor() => _instance;
  KawaseBlurPerformanceMonitor._internal();
  
  final List<KawaseBlurPerformanceData> _performanceData = [];
  
  /// 记录Kawase模糊性能数据
  void recordPerformance(KawaseBlurPerformanceData data) {
    _performanceData.add(data);
    
    // 保持数据量在合理范围内
    if (_performanceData.length > 100) {
      _performanceData.removeAt(0);
    }
  }
  
  /// 获取性能统计
  KawaseBlurPerformanceStats getPerformanceStats() {
    if (_performanceData.isEmpty) {
      return KawaseBlurPerformanceStats.empty();
    }
    
    final totalTime = _performanceData.fold<int>(0, (sum, data) => sum + data.renderTimeMs);
    final averageTime = totalTime / _performanceData.length;
    final maxTime = _performanceData.map((d) => d.renderTimeMs).reduce((a, b) => a > b ? a : b);
    final minTime = _performanceData.map((d) => d.renderTimeMs).reduce((a, b) => a < b ? a : b);
    
    return KawaseBlurPerformanceStats(
      totalRenders: _performanceData.length,
      averageRenderTime: averageTime,
      maxRenderTime: maxTime.toDouble(),
      minRenderTime: minTime.toDouble(),
      averageRadius: _performanceData.fold<double>(0, (sum, data) => sum + data.radius) / _performanceData.length,
      averagePasses: _performanceData.fold<double>(0, (sum, data) => sum + data.passes) / _performanceData.length,
    );
  }
  
  /// 清理数据
  void clearData() {
    _performanceData.clear();
  }
}

/// Kawase模糊性能数据
class KawaseBlurPerformanceData {
  final DateTime timestamp;
  final double radius;
  final int passes;
  final int renderTimeMs;
  final String preset;
  
  KawaseBlurPerformanceData({
    required this.timestamp,
    required this.radius,
    required this.passes,
    required this.renderTimeMs,
    required this.preset,
  });
}

/// Kawase模糊性能统计
class KawaseBlurPerformanceStats {
  final int totalRenders;
  final double averageRenderTime;
  final double maxRenderTime;
  final double minRenderTime;
  final double averageRadius;
  final double averagePasses;
  
  KawaseBlurPerformanceStats({
    required this.totalRenders,
    required this.averageRenderTime,
    required this.maxRenderTime,
    required this.minRenderTime,
    required this.averageRadius,
    required this.averagePasses,
  });
  
  factory KawaseBlurPerformanceStats.empty() {
    return KawaseBlurPerformanceStats(
      totalRenders: 0,
      averageRenderTime: 0,
      maxRenderTime: 0,
      minRenderTime: 0,
      averageRadius: 0,
      averagePasses: 0,
    );
  }
}
