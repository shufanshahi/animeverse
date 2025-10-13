import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('en');

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('bn');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}