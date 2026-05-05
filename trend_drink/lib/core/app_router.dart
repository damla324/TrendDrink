import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/presentation/pages/assistant_page.dart';
import 'package:trenddrink/presentation/pages/category_page.dart';
import 'package:trenddrink/presentation/pages/drink_detail_page.dart';
import 'package:trenddrink/presentation/pages/home_page_v2.dart';
import 'package:trenddrink/presentation/pages/shell_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellPage(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomePageV2(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: '/assistant',
          name: 'assistant',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AssistantPage(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: '/drink/:id',
          name: 'drinkDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return CustomTransitionPage(
              key: state.pageKey,
              child: DrinkDetailPage(drinkId: id),
              transitionsBuilder: _fadeTransition,
            );
          },
        ),
        GoRoute(
          path: '/category/:name',
          name: 'category',
          pageBuilder: (context, state) {
            final categoryName = state.pathParameters['name'] ?? '';
            return CustomTransitionPage(
              key: state.pageKey,
              child: CategoryPage(categoryName: categoryName),
              transitionsBuilder: _fadeTransition,
            );
          },
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
