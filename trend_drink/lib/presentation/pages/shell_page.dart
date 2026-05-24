import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/widgets/custom_title_bar.dart';
import 'package:trenddrink/presentation/widgets/floating_chatbot.dart';
import 'package:trenddrink/presentation/widgets/left_sidebar.dart';

/// Tüm sayfaları saran ana iskelet:
///   ┌─ CustomTitleBar (frameless + gradient + window butonları)
///   ├─ Row
///   │   ├─ LeftSidebar (rail, hover-expand)
///   │   └─ Expanded(child) — sayfa içeriği transparan zemin üzerinde
///   └─ backgroundH.png arka planda hafif transparan
class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const CustomTitleBar(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Arka plan görseli + transparan koyu overlay
                Opacity(
                  opacity: 0.30,
                  child: Image.asset(
                    'Assets/photo/backgroundH.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppPalette.obsidian.withAlpha(180),
                        AppPalette.espresso.withAlpha(150),
                        AppPalette.cocoa.withAlpha(120),
                      ],
                    ),
                  ),
                ),
                // Foreground: sidebar + child
                isMobile
                    ? _MobileLayout(child: child)
                    : Row(
                        children: [
                          const LeftSidebar(),
                          Expanded(
                            child: ClipRect(child: child),
                          ),
                        ],
                      ),
                // Floating chatbot — always on top
                const Positioned(
                  bottom: 24,
                  right: 24,
                  child: FloatingChatbot(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isTop = location == '/' || location == '/assistant';
    return Padding(
      padding: EdgeInsets.only(bottom: isTop ? 64 : 0),
      child: child,
    );
  }
}
