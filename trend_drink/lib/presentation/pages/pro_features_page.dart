import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';

class ProFeaturesPage extends ConsumerWidget {
  const ProFeaturesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary,
                    colors.primary.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Column(
                children: [
                  const Icon(
                    Icons.star,
                    size: 80,
                    color: Color(0xFFFFD700),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    membership.isPro ? '✨ You\'re a Pro Member!' : 'Unlock Pro Features',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    membership.isPro
                      ? 'Enjoy unlimited access to all premium features'
                      : 'Elevate your TrendDrink experience with exclusive perks',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!membership.isPro) ...[
                    const SizedBox(height: 32),
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
                      label: const Text('Upgrade to Pro Now'),
                    ),
                  ],
                ],
              ),
            ),

            // Features Grid
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pro Features',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ProFeatureCard(
                        icon: Icons.auto_awesome,
                        title: 'Unlimited AI Requests',
                        description: 'Access our advanced AI assistant with unlimited requests per day.',
                        isActive: membership.isPro,
                      ),
                      _ProFeatureCard(
                        icon: Icons.palette,
                        title: 'Premium Themes',
                        description: 'Choose from 5 exclusive pro themes including Ocean Wave and Gold Lux.',
                        isActive: membership.isPro,
                      ),
                      _ProFeatureCard(
                        icon: Icons.all_inclusive,
                        title: 'Full Content Access',
                        description: 'Access all premium recipes and advanced learning content.',
                        isActive: membership.isPro,
                      ),
                      _ProFeatureCard(
                        icon: Icons.trending_up,
                        title: 'Advanced Analytics',
                        description: 'Track your beverage learning progress with detailed statistics.',
                        isActive: membership.isPro,
                      ),
                      _ProFeatureCard(
                        icon: Icons.bookmark,
                        title: 'Unlimited Collections',
                        description: 'Create and organize unlimited custom drink collections.',
                        isActive: membership.isPro,
                      ),
                      _ProFeatureCard(
                        icon: Icons.priority_high,
                        title: 'Priority Support',
                        description: 'Get priority help from our support team.',
                        isActive: membership.isPro,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  
                  // Premium Themes Showcase
                  Text(
                    'Premium Themes Included',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: AppTheme.proVariants.map((variant) {
                        final seedColor = _getSeedColor(variant);
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            width: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  seedColor,
                                  seedColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: seedColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.palette,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppTheme.getVariantName(variant),
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 48),
                  
                  // Membership Info
                  if (membership.isPro)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.primary),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: colors.primary, size: 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Membership',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Member since ${membership.purchaseDate?.toString().split(' ')[0]}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
      default:
        return const Color(0xFF8E44AD);
    }
  }
}

class _ProFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isActive;

  const _ProFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? colors.primary : colors.outlineVariant,
            width: isActive ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isActive ? colors.primary : colors.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? colors.onSurface : colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isActive)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.lock_outline,
                  color: colors.primary,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
