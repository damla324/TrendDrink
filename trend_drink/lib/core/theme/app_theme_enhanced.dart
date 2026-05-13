import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeVariant {
  // Free themes
  sunrise,
  noir,
  forest,
  // Pro premium themes
  oceanWave,
  purpleGradient,
  goldLux,
  darkCrimson,
  matrixGreen,
}

class AppTheme {
  AppTheme._();

  // ─── Static Color Constants ────────────────────────────────────────────
  static const Color gold = Color(0xFFFFD700);
  static const Color ledCyan = Color(0xFF00FFFF);
  static const Color cream = Color(0xFFF5E6D3);
  static const Color dimCream = Color(0xFFE8D7C3);
  static const Color mocha = Color(0xFF8B4513);
  static const Color espresso = Color(0xFF3E2723);
  static const Color darkMocha = Color(0xFF5D4037);
  static const Color caramel = Color(0xFFD2691E);
  static const Color mutedBrown = Color(0xFF8D6E63);
  static const double sidebarWidth = 280.0;

  static const Map<ThemeVariant, String> variantNames = {
    ThemeVariant.sunrise: 'Sunrise',
    ThemeVariant.noir: 'Noir',
    ThemeVariant.forest: 'Forest',
    ThemeVariant.oceanWave: 'Ocean Wave',
    ThemeVariant.purpleGradient: 'Purple Gradient',
    ThemeVariant.goldLux: 'Gold Lux',
    ThemeVariant.darkCrimson: 'Dark Crimson',
    ThemeVariant.matrixGreen: 'Matrix Green',
  };

  static const List<ThemeVariant> freeVariants = [
    ThemeVariant.sunrise,
    ThemeVariant.noir,
    ThemeVariant.forest,
  ];

  static const List<ThemeVariant> proVariants = [
    ThemeVariant.oceanWave,
    ThemeVariant.purpleGradient,
    ThemeVariant.goldLux,
    ThemeVariant.darkCrimson,
    ThemeVariant.matrixGreen,
  ];

  static ThemeData themeData(ThemeVariant variant, Brightness brightness) {
    final colorSeed = _seedColorForVariant(variant);
    final scheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: brightness,
      primary: colorSeed,
      secondary: brightness == Brightness.dark ? const Color(0xFF4DFFF6) : const Color(0xFF7C4DFF),
      surface: brightness == Brightness.dark ? const Color(0xFF111111) : const Color(0xFFF8F4EF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
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
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
        fillColor: brightness == Brightness.dark 
            ? scheme.surface 
            : scheme.onSurface.withValues(alpha: 0.08),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static Color _seedColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.sunrise:
        return const Color(0xFF8E44AD);
      case ThemeVariant.noir:
        return const Color(0xFF120136);
      case ThemeVariant.forest:
        return const Color(0xFF0B3B2E);
      case ThemeVariant.oceanWave:
        return const Color(0xFF0099FF);
      case ThemeVariant.purpleGradient:
        return const Color(0xFF9D4EDD);
      case ThemeVariant.goldLux:
        return const Color(0xFFFFD700);
      case ThemeVariant.darkCrimson:
        return const Color(0xFFDC143C);
      case ThemeVariant.matrixGreen:
        return const Color(0xFF00FF41);
    }
  }

  static bool isProVariant(ThemeVariant variant) {
    return proVariants.contains(variant);
  }

  static String getVariantName(ThemeVariant variant) {
    return variantNames[variant] ?? 'Unknown';
  }
}
