import 'package:flutter/material.dart';

/// 全屏模式状态管理
class FullscreenNotifier extends ChangeNotifier {
  bool _isFullscreen = false;

  bool get isFullscreen => _isFullscreen;

  void setFullscreen(bool value) {
    if (_isFullscreen != value) {
      _isFullscreen = value;
      notifyListeners();
    }
  }

  void toggleFullscreen() {
    _isFullscreen = !_isFullscreen;
    notifyListeners();
  }
}

