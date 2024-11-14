import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor:
      const Color(0xFF1A1A2E), // Very dark blue background for primary elements
  scaffoldBackgroundColor: const Color(0xFF0D0D16), // Darkest background color
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D0D16), // App bar background color
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardColor: const Color(0xFF1F1F2D), // Slightly lighter background for cards
  unselectedWidgetColor: const Color(0xFF00C853), // Bright green for highlights
  textTheme: const TextTheme(
    bodyLarge:
        TextStyle(color: Colors.white, fontSize: 16), // General body text
    bodyMedium:
        TextStyle(color: Colors.white70, fontSize: 14), // Secondary text
    displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold), // Headline text
  ),
  iconTheme: const IconThemeData(color: Colors.white), // Default icon color
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF00C853), // Bright green for buttons
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFF1A1A2E), // Dark input field background
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF00C853)), // Green border on focus
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), // Default border
    ),
    labelStyle: TextStyle(color: Colors.white70),
  ),
);
