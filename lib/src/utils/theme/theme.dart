import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../widget_theme/text_theme.dart';
import 'appbar_theme.dart';
import 'elevated_button_theme.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: "Poppins",
    cardColor: ColorApp.tSecondaryNewColor,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: ColorApp.tPrimaryColor,
      primary: ColorApp.tPrimaryColor,
      secondary: ColorApp.tsecondaryColor,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
    ),
    shadowColor: Colors.black,
    hoverColor: Colors.grey[100]!,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: ColorApp.tDarkBgColor,
    textTheme: TTextTheme.darkTextTheme,
    cardColor: const Color.fromARGB(255, 218, 166, 144),
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: ColorApp.tPrimaryColor,
      primary: ColorApp.tPrimaryColor,
      secondary: ColorApp.tsecondaryColor,
      surface: Color(0xFF1E1E1E),
      background: ColorApp.tDarkBgColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white70,
      onBackground: Colors.white70,
    ),// ou ton dark background
    shadowColor: Colors.white,
    hoverColor: Colors.grey[800]!,
  );
}

/* class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: "Poppins",
   // scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: ColorApp.tsecondaryColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    primaryColor: ColorApp.tsecondaryColor,
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    //appBarTheme: TAppBarTheme.darkAppBarTheme,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: ColorApp.tsecondaryColor,
    ),
  );
} */
