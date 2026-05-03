import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return IconButton(
      onPressed: () => ref.read(themeModeProvider.notifier).toggleDarkMode(),
      icon: Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
    );
  }
}
