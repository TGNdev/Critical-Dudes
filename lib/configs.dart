import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

MyTheme currentTheme = MyTheme();

const apiKey = '57da3e2054cb44f1b9e264962b4f5c07';