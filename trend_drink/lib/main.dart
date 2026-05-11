import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme_enhanced.dart';
import 'presentation/notifiers/theme_notifier_v2.dart';

void main() {
  runZonedGuarded(
    () {
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

class TrendDrinkApp extends ConsumerWidget {
  const TrendDrinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(currentThemeModeProvider);
    final themeVariant = ref.watch(themeVariantProvider);
    
    return MaterialApp.router(
      title: 'TrendDrink',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.themeData(themeVariant, Brightness.light),
      darkTheme: AppTheme.themeData(themeVariant, Brightness.dark),
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}
