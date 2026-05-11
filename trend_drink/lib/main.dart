import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme_enhanced.dart';
import 'presentation/notifiers/theme_notifier_v2.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (!kIsWeb && Platform.isWindows) {
        await _initWindow();
      }
      runApp(
        const ProviderScope(
          child: TrendDrinkApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('🔴 Caught error: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}

Future<void> _initWindow() async {
  await windowManager.ensureInitialized();
  const options = WindowOptions(
    size: Size(1400, 900),
    minimumSize: Size(960, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'TrendDrink - Premium Beverage Experience',
  );
  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class TrendDrinkApp extends ConsumerWidget {
  const TrendDrinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(currentThemeModeProvider);
    final themeVariant = ref.watch(themeVariantProvider);
    
    return MaterialApp.router(
      title: 'TrendDrink - Premium Beverage Experience',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(themeVariant, Brightness.light),
      darkTheme: AppTheme.themeData(themeVariant, Brightness.dark),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
