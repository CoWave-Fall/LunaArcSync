import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridSettingsNotifier extends ChangeNotifier {
  static const String _gridColumnCountKey = 'grid_column_count';
  static const String _defaultViewModeKey = 'default_view_mode';
  static const int defaultColumnCount = 2;
  static const String defaultViewModeValue = 'list';

  late int _crossAxisCount;
  late String _defaultViewMode;

  GridSettingsNotifier() {
    // Set default values before async loading completes.
    _crossAxisCount = defaultColumnCount;
    _defaultViewMode = defaultViewModeValue;
  }

  int get crossAxisCount => _crossAxisCount;
  String get defaultViewMode => _defaultViewMode;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _crossAxisCount = prefs.getInt(_gridColumnCountKey) ?? defaultColumnCount;
    _defaultViewMode = prefs.getString(_defaultViewModeKey) ?? defaultViewModeValue;
    notifyListeners();
  }

  Future<void> updateCrossAxisCount(int count) async {
    if (count == _crossAxisCount) return;
    
    // Clamp the value to be within a reasonable range
    _crossAxisCount = count.clamp(2, 5);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gridColumnCountKey, _crossAxisCount);
    notifyListeners();
  }

  Future<void> updateDefaultViewMode(String mode) async {
    if (mode == _defaultViewMode) return;
    
    // Validate the mode
    if (mode != 'list' && mode != 'grid') return;
    
    _defaultViewMode = mode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultViewModeKey, _defaultViewMode);
    notifyListeners();
  }
}
