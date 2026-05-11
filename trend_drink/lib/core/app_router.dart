import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/presentation/pages/assistant_page.dart';
import 'package:trenddrink/presentation/pages/category_page.dart';
import 'package:trenddrink/presentation/pages/drink_detail_page.dart';
import 'package:trenddrink/presentation/pages/home_page_v2.dart';
import 'package:trenddrink/presentation/pages/pro_features_page.dart';
import 'package:trenddrink/presentation/pages/settings_page.dart';
import 'package:trenddrink/presentation/widgets/desktop_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DesktopLayout(child: HomePageV2()),
        transitionsBuilder: _fadeTransition,
      ),
      routes: [
        GoRoute(
          path: 'assistant',
          name: 'assistant',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DesktopLayout(child: AssistantPage()),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: 'drink/:id',
          name: 'drinkDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return CustomTransitionPage(
              key: state.pageKey,
              child: DesktopLayout(
                child: DrinkDetailPage(drinkId: id),
              ),
              transitionsBuilder: _fadeTransition,
            );
          },
        ),
        GoRoute(
          path: 'category/:name',
          name: 'category',
          pageBuilder: (context, state) {
            final categoryName = state.pathParameters['name'] ?? '';
            return CustomTransitionPage(
              key: state.pageKey,
              child: DesktopLayout(
                child: CategoryPage(categoryName: categoryName),
              ),
              transitionsBuilder: _fadeTransition,
            );
          },
        ),
        GoRoute(
          path: 'pro',
          name: 'pro',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DesktopLayout(child: ProFeaturesPage()),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DesktopLayout(child: SettingsPage()),
            transitionsBuilder: _fadeTransition,
          ),
        ),
      ],
    ),
  ],
);

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}
