import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const List<String> variantNames = ['Sunrise', 'Noir', 'Forest'];

  static ThemeData themeData(int index, Brightness brightness) {
    final variant = index.clamp(0, variantNames.length - 1);
    final colorSeed = _seedColorForVariant(variant);
    final scheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: brightness,
      primary: colorSeed,
      secondary: brightness == Brightness.dark ? const Color(0xFF4DFFF6) : const Color(0xFF7C4DFF),
      surface: brightness == Brightness.dark ? const Color(0xFF111111) : const Color(0xFFF8F4EF),
      background: brightness == Brightness.dark ? const Color(0xFF090909) : const Color(0xFFF2ECF7),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        brightness == Brightness.dark
            ? Typography.material2021(platform: TargetPlatform.windows).white
            : Typography.material2021(platform: TargetPlatform.windows).black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: scheme.surface,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark ? scheme.surface : scheme.onBackground.withOpacity(0.08),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static Color _seedColorForVariant(int variantIndex) {
    switch (variantIndex) {
      case 1:
        return const Color(0xFF120136);
      case 2:
        return const Color(0xFF0B3B2E);
      default:
        return const Color(0xFF8E44AD);
    }
  }
}
