import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/category_meta.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

class HomePageV2 extends ConsumerWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinkList = ref.watch(drinkNotifierProvider);
    
    // Category metadata with emojis and colors
    final categoryData = {
      'Kahve': {'emoji': '☕', 'color': const Color(0xFF8B4513)},
      'Kokteyl': {'emoji': '🍹', 'color': const Color(0xFFE91E63)},
      'Frozen': {'emoji': '🧊', 'color': const Color(0xFF00BCD4)},
      'Smoothie': {'emoji': '🥤', 'color': const Color(0xFF8BC34A)},
      'Soda': {'emoji': '🥃', 'color': const Color(0xFFFFC107)},
      'Çay': {'emoji': '🫖', 'color': const Color(0xFF9C27B0)},
      'Fit': {'emoji': '💪', 'color': const Color(0xFF4CAF50)},
      'Matcha': {'emoji': '🍵', 'color': const Color(0xFF558B2F)},
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('TrendDrink'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: drinkList.when(
        data: (drinks) {
          // Group drinks by category
          final categoryDrinks = <String, int>{};
          for (var drink in drinks) {
            categoryDrinks[drink.category] = (categoryDrinks[drink.category] ?? 0) + 1;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Sliding Announcement Banner
                const _SlidingBanner(),

                // Header section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategoriler',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${drinks.length} içecek',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Category Grid (GetirMarket style - 4 columns)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: categoryData.length,
                  itemBuilder: (context, index) {
                    final categoryName = categoryData.keys.toList()[index];
                    final cat = categoryData[categoryName]!;
                    final count = categoryDrinks[categoryName] ?? 0;

                    return GestureDetector(
                      onTap: () {
                        // Navigate to category page
                        context.go('/category/$categoryName');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Square category button with asset image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (cat['color'] as Color).withAlpha(128),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (cat['color'] as Color).withAlpha(26),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                _categoryAssetImage(categoryName),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: (cat['color'] as Color).withAlpha(38),
                                  child: Center(
                                    child: Text(
                                      cat['emoji'] as String,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Category name
                          Text(
                            categoryName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          // Drink count
                          Text(
                            '$count',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // All Drinks section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tüm İçecekler',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Tümünü Gör'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // All drinks list (vertical scroll)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => context.go('/drink/${drink.id}'),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            drink.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                          ),
                        ),
                        title: Text(
                          drink.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          drink.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Chip(
                          label: Text(
                            drink.category,
                            style: const TextStyle(fontSize: 11),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
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

  String _categoryAssetImage(String categoryName) {
    try {
      return kCategories
          .firstWhere((cat) => cat.name == categoryName)
          .imageUrl;
    } catch (_) {
      return 'Assets/photo/background.png';
    }
  }
}

class _SlidingBanner extends StatefulWidget {
  const _SlidingBanner();

  @override
  State<_SlidingBanner> createState() => _SlidingBannerState();
}

class _SlidingBannerState extends State<_SlidingBanner> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    while (_scrollController.hasClients) {
      await Future.delayed(const Duration(seconds: 1));
      if (_scrollController.hasClients) {
        final maxExtent = _scrollController.position.maxScrollExtent;
        await _scrollController.animateTo(
          maxExtent,
          duration: Duration(milliseconds: (maxExtent * 40).toInt()),
          curve: Curves.linear,
        );
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = 'TrendDrink\'e Hoş Geldiniz! 🍹 En güncel ve lezzetli içecek tariflerini keşfedin. 🍵 AI Asistanımız ile elinizdeki malzemelere göre anında tarif önerileri alın! ✨ Favori içeceklerinizi kaydedin ve kendi listenizi oluşturun. 🥤 Sağlıklı yaşam için "Fit" kategorimize göz atmayı unutmayın! 🌿';
    
    return Container(
      height: 36,
      width: double.infinity,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
