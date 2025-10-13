import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:luna_arc_sync/core/theme/background_brightness_detector.dart';

@injectable
class BackgroundImageNotifier extends ChangeNotifier {
  Uint8List? _backgroundImageBytes;
  bool _isCustomBackgroundEnabled = false;
  bool _autoThemeSwitchEnabled = false;
  bool _isBackgroundDark = false;
  ThemeMode? _recommendedThemeMode;

  BackgroundImageNotifier() {
    _loadBackgroundImage();
  }

  Uint8List? get backgroundImageBytes => _backgroundImageBytes;
  bool get isCustomBackgroundEnabled => _isCustomBackgroundEnabled;
  bool get hasCustomBackground => _backgroundImageBytes != null && _isCustomBackgroundEnabled;
  bool get autoThemeSwitchEnabled => _autoThemeSwitchEnabled;
  bool get isBackgroundDark => _isBackgroundDark;
  ThemeMode? get recommendedThemeMode => _recommendedThemeMode;

  Future<void> _loadBackgroundImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isCustomBackgroundEnabled = prefs.getBool('custom_background_enabled') ?? false;
      _autoThemeSwitchEnabled = prefs.getBool('auto_theme_switch_enabled') ?? false;
      
      if (_isCustomBackgroundEnabled) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = path.join(directory.path, 'background_image.jpg');
        final imageFile = File(imagePath);
        
        if (await imageFile.exists()) {
          _backgroundImageBytes = await imageFile.readAsBytes();
          await _analyzeBackgroundBrightness();
        } else {
          _isCustomBackgroundEnabled = false;
          await prefs.setBool('custom_background_enabled', false);
        }
      }
    } catch (e) {
      debugPrint('Error loading background image: $e');
      _isCustomBackgroundEnabled = false;
      _backgroundImageBytes = null;
    }
    notifyListeners();
  }

  /// 分析背景图片的亮度
  Future<void> _analyzeBackgroundBrightness() async {
    if (_backgroundImageBytes == null) return;

    try {
      _isBackgroundDark = await BackgroundBrightnessDetector.isDarkBackground(_backgroundImageBytes!);
      _recommendedThemeMode = await BackgroundBrightnessDetector.getRecommendedThemeMode(_backgroundImageBytes);
      debugPrint('Background is dark: $_isBackgroundDark, recommended theme: $_recommendedThemeMode');
    } catch (e) {
      debugPrint('Error analyzing background brightness: $e');
    }
  }

  Future<bool> setBackgroundImage(Uint8List imageBytes) async {
    try {
      debugPrint('Setting background image, size: ${imageBytes.length} bytes');
      
      final directory = await getApplicationDocumentsDirectory();
      debugPrint('Document directory: ${directory.path}');
      
      final imagePath = path.join(directory.path, 'background_image.jpg');
      final imageFile = File(imagePath);
      
      debugPrint('Writing to: $imagePath');
      await imageFile.writeAsBytes(imageBytes);
      
      debugPrint('File written successfully');
      
      // 验证文件是否真的写入成功
      if (await imageFile.exists()) {
        final fileSize = await imageFile.length();
        debugPrint('File verified, size: $fileSize bytes');
        
        _backgroundImageBytes = imageBytes;
        _isCustomBackgroundEnabled = true;
        
        // 分析背景亮度
        await _analyzeBackgroundBrightness();
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('custom_background_enabled', true);
        debugPrint('Preferences saved');
        
        notifyListeners();
        debugPrint('Listeners notified');
        return true;
      } else {
        debugPrint('Error: File was not created');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error setting background image: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<void> removeBackgroundImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, 'background_image.jpg');
      final imageFile = File(imagePath);
      
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
      _backgroundImageBytes = null;
      _isCustomBackgroundEnabled = false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('custom_background_enabled', false);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing background image: $e');
    }
  }

  Future<void> toggleBackgroundEnabled(bool enabled) async {
    _isCustomBackgroundEnabled = enabled && _backgroundImageBytes != null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('custom_background_enabled', _isCustomBackgroundEnabled);
    
    notifyListeners();
  }

  /// 切换自动主题切换功能
  Future<void> toggleAutoThemeSwitch(bool enabled) async {
    _autoThemeSwitchEnabled = enabled;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_theme_switch_enabled', enabled);
    
    notifyListeners();
  }
}

