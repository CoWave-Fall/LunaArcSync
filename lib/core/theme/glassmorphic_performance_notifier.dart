import 'package:flutter/foundation.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/effects/kawase_blur.dart';

/// 毛玻璃性能配置枚举
enum GlassmorphicPerformanceLevel {
  disabled,    // 禁用毛玻璃效果
  low,         // 低性能模式（轻微模糊）
  medium,      // 中等性能模式（标准模糊）
  high,        // 高性能模式（强模糊）
  custom,      // 自定义模式
}

/// 毛玻璃性能配置数据类
class GlassmorphicPerformanceConfig {
  final GlassmorphicPerformanceLevel level;
  final double blurIntensity;      // 模糊强度 (0.0 - 1.0)
  final double opacityIntensity;   // 不透明度强度 (0.0 - 1.0)
  final bool useSharedBlur;        // 是否使用共享模糊
  final bool enableListOptimization; // 是否启用列表优化
  final int maxListItems;          // 最大列表项数量（超过此数量将降低效果）
  final BlurMethod blurMethod;     // 模糊方法
  final KawaseBlurPreset kawasePreset; // Kawase模糊预设

  const GlassmorphicPerformanceConfig({
    this.level = GlassmorphicPerformanceLevel.medium,
    this.blurIntensity = 0.7,
    this.opacityIntensity = 0.6,
    this.useSharedBlur = true,
    this.enableListOptimization = true,
    this.maxListItems = 30,
    this.blurMethod = BlurMethod.gaussian,
    this.kawasePreset = KawaseBlurPreset.medium,
  });

  GlassmorphicPerformanceConfig copyWith({
    GlassmorphicPerformanceLevel? level,
    double? blurIntensity,
    double? opacityIntensity,
    bool? useSharedBlur,
    bool? enableListOptimization,
    int? maxListItems,
    BlurMethod? blurMethod,
    KawaseBlurPreset? kawasePreset,
  }) {
    return GlassmorphicPerformanceConfig(
      level: level ?? this.level,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      opacityIntensity: opacityIntensity ?? this.opacityIntensity,
      useSharedBlur: useSharedBlur ?? this.useSharedBlur,
      enableListOptimization: enableListOptimization ?? this.enableListOptimization,
      maxListItems: maxListItems ?? this.maxListItems,
      blurMethod: blurMethod ?? this.blurMethod,
      kawasePreset: kawasePreset ?? this.kawasePreset,
    );
  }

  /// 根据性能等级获取预设配置
  static GlassmorphicPerformanceConfig getPresetConfig(GlassmorphicPerformanceLevel level) {
    switch (level) {
      case GlassmorphicPerformanceLevel.disabled:
        return const GlassmorphicPerformanceConfig(
          level: GlassmorphicPerformanceLevel.disabled,
          blurIntensity: 0.0,
          opacityIntensity: 0.0,
          useSharedBlur: false,
          enableListOptimization: false,
          maxListItems: 0,
          blurMethod: BlurMethod.gaussian,
          kawasePreset: KawaseBlurPreset.light,
        );
      case GlassmorphicPerformanceLevel.low:
        return const GlassmorphicPerformanceConfig(
          level: GlassmorphicPerformanceLevel.low,
          blurIntensity: 0.3,
          opacityIntensity: 0.3,
          useSharedBlur: true,
          enableListOptimization: true,
          maxListItems: 20,
          blurMethod: BlurMethod.kawase,
          kawasePreset: KawaseBlurPreset.light,
        );
      case GlassmorphicPerformanceLevel.medium:
        return const GlassmorphicPerformanceConfig(
          level: GlassmorphicPerformanceLevel.medium,
          blurIntensity: 0.7,
          opacityIntensity: 0.6,
          useSharedBlur: true,
          enableListOptimization: true,
          maxListItems: 30,
          blurMethod: BlurMethod.kawase,
          kawasePreset: KawaseBlurPreset.medium,
        );
      case GlassmorphicPerformanceLevel.high:
        return const GlassmorphicPerformanceConfig(
          level: GlassmorphicPerformanceLevel.high,
          blurIntensity: 1.0,
          opacityIntensity: 0.8,
          useSharedBlur: true,
          enableListOptimization: true,
          maxListItems: 50,
          blurMethod: BlurMethod.kawase,
          kawasePreset: KawaseBlurPreset.strong,
        );
      case GlassmorphicPerformanceLevel.custom:
        return const GlassmorphicPerformanceConfig(
          level: GlassmorphicPerformanceLevel.custom,
          blurIntensity: 0.7,
          opacityIntensity: 0.6,
          useSharedBlur: true,
          enableListOptimization: true,
          maxListItems: 30,
          blurMethod: BlurMethod.gaussian,
          kawasePreset: KawaseBlurPreset.medium,
        );
    }
  }

  /// 获取实际的模糊值
  double getActualBlur(double baseBlur) {
    if (level == GlassmorphicPerformanceLevel.disabled) {
      return 0.0;
    }
    return baseBlur * blurIntensity;
  }

