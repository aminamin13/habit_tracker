import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initial mode

  ThemeData _themeData = lightMode;

  //get current mode

  ThemeData get getCurrentTheme => _themeData;

  //is dark mode ??

  bool get isDarkMode => _themeData == darkMode;

  //set theme

  set themeData(ThemeData themeData) {
    _themeData = themeData;
  }

  //toggle theme
  void toggleTheme() {
    if (getCurrentTheme == darkMode) {
      _themeData = lightMode;
    } else {
      _themeData = darkMode;
    }

    notifyListeners();
  }
}
