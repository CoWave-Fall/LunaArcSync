import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:luna_arc_sync/app.dart'; // Import the new App widget
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important for some plugins
  
  // Initialize flutter_inappwebview (enable debugging for development)
  // Only enable debugging on supported platforms (Android/iOS)
  // Use kIsWeb to check for web platform instead of Platform.isAndroid/isIOS
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  
  await configureDependencies();
  
  // 🔥 性能优化：预热毛玻璃效果缓存
  // 在应用启动时预加载常用的毛玻璃过滤器，减少首次渲染延迟
  if (kDebugMode) {
    debugPrint('🚀 启动应用并预热毛玻璃缓存...');
  }
  GlassmorphicCache().warmupCache();
  
  runApp(const App()); // Run our new root App widget
}
