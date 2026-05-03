import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/notifiers/theme_notifier.dart';

void main() {
  runApp(const ProviderScope(child: TrendDrinkApp()));
}

class TrendDrinkApp extends ConsumerWidget {
  const TrendDrinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
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
