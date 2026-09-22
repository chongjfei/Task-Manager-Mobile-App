import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');

  bool get isDarkMode => _settingsBox.get('isDarkMode', defaultValue: false);

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _settingsBox.put('isDarkMode', !isDarkMode);
    notifyListeners();
  }
}
