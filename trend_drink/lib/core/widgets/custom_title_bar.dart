import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:window_manager/window_manager.dart';

/// Frameless pencerede üst bar – kahve gradient + sürükle alanı + window butonları.
class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppPalette.titleBarHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppPalette.titleBarGradient),
        child: Row(
          children: [
            const SizedBox(width: 14),
            // Brand
            Icon(Icons.local_cafe_rounded,
                size: 16, color: AppPalette.gold.withAlpha(220)),
            const SizedBox(width: 8),
            Text(
              'TrendDrink',
              style: AppTypography.label(
                size: 11,
                color: AppPalette.dimCream,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 14,
              color: AppPalette.gold.withAlpha(35),
            ),
            const SizedBox(width: 12),
            Text(
              'Premium Beverage Experience',
              style: AppTypography.label(
                size: 10,
                color: AppPalette.dimCream.withAlpha(130),
                letterSpacing: 1.2,
                weight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: _isDesktop
                  ? const DragToMoveArea(child: SizedBox.expand())
                  : const SizedBox.expand(),
            ),
            if (_isDesktop) const _WindowButtons(),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

class _WindowButtons extends StatelessWidget {
  const _WindowButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WinBtn(
          icon: Icons.remove_rounded,
          onTap: () async => windowManager.minimize(),
        ),
        _WinBtn(
          icon: Icons.crop_square_rounded,
          iconSize: 13,
          onTap: () async {
            final maxed = await windowManager.isMaximized();
            if (maxed) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
          },
        ),
        _WinBtn(
          icon: Icons.close_rounded,
          danger: true,
          onTap: () async => windowManager.close(),
        ),
      ],
    );
  }
}

class _WinBtn extends StatefulWidget {
  const _WinBtn({
    required this.icon,
    required this.onTap,
    this.danger = false,
    this.iconSize = 15,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  final double iconSize;

  @override
  State<_WinBtn> createState() => _WinBtnState();
}

class _WinBtnState extends State<_WinBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = widget.danger
        ? AppPalette.danger.withAlpha(180)
        : AppPalette.gold.withAlpha(50);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 38,
          height: AppPalette.titleBarHeight,
          color: _hover ? hoverColor : Colors.transparent,
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: _hover && widget.danger
                ? Colors.white
                : AppPalette.dimCream.withAlpha(220),
          ),
        ),
      ),
    );
  }
}
