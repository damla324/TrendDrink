import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Coffee Design Tokens ───────────────────────────────────────────────────
  static const Color espresso = Color(0xFF120B04);
  static const Color mocha = Color(0xFF1E140A);
  static const Color darkMocha = Color(0xFF160F07);
  static const Color gold = Color(0xFFC8A97E);
  static const Color caramel = Color(0xFFE8C99A);
  static const Color cream = Color(0xFFF5EDD8);
  static const Color dimCream = Color(0xFFB8A992);
  static const Color mutedBrown = Color(0xFF6B4F38);
  static const Color ledCyan = Color(0xFF00FFD1);
  static const Color errorRed = Color(0xFFCF6679);

  // ── Sidebar Width ──────────────────────────────────────────────────────────
  static const double sidebarWidth = 228.0;

  static ThemeData darkTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: espresso,
      primaryContainer: Color(0xFF3D2A14),
      onPrimaryContainer: caramel,
      secondary: caramel,
      onSecondary: espresso,
      secondaryContainer: Color(0xFF2A1F10),
      onSecondaryContainer: cream,
      tertiary: ledCyan,
      onTertiary: espresso,
      error: errorRed,
      onError: Colors.white,
      surface: mocha,
      onSurface: cream,
      surfaceContainerHighest: Color(0xFF2A1D10),
      outline: Color(0xFF5A4231),
      outlineVariant: Color(0xFF3A2A1A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: cream,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: cream,
          letterSpacing: 0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: espresso,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          side: const BorderSide(color: gold, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
      cardTheme: CardThemeData(
        color: mocha.withAlpha(200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: mocha,
        selectedColor: gold.withAlpha(50),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: cream,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(color: mutedBrown, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkMocha.withAlpha(180),
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: dimCream.withAlpha(140),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: mutedBrown, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: mutedBrown.withAlpha(120), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: mutedBrown.withAlpha(80),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: dimCream, size: 20),
      listTileTheme: const ListTileThemeData(
        iconColor: dimCream,
        textColor: cream,
        selectedColor: gold,
        selectedTileColor: Colors.transparent,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(mutedBrown.withAlpha(100)),
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(4),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  // ── Typography ─────────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: cream,
        height: 1.1,
        letterSpacing: -1,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: cream,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: cream,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: cream,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: cream,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: cream,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: cream,
        letterSpacing: 0.1,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: cream,
        letterSpacing: 0.1,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: dimCream,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: dimCream,
        height: 1.65,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: dimCream,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: dimCream.withAlpha(200),
        height: 1.5,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: gold,
        letterSpacing: 1.8,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: gold,
        letterSpacing: 1.5,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: dimCream.withAlpha(170),
        letterSpacing: 0.5,
      ),
    );
  }
}
