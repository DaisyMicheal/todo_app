import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 14.0;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  ThemeController() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 14.0;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = value;
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = value;
    await prefs.setDouble('fontSize', value);
    notifyListeners();
  }
}
