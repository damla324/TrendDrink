// Enhanced theme — single source of truth for the app's Material theme.
// Keeps legacy aliases (AppTheme.gold etc.) for backwards-compat while
// delegating colours to the new AppPalette.

import 'package:flutter/material.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';

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

  // ─── Legacy aliases (so existing widgets keep compiling) ────────────────
  static const Color gold = AppPalette.gold;
  static const Color ledCyan = AppPalette.ledCyan;
  static const Color cream = AppPalette.cream;
  static const Color dimCream = AppPalette.dimCream;
  static const Color mocha = AppPalette.mocha;
  static const Color espresso = AppPalette.espresso;
  static const Color darkMocha = AppPalette.cocoa;
  static const Color caramel = AppPalette.caramel;
  static const Color mutedBrown = AppPalette.mutedBrown;
  static const double sidebarWidth = AppPalette.sidebarExpandedWidth;

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
    final seed = _seedColorForVariant(variant);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      primary: AppPalette.gold,
      secondary: AppPalette.ledCyan,
      surface: AppPalette.espresso,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      textTheme: AppTypography.textTheme(brightness),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.gold,
          foregroundColor: AppPalette.espresso,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: AppTypography.label(size: 12, letterSpacing: 0.9),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.gold,
          foregroundColor: AppPalette.espresso,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppPalette.mocha.withAlpha(180),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.mocha.withAlpha(140),
        hintStyle: AppTypography.body(
          size: 13,
          color: AppPalette.dimCream.withAlpha(140),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppPalette.gold.withAlpha(40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.gold, width: 1.4),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppPalette.gold.withAlpha(28),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppPalette.cream),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppPalette.espresso,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppPalette.gold.withAlpha(60)),
        ),
        textStyle: AppTypography.label(
          size: 11,
          color: AppPalette.cream,
          letterSpacing: 0.4,
        ),
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
        return const Color(0xFFE07A3A);
      case ThemeVariant.noir:
        return AppPalette.espresso;
      case ThemeVariant.forest:
        return const Color(0xFF0B3B2E);
      case ThemeVariant.oceanWave:
        return const Color(0xFF0099FF);
      case ThemeVariant.purpleGradient:
        return const Color(0xFF9D4EDD);
      case ThemeVariant.goldLux:
        return AppPalette.gold;
      case ThemeVariant.darkCrimson:
        return const Color(0xFFDC143C);
      case ThemeVariant.matrixGreen:
        return const Color(0xFF00FF41);
    }
  }

  static bool isProVariant(ThemeVariant variant) =>
      proVariants.contains(variant);
  static String getVariantName(ThemeVariant variant) =>
      variantNames[variant] ?? 'Unknown';
}
