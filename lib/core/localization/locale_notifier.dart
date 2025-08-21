import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale? _locale;

  LocaleNotifier() {
    _loadLocale();
  }

  Locale? get locale => _locale;

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      // Default to English if no language is saved
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
    notifyListeners();
  }
}