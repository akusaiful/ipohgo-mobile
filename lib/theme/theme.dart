import 'package:flutter/material.dart';

class AppThemeData extends ChangeNotifier {
  bool currentDarkTheme = false;

  changeTheme(bool dark) {
    this.currentDarkTheme = dark;
    notifyListeners();
  }
}
