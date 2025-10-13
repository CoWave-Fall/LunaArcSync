import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 预缓存设置管理器
class PrecachingSettingsNotifier extends ChangeNotifier {
  static const String _precachingEnabledKey = 'precaching_enabled';
  static const String _precachingRangeKey = 'precaching_range';
  static const bool defaultPrecachingEnabled = true;
  static const int defaultPrecachingRange = 2; // 前后各2页，共5页（含当前页）

  late bool _precachingEnabled;
  late int _precachingRange;

  PrecachingSettingsNotifier() {
    // Set default values before async loading completes.
    _precachingEnabled = defaultPrecachingEnabled;
    _precachingRange = defaultPrecachingRange;
  }

  bool get precachingEnabled => _precachingEnabled;
  int get precachingRange => _precachingRange;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _precachingEnabled = prefs.getBool(_precachingEnabledKey) ?? defaultPrecachingEnabled;
    _precachingRange = prefs.getInt(_precachingRangeKey) ?? defaultPrecachingRange;
    notifyListeners();
  }

  Future<void> updatePrecachingEnabled(bool enabled) async {
    if (enabled == _precachingEnabled) return;
    
    _precachingEnabled = enabled;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_precachingEnabledKey, _precachingEnabled);
    notifyListeners();
  }

  Future<void> updatePrecachingRange(int range) async {
    if (range == _precachingRange) return;
    
    // Clamp the value to be within a reasonable range (1-5)
    _precachingRange = range.clamp(1, 5);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_precachingRangeKey, _precachingRange);
    notifyListeners();
  }

  /// 获取预缓存范围描述
  String getPrecachingRangeDescription() {
    if (!_precachingEnabled) {
      return '已禁用';
    }
    return '前后各 $_precachingRange 页';
  }

  /// 获取预缓存的页面索引列表
  /// [currentIndex] 当前页面索引
  /// [totalPages] 总页面数
  /// 返回应该预缓存的页面索引列表（不包括当前页）
  List<int> getPrecachingIndices(int currentIndex, int totalPages) {
    if (!_precachingEnabled || totalPages <= 1) {
      return [];
    }

    final indices = <int>[];
    
    // 添加前面的页面
    for (int i = 1; i <= _precachingRange; i++) {
      final index = currentIndex - i;
      if (index >= 0) {
        indices.add(index);
      }
    }
    
    // 添加后面的页面
    for (int i = 1; i <= _precachingRange; i++) {
      final index = currentIndex + i;
      if (index < totalPages) {
        indices.add(index);
      }
    }
    
    return indices;
  }
}

