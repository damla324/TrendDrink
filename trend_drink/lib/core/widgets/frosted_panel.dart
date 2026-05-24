import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trenddrink/core/theme/app_palette.dart';

/// Glassmorphic, transparan, blur'lu yüzey – kart / panel primitive.
class FrostedPanel extends StatelessWidget {
  const FrostedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 18,
    this.tint,
    this.borderColor,
    this.blur = 18,
    this.alpha = 130,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? tint;
  final Color? borderColor;
  final double blur;
  final int alpha;

  @override
  Widget build(BuildContext context) {
    final fill = (tint ?? AppPalette.mocha).withAlpha(alpha);
    final border = borderColor ?? AppPalette.gold.withAlpha(36);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
