import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider with ChangeNotifier {
//   ThemeMode _theme = ThemeMode.light;

//   ThemeMode get themeMode => _theme;

//   dynamic toggleTheme(bool isDark) {
//     _theme = isDark ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late SharedPreferences sp;
  // late MyThemePreferences _preferences;
  bool get isDark => _isDark;

  ModelTheme() {
    _isDark = false;
    // _preferences = MyThemePreferences();
    getPreferences();
  }
//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    // _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    _isDark = await sp.getBool('darkmode') ?? false;
    notifyListeners();
  }

  handleThemeChange(context, bool newValue) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // _darkmode = sp.getBool('darkmode') ?? false;
    if (newValue) {
      await sp.setBool('darkmode', newValue);
    } else {
      await sp.setBool('darkmode', false);
      _isDark = newValue;
      Fluttertoast.showToast(msg: "Light theme on");
    }
    notifyListeners();
  }
}
