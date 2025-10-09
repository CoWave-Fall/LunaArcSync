import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridSettingsNotifier extends ChangeNotifier {
  static const String _gridColumnCountKey = 'grid_column_count';
  static const int defaultColumnCount = 2;

  late int _crossAxisCount;

  GridSettingsNotifier() {
    // Set a default value before async loading completes.
    _crossAxisCount = defaultColumnCount;
  }

  int get crossAxisCount => _crossAxisCount;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _crossAxisCount = prefs.getInt(_gridColumnCountKey) ?? defaultColumnCount;
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
}
