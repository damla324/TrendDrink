import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';

// ─── Shared Preferences Provider ────────────────────────────────────────────
final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// ─── Theme Mode Provider ────────────────────────────────────────────────────
final currentThemeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefsAsync = ref.watch(sharedPrefsProvider);
  return prefsAsync.when(
    data: (prefs) => ThemeModeNotifier(prefs),
    loading: () => ThemeModeNotifier(null),
    error: (_, __) => ThemeModeNotifier(null),
  );
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;
  static const String _key = 'app_theme_mode';

  ThemeModeNotifier(this._prefs) : super(ThemeMode.dark) {
    _initialize();
  }

  void _initialize() {
    final savedMode = _prefs?.getString(_key);
    if (savedMode != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.$savedMode',
        orElse: () => ThemeMode.dark,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs?.setString(_key, mode.name);
  }

  Future<void> toggleDarkMode() async {
    final newMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }
}

// ─── Theme Variant Provider ────────────────────────────────────────────────
final themeVariantProvider =
    StateNotifierProvider<ThemeVariantNotifier, ThemeVariant>((ref) {
  final prefsAsync = ref.watch(sharedPrefsProvider);
  return prefsAsync.when(
    data: (prefs) => ThemeVariantNotifier(prefs),
    loading: () => ThemeVariantNotifier(null),
    error: (_, __) => ThemeVariantNotifier(null),
  );
});

class ThemeVariantNotifier extends StateNotifier<ThemeVariant> {
  final SharedPreferences? _prefs;
  static const String _key = 'app_theme_variant';

  ThemeVariantNotifier(this._prefs) : super(ThemeVariant.noir) {
    _initialize();
  }

  void _initialize() {
    final savedTheme = _prefs?.getString(_key);
    if (savedTheme != null) {
      try {
        state = ThemeVariant.values
            .firstWhere((e) => e.name == savedTheme);
      } catch (_) {
        state = ThemeVariant.noir;
      }
    }
  }

  Future<void> setTheme(ThemeVariant variant) async {
    state = variant;
    await _prefs?.setString(_key, variant.name);
  }

  Future<void> nextTheme(bool isPro) async {
    final availableThemes = isPro
        ? [...AppTheme.freeVariants, ...AppTheme.proVariants]
        : AppTheme.freeVariants;
    final currentIndex = availableThemes.indexOf(state);
    final nextIndex = (currentIndex + 1) % availableThemes.length;
    await setTheme(availableThemes[nextIndex]);
  }

  Future<void> previousTheme(bool isPro) async {
    final availableThemes = isPro
        ? [...AppTheme.freeVariants, ...AppTheme.proVariants]
        : AppTheme.freeVariants;
    final currentIndex = availableThemes.indexOf(state);
    final previousIndex =
        currentIndex == 0 ? availableThemes.length - 1 : currentIndex - 1;
    await setTheme(availableThemes[previousIndex]);
  }
}

