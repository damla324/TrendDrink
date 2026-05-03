import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

class DrinkDetailPage extends ConsumerWidget {
  const DrinkDetailPage({super.key, required this.drinkId});

  final String drinkId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinksState = ref.watch(drinkNotifierProvider);
    return drinksState.when(
      data: (drinks) {
        final drink = drinks.firstWhere(
          (item) => item.id == drinkId,
          orElse: () => DrinkModel(
            id: '',
            title: 'Tarif bulunamadı',
            description: 'Seçilen içecek henüz mevcut değil.',
            category: '',
            preparation: '',
            ingredients: <String>[],
            imageUrl: '',
            gradient: const LinearGradient(colors: [Colors.grey, Colors.black]),
          ),
        );
        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 260,
                backgroundColor: Theme.of(context).colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(drink.title),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: drink.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.black12),
                        errorWidget: (context, url, error) => Container(color: Colors.black26),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.transparent,
                              Colors.black.withOpacity(0.72),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              drink.category.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        drink.description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Malzemeler',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: drink.ingredients
                            .map((ingredient) => Chip(label: Text(ingredient)))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Hazırlık',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        drink.preparation,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Geri dön'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text(
            'Tarif yüklenemedi.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
