import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Century Gothic birincil; sistemde yoksa Questrial (en yakın free karşılık)
/// + Plus Jakarta Sans → sans serif → Arial fallback zinciri.
class AppTypography {
  AppTypography._();

  static const String primaryFamily = 'Century Gothic';

  static const List<String> _fallback = <String>[
    'Questrial',
    'Plus Jakarta Sans',
    'Segoe UI',
    'sans-serif',
  ];

  /// Tüm metin temasını tek noktadan kurar.
  static TextTheme textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Typography.material2021(platform: TargetPlatform.windows).white
        : Typography.material2021(platform: TargetPlatform.windows).black;

    final questrial = GoogleFonts.questrialTextTheme(base);

    return questrial.apply(
      fontFamily: primaryFamily,
      fontFamilyFallback: _fallback,
    );
  }

  static TextStyle display({
    double size = 28,
    FontWeight weight = FontWeight.w700,
    Color? color,
    double letterSpacing = 0.4,
  }) {
    return TextStyle(
      fontFamily: primaryFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.1,
    );
  }

  static TextStyle body({
    double size = 13,
    FontWeight weight = FontWeight.w500,
    Color? color,
    double letterSpacing = 0.2,
    double height = 1.45,
  }) {
    return TextStyle(
      fontFamily: primaryFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle label({
    double size = 11,
    FontWeight weight = FontWeight.w600,
    Color? color,
    double letterSpacing = 0.8,
  }) {
    return TextStyle(
      fontFamily: primaryFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
