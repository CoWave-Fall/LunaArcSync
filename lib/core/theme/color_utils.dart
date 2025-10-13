import 'package:flutter/material.dart';

/// 颜色工具类，用于计算合适的文字颜色
class ColorUtils {
  ColorUtils._();

  /// 计算颜色的亮度值（0-1）
  /// 使用相对亮度公式：https://www.w3.org/TR/WCAG20/#relativeluminancedef
  static double calculateLuminance(Color color) {
    return color.computeLuminance();
  }

  /// 根据背景颜色判断应该使用黑色还是白色文字
  /// 返回true表示应该使用白色文字，false表示应该使用黑色文字
  static bool shouldUseWhiteText(Color backgroundColor) {
    // 如果背景亮度低于0.5，使用白色文字；否则使用黑色文字
    return calculateLuminance(backgroundColor) < 0.5;
  }

  /// 根据背景颜色获取合适的文字颜色
  static Color getContrastTextColor(Color backgroundColor) {
    return shouldUseWhiteText(backgroundColor) 
        ? Colors.white 
        : Colors.black;
  }

  /// 根据背景颜色获取合适的文字颜色（带透明度）
  static Color getContrastTextColorWithOpacity(
    Color backgroundColor, 
    double opacity,
  ) {
    final baseColor = getContrastTextColor(backgroundColor);
    return baseColor.withOpacity(opacity);
  }

  /// 为毛玻璃效果获取合适的文字颜色
  /// 考虑了毛玻璃的透明度和背景颜色
  static Color getTextColorForGlassmorphism(
    BuildContext context,
    Color surfaceColor,
    double surfaceOpacity,
  ) {
    // 获取主题的表面颜色
    final theme = Theme.of(context);
    
    // 如果表面不透明度很高（>0.7），主要考虑表面颜色
    if (surfaceOpacity > 0.7) {
      return getContrastTextColor(surfaceColor);
    }
    
    // 否则使用主题的默认文字颜色（会根据主题自动调整）
    return theme.colorScheme.onSurface;
  }

  /// 混合两种颜色
  static Color blendColors(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }

  /// 获取颜色的深色版本（降低亮度）
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final newLightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// 获取颜色的浅色版本（提高亮度）
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// 判断颜色是否为"深色"
  static bool isDark(Color color) {
    return calculateLuminance(color) < 0.5;
  }

  /// 判断颜色是否为"浅色"
  static bool isLight(Color color) {
    return !isDark(color);
  }

  /// 为背景图片上的文字添加阴影，提高可读性
  static List<Shadow> getTextShadowsForBackground({
    Color backgroundColor = Colors.black,
    double blurRadius = 4.0,
    double opacity = 0.7,
  }) {
    return [
      Shadow(
        offset: const Offset(0, 1),
        blurRadius: blurRadius,
        color: backgroundColor.withOpacity(opacity),
      ),
      Shadow(
        offset: const Offset(0, -1),
        blurRadius: blurRadius,
        color: backgroundColor.withOpacity(opacity),
      ),
      Shadow(
        offset: const Offset(1, 0),
        blurRadius: blurRadius,
        color: backgroundColor.withOpacity(opacity),
      ),
      Shadow(
        offset: const Offset(-1, 0),
        blurRadius: blurRadius,
        color: backgroundColor.withOpacity(opacity),
      ),
    ];
  }

  /// 为毛玻璃背景上的文字获取TextStyle
  /// 这会自动根据背景亮度选择合适的文字颜色和阴影
  static TextStyle? getTextStyleForGlassmorphism(
    BuildContext context, {
    TextStyle? baseStyle,
    bool addShadow = false,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // 在毛玻璃上，文字应该与主题保持一致
    // 但可以添加轻微的阴影来提高可读性
    if (addShadow) {
      return baseStyle?.copyWith(
        shadows: getTextShadowsForBackground(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          blurRadius: 2.0,
          opacity: 0.3,
        ),
      );
    }
    
    return baseStyle;
  }
}

