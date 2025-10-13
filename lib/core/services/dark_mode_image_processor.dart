import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 暗色模式图像处理器
/// 用于将PDF渲染图像转换为适合暗色模式显示的效果
class DarkModeImageProcessor {
  static int _blackThreshold = 180; // Adjustable threshold for dark text detection (lowered for better text capture)
  static int _whiteThreshold = 15; // Adjustable threshold for white detection
  static double _darkenFactor = 0.7; // Adjustable factor for darkening other colors
  static double _lightenFactor = 0.3; // Adjustable factor for lightening other colors
  static bool _initialized = false;
  
  // Getters for settings
  static int get blackThreshold => _blackThreshold;
  static int get whiteThreshold => _whiteThreshold;
  static double get darkenFactor => _darkenFactor;
  static double get lightenFactor => _lightenFactor;
  
  // Setters for settings
  static void setBlackThreshold(int value) {
    _blackThreshold = value.clamp(0, 255);
    _saveSettings();
  }
  
  static void setWhiteThreshold(int value) {
    _whiteThreshold = value.clamp(0, 255);
    _saveSettings();
  }
  
  static void setDarkenFactor(double value) {
    _darkenFactor = value.clamp(0.0, 1.0);
    _saveSettings();
  }
  
  static void setLightenFactor(double value) {
    _lightenFactor = value.clamp(0.0, 1.0);
    _saveSettings();
  }
  
  // Initialize settings from storage
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _blackThreshold = prefs.getInt('dark_mode_black_threshold') ?? 180;
      _whiteThreshold = prefs.getInt('dark_mode_white_threshold') ?? 15;
      _darkenFactor = prefs.getDouble('dark_mode_darken_factor') ?? 0.7;
      _lightenFactor = prefs.getDouble('dark_mode_lighten_factor') ?? 0.3;
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading dark mode settings: $e');
      }
    }
  }
  
  // Save settings to storage
  static Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dark_mode_black_threshold', _blackThreshold);
      await prefs.setInt('dark_mode_white_threshold', _whiteThreshold);
      await prefs.setDouble('dark_mode_darken_factor', _darkenFactor);
      await prefs.setDouble('dark_mode_lighten_factor', _lightenFactor);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving dark mode settings: $e');
      }
    }
  }
  
  static Future<Uint8List> processImageForDarkMode(Uint8List imageBytes) async {
    // Initialize settings if not already done
    await initialize();
    
    if (kDebugMode) {
      print('DarkModeImageProcessor: Processing image for dark mode');
      print('Black threshold: $_blackThreshold, White threshold: $_whiteThreshold');
      print('Darken factor: $_darkenFactor, Lighten factor: $_lightenFactor');
    }
    
    try {
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      
      final width = image.width;
      final height = image.height;
      final pixelData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      
      if (pixelData == null) return imageBytes;
      
      final bytes = pixelData.buffer.asUint8List();
      
      // Process each pixel
      for (int i = 0; i < bytes.length; i += 4) {
        final r = bytes[i];
        final g = bytes[i + 1];
        final b = bytes[i + 2];
        // final a = bytes[i + 3]; // Alpha channel, not used in processing
        
        // Calculate brightness for better text detection
        final brightness = (r + g + b) / 3;
        
        // Check if pixel is dark (text or dark elements) - use lower threshold for better text detection
        if (brightness <= _blackThreshold) {
          // Convert dark colors (including text) to white
          bytes[i] = 255;     // R
          bytes[i + 1] = 255; // G
          bytes[i + 2] = 255; // B
          // Keep alpha unchanged
        } else if (brightness >= (255 - _whiteThreshold)) {
          // Convert very light colors to black
          bytes[i] = 0;       // R
          bytes[i + 1] = 0;   // G
          bytes[i + 2] = 0;   // B
          // Keep alpha unchanged
        } else {
          // Process medium brightness colors based on their brightness
          if (brightness > 128) {
            // Light colors - darken them
            bytes[i] = (r * _darkenFactor).round().clamp(0, 255);     // R
            bytes[i + 1] = (g * _darkenFactor).round().clamp(0, 255); // G
            bytes[i + 2] = (b * _darkenFactor).round().clamp(0, 255); // B
          } else {
            // Medium-dark colors - lighten them
            bytes[i] = (255 - (255 - r) * _lightenFactor).round().clamp(0, 255);     // R
            bytes[i + 1] = (255 - (255 - g) * _lightenFactor).round().clamp(0, 255); // G
            bytes[i + 2] = (255 - (255 - b) * _lightenFactor).round().clamp(0, 255); // B
          }
          // Keep alpha unchanged
        }
      }
      
      // Create a completer to capture the processed image
      final completer = Completer<ui.Image>();
      ui.decodeImageFromPixels(
        bytes,
        width,
        height,
        ui.PixelFormat.rgba8888,
        (ui.Image img) {
          completer.complete(img);
        },
      );
      
      final processedImage = await completer.future;
      final processedBytes = await processedImage.toByteData(format: ui.ImageByteFormat.png);
      // Dispose images properly
      image.dispose();
      processedImage.dispose();
      
      if (processedBytes == null) {
        if (kDebugMode) {
          print('DarkModeImageProcessor: Failed to get processed bytes');
        }
        return imageBytes;
      }
      
      if (kDebugMode) {
        print('DarkModeImageProcessor: Successfully processed image');
      }
      
      return processedBytes.buffer.asUint8List();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('DarkModeImageProcessor: Error processing image: $e');
        print('Stack trace: $stackTrace');
      }
      return imageBytes;
    }
  }
}

