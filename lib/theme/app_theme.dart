import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.light,
    canvasColor: const Color.fromRGBO(235, 235, 240, 1),
    fontFamily: 'Pilat Demi',
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Color.fromRGBO(235, 235, 240, 1),
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(
      0x1E1450,
      <int, Color>{
        50: Color(0x001e1450),
        100: Color(0x001e1450),
        200: Color(0x001e1450),
        300: Color(0x001e1450),
        400: Color(0x001e1450),
        500: Color(0x001e1450),
        600: Color(0x001e1450),
        700: Color(0x001e1450),
        800: Color(0x001e1450),
        900: Color(0x001e1450),
      },
    )).copyWith(
      primary: const Color.fromRGBO(15, 15, 25, 1),
      secondary: const Color.fromRGBO(58, 58, 66, 1),
      tertiary: const Color.fromRGBO(110, 110, 114, 1),
      surface: const Color.fromRGBO(213, 213, 221, 1),
      outline: const Color.fromRGBO(15, 15, 25, 1),
    ),
    textTheme: ThemeData.light()
        .textTheme
        .apply(
          fontFamily: 'Pilat Demi',
        )
        .copyWith(
          bodySmall: const TextStyle(
            color: Color.fromRGBO(58, 58, 66, 1),
            fontFamily: 'Pilat Demi',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: const TextStyle(
            color: Color.fromRGBO(15, 15, 25, 1),
            fontFamily: 'Pilat Demi',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(
            color: Color.fromRGBO(50, 48, 190, 1),
            fontFamily: 'Pilat Demi',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat Demi',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat Demi',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat Heavy',
            fontSize: 18,
          ),
        ),
  );
}
