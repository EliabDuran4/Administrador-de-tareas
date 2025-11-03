import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF6C63FF), // Lila suave
      secondary: const Color(0xFF4A90E2), // Azul tenue
      background: const Color(0xFFF5F5F5), // Fondo claro
      surface: Colors.white,
      onPrimary: Colors.white,
      onBackground: Colors.black87,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6C63FF),
      foregroundColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF6C63FF),
      secondary: const Color(0xFF4A90E2),
    ),
  );
}
