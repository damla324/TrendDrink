import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';

Future<void> showTrendDrinkAbout(BuildContext context) async {
  final info = await PackageInfo.fromPlatform().catchError(
    (_) => PackageInfo(
        appName: 'TrendDrink',
        packageName: 'trenddrink',
        version: '1.0.0',
        buildNumber: '1'),
  );

  if (!context.mounted) return;

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'about',
    barrierColor: Colors.black.withAlpha(140),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, __, ___) {
      final fade = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(fade),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppPalette.obsidian.withAlpha(248),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppPalette.gold.withAlpha(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(160),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: AppPalette.goldAccent,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPalette.gold.withAlpha(110),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.local_cafe_rounded,
                                color: AppPalette.espresso, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TrendDrink',
                                  style: AppTypography.display(
                                      size: 22,
                                      color: AppPalette.cream,
                                      letterSpacing: 1.4)),
                              Text(
                                'Premium Beverage Experience',
                                style: AppTypography.label(
                                  size: 10,
                                  color: AppPalette.dimCream.withAlpha(160),
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        height: 1,
                        color: AppPalette.gold.withAlpha(40),
                      ),
                      const SizedBox(height: 22),
                      _kv('Versiyon', '${info.version} (${info.buildNumber})'),
                      _kv('Mimari', 'Flutter · Riverpod · Clean Layered'),
                      _kv('Tema', 'Espresso Noir · Gold Accent'),
                      _kv('Geliştirici', 'TrendDrink Studio'),
                      const SizedBox(height: 22),
                      Text(
                        'AI destekli içecek keşif platformu. Malzemelerinizi paylaşın, '
                        'görselden tanısın, ruh halinize göre tarif önersin.',
                        style: AppTypography.body(
                          size: 12.5,
                          color: AppPalette.dimCream.withAlpha(200),
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Tamam'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _kv(String k, String v) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(k,
              style: AppTypography.label(
                size: 11,
                color: AppPalette.dimCream.withAlpha(150),
                letterSpacing: 1,
              )),
        ),
        Expanded(
          child: Text(v,
              style: AppTypography.body(
                  size: 12.5,
                  color: AppPalette.cream,
                  weight: FontWeight.w600)),
        ),
      ],
    ),
  );
}
