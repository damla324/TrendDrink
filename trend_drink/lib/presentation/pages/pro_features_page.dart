import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/frosted_panel.dart';
import 'package:trenddrink/core/widgets/section_header_hero.dart';
import 'package:trenddrink/features/paywall/paywall_sheet.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

class ProFeaturesPage extends ConsumerWidget {
  const ProFeaturesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderHero(
            title: membership.isPro ? 'Pro Üyesin' : 'TrendDrink Pro',
            subtitle: membership.isPro
                ? 'Tüm premium özellikler senin için açık.'
                : 'Tüm özellikleri görmek için aşağıdaki düğmeye bas.',
            height: 170,
          ),
          const SizedBox(height: 32),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: FrostedPanel(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppPalette.goldAccent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPalette.gold.withAlpha(140),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppPalette.espresso,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  membership.isPro
                                      ? 'Premium üyeliğin etkin'
                                      : 'Yalnızca 100 ₺/ay',
                                  style: AppTypography.display(
                                    size: 22,
                                    color: AppPalette.cream,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  membership.isPro
                                      ? 'Tüm özellikler sınırsız kullanımına açık.'
                                      : 'AI sınırsız sorgu, görsel tabanlı tarif, 5 premium tema ve daha fazlası.',
                                  style: AppTypography.body(
                                    size: 12.5,
                                    color: AppPalette.dimCream.withAlpha(190),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      if (!membership.isPro)
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: () => PaywallSheet.show(context),
                            icon: const Icon(Icons.bolt_rounded, size: 18),
                            label: Text(
                              'Premium Özellikleri Gör',
                              style: AppTypography.label(
                                size: 12,
                                color: AppPalette.espresso,
                                letterSpacing: 1.4,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppPalette.success.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppPalette.success.withAlpha(120)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded,
                                  color: AppPalette.success, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Aktif Pro Üyelik',
                                style: AppTypography.label(
                                  size: 11.5,
                                  color: AppPalette.success,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
