import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@injectable
class ThemeColorNotifier extends ChangeNotifier {
  Color _themeColor = Colors.cyan;

  ThemeColorNotifier() {
    _loadThemeColor();
  }

  Color get themeColor => _themeColor;

  // 预设的主题颜色选项
  static const List<ColorOption> availableColors = [
    ColorOption(name: '青色 / Cyan', color: Colors.cyan),
    ColorOption(name: '蓝色 / Blue', color: Colors.blue),
    ColorOption(name: '紫色 / Purple', color: Colors.purple),
    ColorOption(name: '深紫色 / Deep Purple', color: Colors.deepPurple),
    ColorOption(name: '靛蓝色 / Indigo', color: Colors.indigo),
    ColorOption(name: '绿色 / Green', color: Colors.green),
    ColorOption(name: '浅绿色 / Light Green', color: Colors.lightGreen),
    ColorOption(name: '橙色 / Orange', color: Colors.orange),
    ColorOption(name: '深橙色 / Deep Orange', color: Colors.deepOrange),
    ColorOption(name: '红色 / Red', color: Colors.red),
    ColorOption(name: '粉色 / Pink', color: Colors.pink),
    ColorOption(name: '青柠色 / Lime', color: Colors.lime),
    ColorOption(name: '黄色 / Yellow', color: Colors.yellow),
    ColorOption(name: '琥珀色 / Amber', color: Colors.amber),
    ColorOption(name: '棕色 / Brown', color: Colors.brown),
    ColorOption(name: '蓝灰色 / Blue Grey', color: Colors.blueGrey),
  ];

  Future<void> _loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('themeColor');
    if (colorValue != null) {
      _themeColor = Color(colorValue);
    } else {
      _themeColor = Colors.cyan; // 默认颜色
    }
    notifyListeners();
  }

  Future<void> setThemeColor(Color newColor) async {
    if (_themeColor == newColor) return;
    _themeColor = newColor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', newColor.value);
    notifyListeners();
  }

  // 根据颜色值查找对应的名称
  String getColorName() {
    for (final colorOption in availableColors) {
      if (colorOption.color.value == _themeColor.value) {
        return colorOption.name;
      }
    }
    return '自定义颜色 / Custom';
  }
}

class ColorOption {
  final String name;
  final Color color;

  const ColorOption({
    required this.name,
    required this.color,
  });
}

