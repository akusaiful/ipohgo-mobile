import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    // scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    shadowColor: Colors.grey[200],
    colorScheme: ColorScheme.light(),
    useMaterial3: false,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blueAccent,
    iconTheme: IconThemeData(color: Colors.grey[900]),
    fontFamily: 'Manrope',
    scaffoldBackgroundColor: Colors.white,

    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
    ),

    textTheme: TextTheme(
      // displayMedium:
      // for title list profile/setting
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey[900],
      ),
    ),

    appBarTheme: AppBarTheme(
      // backgroundColor: Colors.red,
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.grey[400],
      ),
      titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Manrope',
          color: Colors.grey[900]),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    shadowColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.blueGrey[800],
    colorScheme: ColorScheme.dark(),
    primaryColor: Colors.blueGrey[900],
    textTheme: TextTheme(
      // displayMedium:
      // for title list profile/setting
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey[500],
      ),
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      // backgroundColor: Colors.black45,
      color: Colors.blueGrey[800],
      titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Manrope',
          color: Colors.grey[300]),
    ),
    tabBarTheme: const TabBarTheme(
        // labelColor: Colors.black,
        ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  );
}

class CustomTextStyle {
  static TextStyle headerWidgetHome(BuildContext context) {
    return TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: Theme.of(context).primaryColor,
        color: Colors.grey[900],
        wordSpacing: 1,
        letterSpacing: -0.6);
  }
}
