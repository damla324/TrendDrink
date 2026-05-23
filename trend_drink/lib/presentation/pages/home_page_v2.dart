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
      'Kahve': {'emoji': '☕'},
      'Kokteyl': {'emoji': '🍹'},
      'Smoothie': {'emoji': '🥤'},
      'Soda': {'emoji': '🥃'},
      'Çay': {'emoji': '🫖'},
      'Frozen': {'emoji': '🧊'},
    };

    return Scaffold(
      body: Row(
        children: [
          // --- Left Sidebar (Masaüstü Navigasyon) ---
          Container(
            width: 280,
            color: const Color(0xFF2C1810), // Koyu Kahve
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 60, 24, 40),
                  child: Row(
                    children: [
                      Icon(Icons.local_bar, color: Color(0xFFFFD700), size: 32),
                      SizedBox(width: 12),
                      Text(
                        'TrendDrink',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildMenuItem('Ana Sayfa', Icons.home_outlined, true),
                _buildMenuItem('Kahve Türleri', Icons.coffee_outlined, false),
                _buildMenuItem('Kokteyl & Frozen', Icons.icecream_outlined, false),
                _buildMenuItem('Sağlıklı Seçenekler', Icons.fitness_center_outlined, false),
                _buildMenuItem('Çay & Soda', Icons.local_drink_outlined, false),
                const Spacer(),
                const _SlidingBanner(),
              ],
            ),
          ),

          // --- Main Content Area (Full-Bleed Grid) ---
          Expanded(
            child: drinkList.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (drinks) => SingleChildScrollView(
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Tam 3 satır sığması için oranı hesaplıyoruz
                        final double itemWidth = constraints.maxWidth / 2;
                        final double itemHeight = constraints.maxHeight / 3;
                        final double ratio = itemWidth / itemHeight;

                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              childAspectRatio: ratio,
                            ),
                            itemCount: categoryData.length,
                            itemBuilder: (context, index) {
                              final categoryName = categoryData.keys.toList()[index];
                              return InkWell(
                                onTap: () => context.go('/category/$categoryName'),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        _categoryAssetImage(categoryName),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.black.withOpacity(0.4),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      left: 30,
                                      child: Text(
                                        categoryName.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2.0,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
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
                              ),
                            ),
                            title: Text(
                              drink.title,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              drink.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Chip(label: Text(drink.category)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: isActive ? const Color(0xFFFFD700) : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive ? Colors.white.withOpacity(0.05) : Colors.transparent,
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
