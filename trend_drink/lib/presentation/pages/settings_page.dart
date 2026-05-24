import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/frosted_panel.dart';
import 'package:trenddrink/core/widgets/glow_box.dart';
import 'package:trenddrink/core/widgets/section_header_hero.dart';
import 'package:trenddrink/features/paywall/paywall_sheet.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier_v2.dart';

/// Premium dashboard tarzı ayarlar.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final variant = ref.watch(themeVariantProvider);
    final themeMode = ref.watch(currentThemeModeProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderHero(
            title: 'Ayarlar',
            subtitle: 'Premium kontrol paneli',
            height: 170,
          ),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: LayoutBuilder(builder: (ctx, c) {
              final twoCol = c.maxWidth >= 960;
              final left = _MembershipPanel(isPro: membership.isPro);
              final right = _StatsPanel(membership: membership);
              return twoCol
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: left),
                        const SizedBox(width: 18),
                        Expanded(child: right),
                      ],
                    )
                  : Column(children: [left, const SizedBox(height: 18), right]);
            }),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: FrostedPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Görünüm'),
                  const SizedBox(height: 14),
                  _ThemeModeRow(themeMode: themeMode),
                  const SizedBox(height: 18),
                  _ThemeVariantGrid(
                    current: variant,
                    isPro: membership.isPro,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: FrostedPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Hesap'),
                  const SizedBox(height: 8),
                  _LinkRow(
                    icon: Icons.person_rounded,
                    title: 'Profil',
                    subtitle: 'Profil ayarlarını yönet',
                  ),
                  _LinkRow(
                    icon: Icons.security_rounded,
                    title: 'Güvenlik',
                    subtitle: 'Parola ve oturum yönetimi',
                  ),
                  _LinkRow(
                    icon: Icons.notifications_rounded,
                    title: 'Bildirimler',
                    subtitle: 'Push & uygulama içi bildirimler',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              gradient: AppPalette.goldAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(text,
              style: AppTypography.display(
                size: 18,
                color: AppPalette.cream,
                letterSpacing: 1.2,
              )),
        ],
      );
}

