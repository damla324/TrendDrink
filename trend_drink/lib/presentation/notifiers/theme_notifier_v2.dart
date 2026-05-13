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
    NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _key = 'app_theme_mode';

  @override
  ThemeMode build() {
    final prefsAsync = ref.watch(sharedPrefsProvider);
    return prefsAsync.whenData((prefs) {
      final savedMode = prefs.getString(_key);
      if (savedMode != null) {
        return ThemeMode.values.firstWhere(
          (e) => e.toString() == 'ThemeMode.$savedMode',
          orElse: () => ThemeMode.dark,
        );
      }
      return ThemeMode.dark;
    }).value ?? ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    state = mode;
    await prefs.setString(_key, mode.name);
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
    NotifierProvider<ThemeVariantNotifier, ThemeVariant>(
  ThemeVariantNotifier.new,
);

class ThemeVariantNotifier extends Notifier<ThemeVariant> {
  static const String _key = 'app_theme_variant';

  @override
  ThemeVariant build() {
    final prefsAsync = ref.watch(sharedPrefsProvider);
    return prefsAsync.whenData((prefs) {
      final savedTheme = prefs.getString(_key);
      if (savedTheme != null) {
        try {
          return ThemeVariant.values.firstWhere((e) => e.name == savedTheme);
        } catch (_) {
          return ThemeVariant.noir;
        }
      }
      return ThemeVariant.noir;
    }).value ?? ThemeVariant.noir;
  }

  Future<void> setTheme(ThemeVariant variant) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    state = variant;
    await prefs.setString(_key, variant.name);
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

