import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
  );
}
