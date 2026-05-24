import 'package:flutter/material.dart';

/// Tek tip kahve-altın tonlu palet. Tüm uygulama buradan beslenir.
class AppPalette {
  AppPalette._();

  // ── Surface / background tones ────────────────────────────────────────
  static const Color obsidian = Color(0xFF0A0604);
  static const Color espresso = Color(0xFF1A100A);
  static const Color mocha = Color(0xFF2C1A11);
  static const Color cocoa = Color(0xFF3D2618);
  static const Color caramel = Color(0xFFB57749);
  static const Color cream = Color(0xFFF2E4D2);
  static const Color dimCream = Color(0xFFD9C5AC);
  static const Color mutedBrown = Color(0xFF6B4A35);

  // ── Accents ───────────────────────────────────────────────────────────
  static const Color gold = Color(0xFFE6B450);
  static const Color goldSoft = Color(0xFFC99757);
  static const Color emberOrange = Color(0xFFE07A3A);
  static const Color ledCyan = Color(0xFF4DFFE2);
  static const Color ledViolet = Color(0xFFB18CFF);
  static const Color success = Color(0xFF4FD18B);
  static const Color danger = Color(0xFFE15A5A);

  // ── Title bar / chrome ────────────────────────────────────────────────
  static const LinearGradient titleBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF1A0E08),
      Color(0xFF2A180E),
      Color(0xFF3A2014),
      Color(0xFF2A180E),
      Color(0xFF1A0E08),
    ],
  );

  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1F120B),
      Color(0xFF150C07),
    ],
  );

  static const LinearGradient categoryHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF3D2417),
      Color(0xFF2A180F),
      Color(0xFF180E08),
    ],
  );

  static const LinearGradient aiAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4DFFE2), Color(0xFFB18CFF)],
  );

  static const LinearGradient goldAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE6B450), Color(0xFFC99757)],
  );

  // App-wide deep background (frameless pencerede dış zemin).
  static const LinearGradient appBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0604),
      Color(0xFF180E08),
      Color(0xFF0A0604),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  // ── Layout constants ──────────────────────────────────────────────────
  static const double sidebarCollapsedWidth = 76;
  static const double sidebarExpandedWidth = 260;
  static const double titleBarHeight = 38;
  static const double windowRadius = 16;
}
