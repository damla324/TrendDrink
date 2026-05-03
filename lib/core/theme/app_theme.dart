import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6F4E37),
    brightness: Brightness.light,
    primary: const Color(0xFF7C4DFF),
    secondary: const Color(0xFF03DAC6),
    surface: const Color(0xFFF6F1EE),
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6F4E37),
    brightness: Brightness.dark,
    primary: const Color(0xFFBB86FC),
    secondary: const Color(0xFF03DAC6),
    surface: const Color(0xFF121212),
  );

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: _lightScheme.surface,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      Typography.material2021(platform: TargetPlatform.android).black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightScheme.surface,
      foregroundColor: _lightScheme.onSurface,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    cardTheme: CardThemeData(
      color: _lightScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 2,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: _darkScheme.surface,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      Typography.material2021(platform: TargetPlatform.android).white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkScheme.surface,
      foregroundColor: _darkScheme.onSurface,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    cardTheme: CardThemeData(
      color: _darkScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 2,
    ),
  );
}
