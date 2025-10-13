import 'package:flutter/material.dart';

/// 页面导航状态管理
/// 用于在侧栏显示页码滑块
class PageNavigationNotifier extends ChangeNotifier {
  bool _isPageDetailVisible = false;
  int _currentPage = 1;
  int _totalPages = 1;
  Function(int)? _onPageChanged;

  bool get isPageDetailVisible => _isPageDetailVisible;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  /// 设置页面详情可见性
  void setPageDetailVisible(bool visible) {
    if (_isPageDetailVisible != visible) {
      _isPageDetailVisible = visible;
      // TODO: 暂时注释掉滑块功能，留到以后解决
      // print('PageNavigationNotifier: setPageDetailVisible($visible)');
      notifyListeners();
    }
  }

  /// 更新页面信息
  void updatePageInfo({
    required int currentPage,
    required int totalPages,
    required Function(int) onPageChanged,
  }) {
    _currentPage = currentPage;
    _totalPages = totalPages;
    _onPageChanged = onPageChanged;
    notifyListeners();
  }

  /// 跳转到指定页面
  void jumpToPage(int page) {
    if (_onPageChanged != null && page >= 1 && page <= _totalPages) {
      _onPageChanged!(page);
    }
  }

  /// 清除页面信息
  void clear() {
    // TODO: 暂时注释掉滑块功能，留到以后解决
    // print('PageNavigationNotifier: clear() called');
    _isPageDetailVisible = false;
    _currentPage = 1;
    _totalPages = 1;
    _onPageChanged = null;
    notifyListeners();
  }

  /// 强制隐藏滑块（用于确保滑块被隐藏）
  // TODO: 暂时注释掉滑块功能，留到以后解决
  /*
  void forceHide() {
    print('PageNavigationNotifier: forceHide() called');
    _isPageDetailVisible = false;
    notifyListeners();
  }
  */
}

