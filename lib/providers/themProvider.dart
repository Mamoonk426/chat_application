import 'package:chat_application/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Themprovider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  final ThemeData _themeData = ThemeData.light();
  ThemeData get themeData => _isDark ? AppTheme.dark : AppTheme.light;
  void settheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
