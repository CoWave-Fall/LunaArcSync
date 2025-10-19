import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PDF背景颜色配置
class PdfBackgroundConfig {
  static const String _lightColorKey = 'pdf_background_light_color';
  static const String _darkColorKey = 'pdf_background_dark_color';
  static const String _enableBlurKey = 'pdf_background_enable_blur';
  
  // 默认颜色
  static const Color defaultLightColor = Color(0xFFFFFFFF); // 纯白
  static const Color defaultDarkColor = Color(0xFF000000); // 纯黑
  
  /// 保存浅色模式背景颜色
  static Future<void> saveLightColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lightColorKey, color.value);
  }
  
  /// 保存深色模式背景颜色
  static Future<void> saveDarkColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_darkColorKey, color.value);
  }
  
  /// 获取浅色模式背景颜色
  static Future<Color> getLightColor() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_lightColorKey);
    return value != null ? Color(value) : defaultLightColor;
  }
  
  /// 获取深色模式背景颜色
  static Future<Color> getDarkColor() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_darkColorKey);
    return value != null ? Color(value) : defaultDarkColor;
  }
  
  /// 保存是否启用毛玻璃效果
  static Future<void> saveEnableBlur(bool enable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enableBlurKey, enable);
  }
  
  /// 获取是否启用毛玻璃效果
  static Future<bool> getEnableBlur() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enableBlurKey) ?? false;
  }
  
  /// 重置为默认颜色
  static Future<void> resetToDefaults() async {
    await saveLightColor(defaultLightColor);
    await saveDarkColor(defaultDarkColor);
    await saveEnableBlur(false);
  }
}

/// PDF背景颜色预设
class PdfBackgroundPreset {
  final String name;
  final Color lightColor;
  final Color darkColor;
  final String description;
  final IconData icon;
  
  const PdfBackgroundPreset({
    required this.name,
    required this.lightColor,
    required this.darkColor,
    required this.description,
    required this.icon,
  });
}

/// PDF背景颜色预设集合
class PdfBackgroundPresets {
  static const List<PdfBackgroundPreset> presets = [
    // 经典黑白
    PdfBackgroundPreset(
      name: '经典',
      lightColor: Color(0xFFFFFFFF), // 纯白
      darkColor: Color(0xFF000000), // 纯黑
      description: '纯白/纯黑，最佳对比度',
      icon: Icons.contrast,
    ),
    
    // 柔和米白/深灰
    PdfBackgroundPreset(
      name: '柔和',
      lightColor: Color(0xFFF5F5F0), // 米白色
      darkColor: Color(0xFF1A1A1A), // 深灰色
      description: '舒适的阅读体验',
      icon: Icons.wb_sunny_outlined,
    ),
    
    // 护眼黄/暖黑
    PdfBackgroundPreset(
      name: '护眼',
      lightColor: Color(0xFFFFF8DC), // 玉米丝色
      darkColor: Color(0xFF2B2520), // 暖黑色
      description: '减少眼睛疲劳',
      icon: Icons.remove_red_eye_outlined,
    ),
    
    // 纸质感
    PdfBackgroundPreset(
      name: '纸张',
      lightColor: Color(0xFFFFFAF0), // 花白色
      darkColor: Color(0xFF1C1814), // 深棕黑
      description: '模拟真实纸张',
      icon: Icons.description_outlined,
    ),
    
    // 冷色调
    PdfBackgroundPreset(
      name: '冷色',
      lightColor: Color(0xFFF0F8FF), // 爱丽丝蓝
      darkColor: Color(0xFF0D1117), // 深蓝黑
      description: '清爽的冷色调',
      icon: Icons.ac_unit,
    ),
    
    // 暖色调
    PdfBackgroundPreset(
      name: '暖色',
      lightColor: Color(0xFFFFF5EE), // 海贝壳色
      darkColor: Color(0xFF1A1510), // 暖黑色
      description: '温暖的暖色调',
      icon: Icons.wb_incandescent_outlined,
    ),
    
    // 高对比度
    PdfBackgroundPreset(
      name: '高对比',
      lightColor: Color(0xFFFFFFFF), // 纯白
      darkColor: Color(0xFF0A0A0A), // 极深黑
      description: '最高对比度',
      icon: Icons.brightness_high,
    ),
    
    // 低对比度
    PdfBackgroundPreset(
      name: '低对比',
      lightColor: Color(0xFFE8E8E8), // 浅灰
      darkColor: Color(0xFF282828), // 中灰黑
      description: '柔和的对比度',
      icon: Icons.brightness_low,
    ),
    
    // 绿色护眼
    PdfBackgroundPreset(
      name: '绿色',
      lightColor: Color(0xFFE8F5E8), // 淡绿色
      darkColor: Color(0xFF1A2F1A), // 深绿黑
      description: '护眼绿色系',
      icon: Icons.eco_outlined,
    ),
    
    // 透明（与应用背景融合）
    PdfBackgroundPreset(
      name: '透明',
      lightColor: Color(0x00FFFFFF), // 全透明
      darkColor: Color(0x00000000), // 全透明
      description: '使用应用背景',
      icon: Icons.layers_clear,
    ),
    
    // 半透明
    PdfBackgroundPreset(
      name: '半透明',
      lightColor: Color(0x80FFFFFF), // 50%白色
      darkColor: Color(0x80000000), // 50%黑色
      description: '半透明效果',
      icon: Icons.opacity,
    ),
    
    // 琥珀色
    PdfBackgroundPreset(
      name: '琥珀',
      lightColor: Color(0xFFFFF8E1), // 琥珀浅色
      darkColor: Color(0xFF2C2416), // 琥珀深色
      description: '温暖的琥珀色',
      icon: Icons.wb_twilight,
    ),
  ];
  
  /// 根据名称获取预设
  static PdfBackgroundPreset? getPresetByName(String name) {
    try {
      return presets.firstWhere((p) => p.name == name);
    } catch (e) {
      return null;
    }
  }
  
  /// 检查颜色是否匹配某个预设
  static PdfBackgroundPreset? matchPreset(Color lightColor, Color darkColor) {
    for (final preset in presets) {
      if (preset.lightColor.value == lightColor.value &&
          preset.darkColor.value == darkColor.value) {
        return preset;
      }
    }
    return null;
  }
}