class _MembershipPanel extends ConsumerWidget {
  const _MembershipPanel({required this.isPro});
  final bool isPro;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isPro
                      ? AppPalette.goldAccent
                      : LinearGradient(colors: [
                          AppPalette.mocha,
                          AppPalette.cocoa,
                        ]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isPro
                      ? [
                          BoxShadow(
                              color: AppPalette.gold.withAlpha(140),
                              blurRadius: 16)
                        ]
                      : null,
                ),
                child: Icon(
                  isPro ? Icons.workspace_premium_rounded : Icons.bolt_rounded,
                  color: isPro ? AppPalette.espresso : AppPalette.gold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPro ? 'PRO ÜYE' : 'FREE',
                      style: AppTypography.label(
                        size: 11,
                        color: AppPalette.gold,
                        letterSpacing: 2.4,
                        weight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPro
                          ? 'Sınırsız erişim · 100 ₺/ay'
                          : 'Premium\'a yükselt — 100 ₺/ay',
                      style: AppTypography.body(
                        size: 12.5,
                        color: AppPalette.cream,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!isPro)
            FilledButton.icon(
              onPressed: () => PaywallSheet.show(context),
              icon: const Icon(Icons.upgrade_rounded, size: 18),
              label: Text(
                'Pro\'ya Geç',
                style: AppTypography.label(
                  size: 12,
                  color: AppPalette.espresso,
                  letterSpacing: 1.4,
                  weight: FontWeight.w800,
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: () =>
                  ref.read(membershipProvider.notifier).resetToFree(),
              icon: const Icon(Icons.swap_horiz_rounded,
                  size: 16, color: AppPalette.danger),
              label: Text(
                'Free\'ye Dön',
                style: AppTypography.label(
                  size: 11,
                  color: AppPalette.danger,
                  letterSpacing: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.membership});
  final dynamic membership;
  @override
  Widget build(BuildContext context) {
    final isPro = membership.isPro as bool;
    final remaining = membership.aiRequestsRemaining as int;
    final max = membership.maxDailyAIRequests as int;
    final used = (max - remaining).clamp(0, max);
    final ratio = max == 0 ? 0.0 : used / max;
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  color: AppPalette.ledCyan, size: 20),
              const SizedBox(width: 8),
              Text('Kullanım',
                  style: AppTypography.label(
                    size: 12,
                    color: AppPalette.cream,
                    letterSpacing: 1.6,
                  )),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isPro ? '∞' : '$used / $max',
            style: AppTypography.display(
              size: 30,
              color: AppPalette.gold,
              weight: FontWeight.w700,
            ),
          ),
          Text('Bugünkü AI sorgu',
              style: AppTypography.body(
                  size: 11,
                  color: AppPalette.dimCream.withAlpha(170),
                  letterSpacing: 0.8)),
          const SizedBox(height: 14),
          if (!isPro)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: AppPalette.mocha.withAlpha(160),
                valueColor: const AlwaysStoppedAnimation(AppPalette.gold),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemeModeRow extends ConsumerWidget {
  const _ThemeModeRow({required this.themeMode});
  final ThemeMode themeMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10,
      children: ThemeMode.values.map((m) {
        final selected = m == themeMode;
        return GestureDetector(
          onTap: () =>
              ref.read(currentThemeModeProvider.notifier).setThemeMode(m),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected
                  ? AppPalette.gold.withAlpha(30)
                  : AppPalette.mocha.withAlpha(140),
              border: Border.all(
                color: selected
                    ? AppPalette.gold.withAlpha(180)
                    : AppPalette.gold.withAlpha(40),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  m == ThemeMode.dark
                      ? Icons.dark_mode_rounded
                      : m == ThemeMode.light
                          ? Icons.light_mode_rounded
                          : Icons.brightness_auto_rounded,
                  size: 16,
                  color: selected ? AppPalette.gold : AppPalette.dimCream,
                ),
                const SizedBox(width: 6),
                Text(
                  m.name.toUpperCase(),
                  style: AppTypography.label(
                    size: 10.5,
                    color: selected ? AppPalette.gold : AppPalette.dimCream,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ThemeVariantGrid extends ConsumerWidget {
  const _ThemeVariantGrid({required this.current, required this.isPro});
  final ThemeVariant current;
  final bool isPro;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (ctx, c) {
      final cols = c.maxWidth >= 800 ? 4 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ThemeVariant.values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (_, i) {
          final v = ThemeVariant.values[i];
          final locked = AppTheme.isProVariant(v) && !isPro;
          final selected = current == v;
          return GlowBox(
            radius: 12,
            onTap: locked
                ? () => PaywallSheet.show(context)
                : () => ref.read(themeVariantProvider.notifier).setTheme(v),
            glowColor:
                selected ? AppPalette.gold : AppPalette.gold.withAlpha(120),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPalette.gold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppTheme.getVariantName(v),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label(
                        size: 11,
                        color: AppPalette.cream,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  if (locked)
                    const Icon(Icons.lock_rounded,
                        color: AppPalette.gold, size: 14)
                  else if (selected)
                    const Icon(Icons.check_circle_rounded,
                        color: AppPalette.gold, size: 16),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class _LinkRow extends StatefulWidget {
  const _LinkRow(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  State<_LinkRow> createState() => _LinkRowState();
}

class _LinkRowState extends State<_LinkRow> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _hover ? AppPalette.gold.withAlpha(14) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(widget.icon, size: 18, color: AppPalette.gold),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: AppTypography.label(
                        size: 12.5,
                        color: AppPalette.cream,
                        letterSpacing: 0.4,
                      )),
                  Text(widget.subtitle,
                      style: AppTypography.body(
                        size: 11,
                        color: AppPalette.dimCream.withAlpha(170),
                      )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppPalette.dimCream.withAlpha(180), size: 18),
          ],
        ),
      ),
    );
  }
}
