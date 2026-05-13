import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';
import 'package:trenddrink/domain/models/membership_model.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier_v2.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final currentTheme = ref.watch(themeVariantProvider);
    final themeMode = ref.watch(currentThemeModeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────────
              Text(
                'Settings & Preferences',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Customize your TrendDrink experience',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),

              // ── Membership Card ────────────────────────────────────────
              _MembershipCard(membership: membership, ref: ref),
              const SizedBox(height: 48),

              // ── Theme Mode Section ────────────────────────────────────────
              _SettingsSection(
                title: 'Appearance',
                description: 'Customize the app\'s visual style',
                children: [
                  _ThemeModeSelector(themeMode: themeMode, ref: ref),
                  const SizedBox(height: 24),
                  _ThemeVariantSelector(
                    themeVariant: currentTheme,
                    membership: membership,
                    ref: ref,
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // ── Account Section ──────────────────────────────────────────
              _SettingsSection(
                title: 'Account',
                children: [
                  _SettingItem(
                    icon: Icons.person_rounded,
                    title: 'Profile',
                    subtitle: 'View and edit your profile',
                    onTap: () {},
                  ),
                  const Divider(height: 24),
                  _SettingItem(
                    icon: Icons.security_rounded,
                    title: 'Security',
                    subtitle: 'Manage passwords and sessions',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // ── About Section ────────────────────────────────────────────
              _SettingsSection(
                title: 'About',
                children: [
                  _SettingItem(
                    icon: Icons.info_rounded,
                    title: 'App Version',
                    subtitle: 'TrendDrink v1.0.0',
                    onTap: () {},
                  ),
                  const Divider(height: 24),
                  _SettingItem(
                    icon: Icons.description_rounded,
                    title: 'License',
                    subtitle: 'View software licenses',
                    onTap: () {},
                  ),
                  const Divider(height: 24),
                  _SettingItem(
                    icon: Icons.feedback_rounded,
                    title: 'Send Feedback',
                    subtitle: 'Help us improve the app',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──── Components ────────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ThemeModeSelector extends ConsumerWidget {
  final ThemeMode themeMode;
  final WidgetRef ref;

  const _ThemeModeSelector({
    required this.themeMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Mode',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ModeButton(
                icon: Icons.light_mode_rounded,
                label: 'Light',
                isSelected: themeMode == ThemeMode.light,
                onTap: () async {
                  await ref
                      .read(currentThemeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                },
              ),
              const SizedBox(width: 12),
              _ModeButton(
                icon: Icons.dark_mode_rounded,
                label: 'Dark',
                isSelected: themeMode == ThemeMode.dark,
                onTap: () async {
                  await ref
                      .read(currentThemeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                },
              ),
              const SizedBox(width: 12),
              _ModeButton(
                icon: Icons.brightness_auto_rounded,
                label: 'System',
                isSelected: themeMode == ThemeMode.system,
                onTap: () async {
                  await ref
                      .read(currentThemeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeVariantSelector extends ConsumerWidget {
  final ThemeVariant themeVariant;
  final MembershipModel membership;
  final WidgetRef ref;

  const _ThemeVariantSelector({
    required this.themeVariant,
    required this.membership,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableThemes = membership.isPro
        ? [...AppTheme.freeVariants, ...AppTheme.proVariants]
        : AppTheme.freeVariants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Theme Variants',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (!membership.isPro)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pro Only',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableThemes.length,
          itemBuilder: (context, index) {
            final variant = availableThemes[index];
            final isSelected = themeVariant == variant;
            final isPro = AppTheme.isProVariant(variant);
            final seedColor = _seedColorForVariant(variant);

            return GestureDetector(
              onTap: () async {
                if (isPro && !membership.isPro) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          '🔒 This theme is available for Pro members only'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                  return;
                }
                await ref
                    .read(themeVariantProvider.notifier)
                    .setTheme(variant);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      seedColor,
                      seedColor.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.transparent,
                    width: isSelected ? 3 : 0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: seedColor.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.palette_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppTheme.getVariantName(variant),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (isPro && !membership.isPro)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: seedColor,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _seedColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.sunrise:
        return const Color(0xFF8E44AD);
      case ThemeVariant.noir:
        return const Color(0xFF120136);
      case ThemeVariant.forest:
        return const Color(0xFF0B3B2E);
      case ThemeVariant.oceanWave:
        return const Color(0xFF0099FF);
      case ThemeVariant.purpleGradient:
        return const Color(0xFF9D4EDD);
      case ThemeVariant.goldLux:
        return const Color(0xFFFFD700);
      case ThemeVariant.darkCrimson:
        return const Color(0xFFDC143C);
      case ThemeVariant.matrixGreen:
        return const Color(0xFF00FF41);
    }
  }
}

class _MembershipCard extends StatelessWidget {
  final MembershipModel membership;
  final WidgetRef ref;

  const _MembershipCard({
    required this.membership,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: membership.isPro
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                  Theme.of(context).colorScheme.surfaceContainer,
                ],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: membership.isPro
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          membership.isPro ? Icons.star_rounded : Icons.star_outline,
                          color: membership.isPro ? Colors.yellow : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          membership.isPro ? '✨ Pro Member' : 'Free Tier',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: membership.isPro
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      membership.isPro
                          ? 'Unlimited AI & All Themes Available'
                          : 'Limited AI • Basic Themes',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: membership.isPro
                            ? Colors.white70
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!membership.isPro)
                FilledButton.icon(
                  onPressed: () {
                    ref.read(membershipProvider.notifier).upgradeToPro();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Welcome to Pro! Unlock all features now.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upgrade),
                  label: const Text('Upgrade Now'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
          ],
        ),
      ),
    );
  }
}


