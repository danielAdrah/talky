import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talky/themes/light_theme.dart';

import 'dark_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
   static final box = GetStorage();
  static const String themeKey = 'theme';
  bool _isDarkMode = false;

  ThemeProvider(){
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  //to check wether it is dark mode
  bool get isDarkMode => _isDarkMode;

  

  // set themeData(ThemeData themeData) {
  //   _themeData = themeData;
  //   notifyListeners();
  // }
  void _loadTheme() {
    _isDarkMode = box.read(themeKey) ?? false;
    _themeData = _isDarkMode ? darkMode : lightMode;
  }

  void toggleTheme() {
    // if (_themeData == lightMode) {
    //   themeData = darkMode;
    // } else {
    //   themeData = lightMode;
    // }
     _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? darkMode : lightMode;
    box.write(themeKey, _isDarkMode);
    notifyListeners();
  }
}
