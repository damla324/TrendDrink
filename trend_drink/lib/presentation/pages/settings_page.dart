import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier_v2.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final currentTheme = ref.watch(themeVariantProvider);
    final themeMode = ref.watch(currentThemeModeProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Membership Section
            _SettingsSection(
              title: 'Account',
              children: [
                ListTile(
                  leading: Icon(
                    membership.isPro ? Icons.star : Icons.account_circle,
                    color: colors.primary,
                  ),
                  title: Text(membership.isPro ? 'Pro Member' : 'Free Member'),
                  subtitle: membership.purchaseDate != null
                    ? Text('Member since ${membership.purchaseDate?.toString().split(' ')[0]}')
                    : null,
                  trailing: membership.isPro
                    ? Icon(Icons.verified, color: const Color(0xFFFFD700))
                    : FilledButton(
                        onPressed: () {
                          ref.read(membershipProvider.notifier).upgradeToPro();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🎉 Welcome to Pro! Enjoy unlimited features!'),
                            ),
                          );
                        },
                        child: const Text('Upgrade'),
                      ),
                ),
                if (!membership.isPro)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'AI Requests: ${membership.aiRequestsRemaining}/${membership.maxDailyAIRequests} remaining',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),

            // Theme Section
            _SettingsSection(
              title: 'Theme',
              children: [
                ListTile(
                  leading: Icon(Icons.brightness_4, color: colors.primary),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      ref.read(currentThemeModeProvider.notifier).state =
                        value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Themes',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ...(membership.isPro
                            ? [...AppTheme.freeVariants, ...AppTheme.proVariants]
                            : AppTheme.freeVariants
                          ).map((variant) {
                            final isSelected = currentTheme == variant;
                            final isPro = AppTheme.isProVariant(variant);
                            final seedColor = _getSeedColor(variant);

                            return GestureDetector(
                              onTap: () {
                                ref.read(themeVariantProvider.notifier).setTheme(variant);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      seedColor,
                                      seedColor.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected
                                    ? Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      )
                                    : Border.all(
                                        color: colors.outlineVariant,
                                      ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppTheme.getVariantName(variant),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        if (isPro)
                                          const Icon(
                                            Icons.star,
                                            color: Color(0xFFFFD700),
                                            size: 12,
                                          ),
                                      ],
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // About Section
            _SettingsSection(
              title: 'About',
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: colors.primary),
                  title: const Text('App Version'),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  leading: Icon(Icons.language, color: colors.primary),
                  title: const Text('Language'),
                  trailing: const Text('English'),
                ),
              ],
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      ref.read(membershipProvider.notifier).resetToFree();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reset to free plan')),
                      );
                    },
                    child: const Text('Reset Membership (Demo)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeedColor(ThemeVariant variant) {
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
