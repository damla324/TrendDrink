import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/presentation/pages/drink_detail_page.dart';
import 'package:trenddrink/presentation/pages/home_page.dart';
import 'package:trenddrink/presentation/pages/search_assistant_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomePage(),
        transitionsBuilder: _fadeTransition,
      ),
      routes: [
        GoRoute(
          path: 'search',
          name: 'search',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SearchAssistantPage(),
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
              child: DrinkDetailPage(drinkId: id),
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
