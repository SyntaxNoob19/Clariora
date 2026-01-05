// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider extends ChangeNotifier {
//   bool isDarkModeChecked = true;

//   void updateMode({required bool darkMode}) async {
//     isDarkModeChecked = darkMode;
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     prefs.setBool('isDarkModeChecked', darkMode);

//     notifyListeners();
//   }

//   void loadMode() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     isDarkModeChecked = prefs.getBool('isDarkModeChecked') ?? true;
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeChecked = false;

  bool get isDarkModeChecked => _isDarkModeChecked;

  ThemeProvider() {
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkModeChecked = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void updateMode({required bool darkMode}) async {
    _isDarkModeChecked = darkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', darkMode);
    notifyListeners();
  }

  ThemeData get themeData {
    return _isDarkModeChecked ? ThemeData.dark() : ThemeData.light();
  }
}

