import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@injectable
class FontNotifier extends ChangeNotifier {
  String _selectedFont = 'LXGWWenKaiMono';
  
  FontNotifier() {
    _loadFont();
  }

  String get selectedFont => _selectedFont;

  // 可用的字体列表
  static const List<FontOption> availableFonts = [
    FontOption(
      name: 'LXGWWenKaiMono',
      displayName: '霞鹜文楷等宽',
      fontFamily: 'LXGWWenKaiMono',
    ),
    FontOption(
      name: 'System',
      displayName: '系统默认',
      fontFamily: null,
    ),
  ];

  Future<void> _loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFont = prefs.getString('selectedFont');
    if (savedFont != null && availableFonts.any((font) => font.name == savedFont)) {
      _selectedFont = savedFont;
    } else {
      _selectedFont = 'LXGWWenKaiMono'; // 默认字体
    }
    notifyListeners();
  }

  Future<void> setFont(String fontName) async {
    if (_selectedFont == fontName) return;
    
    if (availableFonts.any((font) => font.name == fontName)) {
      _selectedFont = fontName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedFont', fontName);
      notifyListeners();
    }
  }

  // 获取当前字体的TextStyle
  TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    final fontOption = availableFonts.firstWhere(
      (font) => font.name == _selectedFont,
      orElse: () => availableFonts.first,
    );

    return TextStyle(
      fontFamily: fontOption.fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // 获取字体显示名称
  String getFontDisplayName() {
    final fontOption = availableFonts.firstWhere(
      (font) => font.name == _selectedFont,
      orElse: () => availableFonts.first,
    );
    return fontOption.displayName;
  }
}

class FontOption {
  final String name;
  final String displayName;
  final String? fontFamily;

  const FontOption({
    required this.name,
    required this.displayName,
    this.fontFamily,
  });
}
