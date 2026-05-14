import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

/// Wrapper for AI features that enforces pro membership
class AIFeatureGate extends ConsumerWidget {
  final Widget proWidget;
  final String featureName;

  const AIFeatureGate({
    super.key,
    required this.proWidget,
    this.featureName = 'AI Features',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final colors = Theme.of(context).colorScheme;

    if (!membership.isPro && !membership.canAccessAI) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$featureName Locked',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This feature is only available for Pro members.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have used all your daily AI requests. Upgrade to Pro for unlimited access!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(membershipProvider.notifier).upgradeToPro();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Welcome to Pro! Enjoy unlimited features!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.star),
                    label: const Text('Upgrade to Pro Now'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get unlimited AI requests, premium themes, and much more!',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (membership.isPro) {
      return proWidget;
    }

    // User has free requests remaining
    return Column(
      children: [
        Container(
          color: colors.primaryContainer,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info, color: colors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You have ${membership.aiRequestsRemaining} AI requests remaining today.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: proWidget),
      ],
    );
  }
}
