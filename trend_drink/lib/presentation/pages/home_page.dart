import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier.dart';
import 'package:trenddrink/presentation/widgets/category_chips.dart';
import 'package:trenddrink/presentation/widgets/drink_card.dart';
import 'package:trenddrink/presentation/widgets/theme_switcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const categories = <String>['Hepsi', 'Kahve', 'Kokteyl', 'Frozen', 'Smoothie', 'Soda'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinkState = ref.watch(drinkNotifierProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final themeVariant = ref.watch(themeVariantProvider);
    final themeName = AppTheme.variantNames[themeVariant];

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('TrendDrink'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Windows için premium kafe deneyimi',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Renkli temalar, derin tarif rehberi ve akıllı asistan ile içecekleri keşfet.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 18),
                        Chip(
                          label: Text('Aktif Tema: $themeName'),
                          backgroundColor: Colors.white24,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: const [ThemeSwitcher()],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Stil & keşif',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(AppTheme.variantNames.length, (index) {
                      final label = AppTheme.variantNames[index];
                      final isSelected = themeVariant == index;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) => ref.read(themeVariantProvider.notifier).state = index,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Keşfedilecek kategoriler',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  CategoryChips(
                    categories: categories,
                    selectedCategory: selectedCategory ?? 'Hepsi',
                    onCategorySelected: (category) {
                      ref.read(selectedCategoryProvider.notifier).state = category == 'Hepsi' ? null : category;
                      ref.read(drinkNotifierProvider.notifier).filterByCategory(category == 'Hepsi' ? null : category);
                    },
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      context.push('/assistant');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Theme.of(context).colorScheme.primary.withAlpha(40),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.smart_toy_outlined, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Yapay zeka asistanımızla konuş, yeni tariflere ulaş.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Popüler tarifler',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          drinkState.when(
            data: (drinks) {
              if (drinks.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'Malzemelere göre öneriler hazırlanıyor.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final drink = drinks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: DrinkCard(
                          drink: drink,
                          onTap: () => context.push('/drink/${drink.id}'),
                        ),
                      );
                    },
                    childCount: drinks.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Bir sorun oluştu. Lütfen tekrar deneyin.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(themeModeProvider.notifier).toggleDarkMode(),
        icon: const Icon(Icons.brightness_6_outlined),
        label: const Text('Gece/Gündüz'),
      ),
    );
  }
}
