import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/theme/app_theme_enhanced.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier_v2.dart';

class DesktopSidebar extends ConsumerWidget {
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const DesktopSidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final currentTheme = ref.watch(themeVariantProvider);
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 80 : 280,
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with logo
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 8 : 16,
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isCollapsed)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TrendDrink',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                        Text(
                          membership.isPro ? '✨ Pro Member' : 'Free Plan',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: membership.isPro ? const Color(0xFFFFD700) : colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    color: colors.onSurface,
                  ),
                  onPressed: onToggleCollapse,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Main navigation
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SidebarSection(
                    title: 'Navigation',
                    isCollapsed: isCollapsed,
                    items: [
                      _SidebarItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        onTap: () => context.go('/'),
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.auto_awesome,
                        label: 'AI Assistant',
                        onTap: () => context.go('/assistant'),
                        isPro: true,
                        membership: membership,
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.local_cafe,
                        label: 'Categories',
                        onTap: () => context.go('/category/all'),
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.favorite,
                        label: 'Favorites',
                        onTap: () {},
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.star,
                        label: 'Pro Features',
                        onTap: () => context.go('/pro'),
                        isCollapsed: isCollapsed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SidebarSection(
                    title: 'Themes',
                    isCollapsed: isCollapsed,
                    items: [
                      ...(membership.isPro 
                        ? AppTheme.freeVariants + AppTheme.proVariants
                        : AppTheme.freeVariants
                      ).map((variant) {
                        final isSelected = currentTheme == variant;
                        return _ThemeOption(
                          variant: variant,
                          isSelected: isSelected,
                          isCollapsed: isCollapsed,
                          onTap: () {
                            ref.read(themeVariantProvider.notifier).setTheme(variant);
                          },
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // Footer
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 8 : 16,
              vertical: 12,
            ),
            child: Column(
              children: [
                if (!membership.isPro)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showProUpgradeDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                      ),
                      child: isCollapsed
                        ? const Icon(Icons.star, size: 20)
                        : const Text('Upgrade to Pro'),
                    ),
                  ),
                const SizedBox(height: 8),
                _SidebarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () => context.push('/settings'),
                  isCollapsed: isCollapsed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProUpgradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: const Text(
          'Get unlimited access to AI features, premium themes, and more exclusive content. Upgrade now to unlock the full potential!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(membershipProvider.notifier).upgradeToPro();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎉 Welcome to Pro! Enjoy unlimited features!')),
              );
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final bool isCollapsed;
  final List<Widget> items;

  const _SidebarSection({
    required this.title,
    required this.isCollapsed,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isCollapsed) return Column(children: items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

class _SidebarItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isCollapsed;
  final bool isPro;
  final dynamic membership;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isCollapsed,
    this.isPro = false,
    this.membership,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isProLocked = isPro && (membership == null || !membership.isPro);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 4 : 12,
        vertical: 4,
      ),
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: isCollapsed ? label : '',
          child: InkWell(
            onTap: isProLocked ? null : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 12,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isProLocked ? colors.onSurfaceVariant.withOpacity(0.5) : colors.primary,
                    size: 20,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isProLocked ? colors.onSurfaceVariant.withOpacity(0.5) : colors.onSurface,
                        ),
                      ),
                    ),
                    if (isProLocked)
                      Icon(Icons.lock_outline, size: 14, color: colors.primary),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends ConsumerWidget {
  final ThemeVariant variant;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.variant,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = AppTheme.isProVariant(variant);
    final colors = Theme.of(context).colorScheme;
    final seedColor = _getSeedColor();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 4 : 12,
        vertical: 4,
      ),
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: isCollapsed ? AppTheme.getVariantName(variant) : '',
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: seedColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                        ? Border.all(color: colors.primary, width: 2)
                        : Border.all(color: colors.outlineVariant),
                    ),
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTheme.getVariantName(variant),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          if (isPro)
                            Text(
                              'Pro',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: const Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: colors.primary, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getSeedColor() {
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