  /// 获取实际的不透明度值
  double getActualOpacity(double baseOpacity) {
    if (level == GlassmorphicPerformanceLevel.disabled) {
      return 0.0;
    }
    return baseOpacity * opacityIntensity;
  }

  /// 获取Kawase模糊配置
  KawaseBlurConfig getKawaseConfig() {
    final baseConfig = KawaseBlurConfig.getPresetConfig(kawasePreset);
    return baseConfig.adjustForPerformance(level);
  }

  /// 检查是否应该为列表项应用毛玻璃效果
  bool shouldApplyToListItem(int itemIndex, int totalItems) {
    if (level == GlassmorphicPerformanceLevel.disabled) {
      return false;
    }
    
    if (!enableListOptimization) {
      return true;
    }
    
    // 如果列表项过多，只对前几项应用效果
    if (totalItems > maxListItems) {
      return itemIndex < (maxListItems * 0.3).round();
    }
    
    return true;
  }

  /// 获取性能等级的描述
  String getLevelDescription() {
    switch (level) {
      case GlassmorphicPerformanceLevel.disabled:
        return '禁用毛玻璃效果，最佳性能';
      case GlassmorphicPerformanceLevel.low:
        return '低性能模式，轻微毛玻璃效果';
      case GlassmorphicPerformanceLevel.medium:
        return '平衡模式，标准毛玻璃效果';
      case GlassmorphicPerformanceLevel.high:
        return '高质量模式，强毛玻璃效果';
      case GlassmorphicPerformanceLevel.custom:
        return '自定义模式，用户自定义设置';
    }
  }
}

/// 毛玻璃性能配置通知器
class GlassmorphicPerformanceNotifier extends ChangeNotifier {
  GlassmorphicPerformanceConfig _config = GlassmorphicPerformanceConfig.getPresetConfig(
    GlassmorphicPerformanceLevel.medium,
  );

  GlassmorphicPerformanceConfig get config => _config;

  /// 设置性能等级
  void setPerformanceLevel(GlassmorphicPerformanceLevel level) {
    _config = GlassmorphicPerformanceConfig.getPresetConfig(level);
    notifyListeners();
  }

  /// 更新配置
  void updateConfig(GlassmorphicPerformanceConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }

  /// 更新模糊强度
  void updateBlurIntensity(double intensity) {
    _config = _config.copyWith(
      blurIntensity: intensity.clamp(0.0, 1.0),
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 更新不透明度强度
  void updateOpacityIntensity(double intensity) {
    _config = _config.copyWith(
      opacityIntensity: intensity.clamp(0.0, 1.0),
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 切换共享模糊
  void toggleSharedBlur() {
    _config = _config.copyWith(
      useSharedBlur: !_config.useSharedBlur,
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 切换列表优化
  void toggleListOptimization() {
    _config = _config.copyWith(
      enableListOptimization: !_config.enableListOptimization,
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 更新模糊方法
  void updateBlurMethod(BlurMethod blurMethod) {
    _config = _config.copyWith(
      blurMethod: blurMethod,
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 更新Kawase模糊预设
  void updateKawasePreset(KawaseBlurPreset preset) {
    _config = _config.copyWith(
      kawasePreset: preset,
      blurMethod: BlurMethod.kawase,
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 设置最大列表项数量
  void setMaxListItems(int maxItems) {
    _config = _config.copyWith(
      maxListItems: maxItems.clamp(0, 100),
      level: GlassmorphicPerformanceLevel.custom,
    );
    notifyListeners();
  }

  /// 重置为默认配置
  void resetToDefault() {
    _config = GlassmorphicPerformanceConfig.getPresetConfig(
      GlassmorphicPerformanceLevel.medium,
    );
    notifyListeners();
  }

  /// 检查是否应该应用毛玻璃效果
  bool shouldApplyGlassmorphic() {
    return _config.level != GlassmorphicPerformanceLevel.disabled;
  }

  /// 获取性能建议
  String getPerformanceAdvice() {
    if (_config.level == GlassmorphicPerformanceLevel.disabled) {
      return '毛玻璃效果已禁用，应用性能最佳';
    }
    
    if (_config.blurIntensity > 0.8 && _config.opacityIntensity > 0.7) {
      return '当前设置可能影响性能，建议降低模糊强度';
    }
    
    if (!_config.useSharedBlur) {
      return '建议启用共享模糊以提升性能';
    }
    
    if (!_config.enableListOptimization) {
      return '建议启用列表优化以提升长列表性能';
    }
    
    return '当前设置平衡了视觉效果和性能';
  }

  /// 预热毛玻璃缓存
  Future<void> warmupCache() async {
    final cache = GlassmorphicCache();
    cache.warmupCache();
  }

  /// 获取缓存统计信息
  Map<String, dynamic> getCacheStats() {
    final cache = GlassmorphicCache();
    return cache.getCacheStats();
  }

  /// 清理缓存
  void clearCache() {
    final cache = GlassmorphicCache();
    cache.clearCache();
  }
}


