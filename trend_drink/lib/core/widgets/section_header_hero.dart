import 'package:flutter/material.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';

/// Gradient kahve background + sol altın aksanlı başlık.
/// Eski "header görselli" tasarımın yerine bunu kullanıyoruz.
class SectionHeaderHero extends StatelessWidget {
  const SectionHeaderHero({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.height = 168,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppPalette.categoryHeaderGradient,
          border: Border(
            bottom: BorderSide(color: AppPalette.gold.withAlpha(36)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 32, 40, 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppPalette.goldAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: AppTypography.display(
                        size: 38,
                        color: AppPalette.cream,
                        letterSpacing: 1.0,
                        weight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: AppTypography.body(
                          size: 13,
                          color: AppPalette.dimCream.withAlpha(180),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
