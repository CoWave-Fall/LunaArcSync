/// 毛玻璃效果常量配置
/// 
/// 提供毛玻璃效果的各种预设值和配置常量
class GlassmorphicConstants {
  // 防止实例化
  GlassmorphicConstants._();

  // ========== 模糊强度预设 ==========
  
  /// 轻度模糊强度（适合小组件或性能受限设备）
  static const double lightBlur = 5.0;
  
  /// 中度模糊强度（默认推荐值）
  static const double mediumBlur = 10.0;
  
  /// 重度模糊强度（适合强调效果）
  static const double heavyBlur = 15.0;
  
  /// 超重模糊强度（适合特殊场景）
  static const double ultraBlur = 20.0;

  // ========== 不透明度预设 ==========
  
  /// 轻微不透明度
  static const double lightOpacity = 0.05;
  
  /// 标准不透明度
  static const double standardOpacity = 0.1;
  
  /// 中等不透明度
  static const double mediumOpacity = 0.15;
  
  /// 较强不透明度
  static const double heavyOpacity = 0.2;

  // ========== 圆角半径预设 ==========
  
  /// 小圆角
  static const double smallRadius = 8.0;
  
  /// 标准圆角
  static const double standardRadius = 12.0;
  
  /// 大圆角
  static const double largeRadius = 16.0;

  // ========== 间距预设 ==========
  
  /// 小间距
  static const double smallPadding = 12.0;
  
  /// 标准间距
  static const double standardPadding = 16.0;
  
  /// 大间距
  static const double largePadding = 20.0;

  // ========== 性能相关 ==========
  
  /// 低端设备的模糊强度系数
  static const double lowEndDeviceBlurFactor = 0.6;
  
  /// 长列表的模糊强度系数（50+项）
  static const double longListBlurFactor = 0.7;
  
  /// 中等列表的模糊强度系数（20-50项）
  static const double mediumListBlurFactor = 0.8;
  
  /// 列表项数阈值：中等列表
  static const int mediumListThreshold = 20;
  
  /// 列表项数阈值：长列表
  static const int longListThreshold = 50;

  // ========== 边框相关 ==========
  
  /// 默认边框宽度
  static const double defaultBorderWidth = 1.0;
  
  /// 默认边框不透明度
  static const double defaultBorderOpacity = 0.2;

  // ========== 阴影相关 ==========
  
  /// 文字阴影模糊半径
  static const double textShadowBlurRadius = 2.0;
  
  /// 文字阴影不透明度
  static const double textShadowOpacity = 0.3;

  // ========== 辅助方法 ==========
  
  /// 根据设备性能调整模糊强度
  /// 
  /// [baseBlur] 基础模糊强度
  /// [isLowEndDevice] 是否为低端设备
  /// 返回调整后的模糊强度
  static double getAdjustedBlur(double baseBlur, {bool isLowEndDevice = false}) {
    if (isLowEndDevice) {
      return baseBlur * lowEndDeviceBlurFactor;
    }
    return baseBlur;
  }
  
  /// 根据列表长度调整模糊强度
  /// 
  /// [baseBlur] 基础模糊强度
  /// [listLength] 列表长度
  /// 返回调整后的模糊强度
  static double getListAdjustedBlur(double baseBlur, int listLength) {
    if (listLength > longListThreshold) {
      return baseBlur * longListBlurFactor;
    } else if (listLength > mediumListThreshold) {
      return baseBlur * mediumListBlurFactor;
    }
    return baseBlur;
  }
}

