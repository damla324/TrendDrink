import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_router.dart';
import 'core/theme/app_palette.dart';
import 'core/theme/app_theme_enhanced.dart';
import 'core/window/window_chrome.dart';
import 'presentation/notifiers/theme_notifier_v2.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await WindowChrome.init();
      runApp(const ProviderScope(child: TrendDrinkApp()));
    },
    (error, stack) {
      debugPrint('🔴 Uncaught: $error\n$stack');
    },
  );
}

class TrendDrinkApp extends ConsumerWidget {
  const TrendDrinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(currentThemeModeProvider);
    final themeVariant = ref.watch(themeVariantProvider);

    return MaterialApp.router(
      title: 'TrendDrink – Premium Beverage Experience',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(themeVariant, Brightness.light),
      darkTheme: AppTheme.themeData(themeVariant, Brightness.dark),
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) => _RoundedWindowFrame(child: child),
    );
  }
}

/// Frameless pencerede uygulamanın dış kabuğu:
///   - global koyu kahve background
///   - 16px köşe yuvarlama
///   - hafif altın kenarlık ile premium dokunuş
class _RoundedWindowFrame extends StatelessWidget {
  const _RoundedWindowFrame({required this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppPalette.appBackgroundGradient,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppPalette.windowRadius),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppPalette.gold.withAlpha(45),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppPalette.windowRadius),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
