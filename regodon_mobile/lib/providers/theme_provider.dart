import 'package:flutter/material.dart';

// Enhancement 3: Provider state management for toggling Dark/Light Theme
class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}