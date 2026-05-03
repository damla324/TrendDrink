import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier.dart';
import 'package:trenddrink/presentation/widgets/category_chips.dart';
import 'package:trenddrink/presentation/widgets/drink_card.dart';
import 'package:trenddrink/presentation/widgets/theme_switcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const categories = <String>['Hepsi', 'Kahve', 'Kokteyl', 'Frozen'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinkState = ref.watch(drinkNotifierProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
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
                child: const SafeArea(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Kafe deneyimini öğren, AI asistanla keşfet.',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: const [ThemeSwitcher()],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Kategorilere göre seç',
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
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.push('/search');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.search, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Asistanımıza yazarak içeceği bul',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Yeni tarifler',
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
                      'Yeni tarifler yakında eklenecek.',
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
        icon: const Icon(Icons.palette_outlined),
        label: const Text('Tema'),
      ),
    );
  }
}
