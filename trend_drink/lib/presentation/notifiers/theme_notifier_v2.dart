import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';

final currentThemeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class ThemeVariantController extends StateNotifier<ThemeVariant> {
  ThemeVariantController() : super(ThemeVariant.sunrise);

  void setTheme(ThemeVariant variant) {
    state = variant;
  }

  void nextTheme(bool isPro) {
    final availableThemes = isPro 
        ? [...AppTheme.freeVariants, ...AppTheme.proVariants] 
        : AppTheme.freeVariants;
    final currentIndex = availableThemes.indexOf(state);
    final nextIndex = (currentIndex + 1) % availableThemes.length;
    state = availableThemes[nextIndex];
  }
}

final themeVariantProvider = 
    StateNotifierProvider<ThemeVariantController, ThemeVariant>((ref) {
  return ThemeVariantController();
});

void toggleDarkMode(WidgetRef ref) {
  final currentMode = ref.read(currentThemeModeProvider);
  ref.read(currentThemeModeProvider.notifier).state = 
    currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}
