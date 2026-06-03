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
class ShellPage extends StatefulWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  double _chatRight = 24;
  double _chatBottom = 24;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 768;
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
                    ? _MobileLayout(child: widget.child)
                    : Row(
                        children: [
                          const LeftSidebar(),
                          Expanded(
                            child: ClipRect(child: widget.child),
                          ),
                        ],
                      ),
                // Floating chatbot — draggable
                Positioned(
                  right: _chatRight,
                  bottom: _chatBottom,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingChatbot(
                        // Mevcut İçecek AI Butonu
                        onDrag: (d) {
                          _updatePosition(d, size);
                        },
                      ),
                      const SizedBox(height: 12),
                      FloatingChatbot(
                        // Yeni Fal AI Butonu
                        onDrag: (d) {
                          _updatePosition(d, size);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updatePosition(DragUpdateDetails d, Size size) {
    setState(() {
      _chatRight = (_chatRight - d.delta.dx)
          .clamp(8.0, size.width - 90);
      _chatBottom = (_chatBottom - d.delta.dy)
          .clamp(8.0, size.height - 180); // İki buton olduğu için alanı daralttık
    });
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
