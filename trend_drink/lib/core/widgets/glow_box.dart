import 'package:flutter/material.dart';
import 'package:trenddrink/core/theme/app_palette.dart';

/// Hover edildiğinde altın/cyan LED kenarlık + glow yansıtan kart sarmalayıcı.
class GlowBox extends StatefulWidget {
  const GlowBox({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 20,
    this.glowColor = AppPalette.gold,
    this.idleGlowAlpha = 18,
    this.hoverGlowAlpha = 120,
    this.padding = EdgeInsets.zero,
    this.duration = const Duration(milliseconds: 220),
    this.scaleOnHover = 1.025,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final Color glowColor;
  final int idleGlowAlpha;
  final int hoverGlowAlpha;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final double scaleOnHover;

  @override
  State<GlowBox> createState() => _GlowBoxState();
}

class _GlowBoxState extends State<GlowBox> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? widget.scaleOnHover : 1,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeOutCubic,
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color: widget.glowColor
                    .withAlpha(_hover ? 200 : widget.idleGlowAlpha + 30),
                width: _hover ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withAlpha(
                      _hover ? widget.hoverGlowAlpha : widget.idleGlowAlpha),
                  blurRadius: _hover ? 28 : 12,
                  spreadRadius: _hover ? 1 : 0,
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
