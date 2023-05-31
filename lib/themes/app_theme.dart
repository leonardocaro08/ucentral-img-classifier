import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(61, 76, 119, 1);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Color.fromRGBO(61, 76, 119, 1),
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Color.fromRGBO(61, 76, 119, 1),
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    ),
  );

  static ThemeData get grey {
    final baseTheme = ThemeData.light(); // tema base
    return baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.grey[200],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[500],
          border: OutlineInputBorder(),
        ),
        disabledColor: Colors.grey[100],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey[100],
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          color: Colors.grey[100],
        ),
        primaryColor: Colors.grey[100],
        primaryColorDark: Colors.grey[600],
        dividerColor: Colors.grey[400],
        colorScheme: ColorScheme.fromSwatch());
  }
}
