import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';
import 'package:trenddrink/presentation/widgets/drink_card.dart';

class CategoryPage extends ConsumerWidget {
  final String categoryName;

  const CategoryPage({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinkList = ref.watch(drinkNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: drinkList.when(
        data: (drinks) {
          // Filter drinks by category
          final categoryDrinks = drinks
              .where((drink) => drink.category == categoryName)
              .toList();

          if (categoryDrinks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_drink_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Bu kategoride içecek bulunamadı',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${categoryDrinks.length} içecek',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categoryDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = categoryDrinks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DrinkCard(
                        drink: drink,
                        onTap: () => context.go('/drink/${drink.id}'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
