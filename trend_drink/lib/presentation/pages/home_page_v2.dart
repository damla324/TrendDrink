import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/category_meta.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/frosted_panel.dart';
import 'package:trenddrink/core/widgets/glow_box.dart';
import 'package:trenddrink/core/widgets/section_header_hero.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

/// Ana sayfa – modern karelaj. Büyük HD kategori kutuları + hover glow.
class HomePageV2 extends ConsumerWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinksAsync = ref.watch(drinkNotifierProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderHero(
            title: 'TrendDrink',
            subtitle: 'Lezzet, sanat ve teknolojinin buluştuğu içecek atölyen.',
            height: 180,
          ),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              'KATEGORİLER',
              style: AppTypography.label(
                size: 11,
                color: AppPalette.gold.withAlpha(220),
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: LayoutBuilder(builder: (ctx, c) {
              final cols = c.maxWidth >= 1280
                  ? 4
                  : c.maxWidth >= 980
                      ? 3
                      : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 22,
                  childAspectRatio: 16 / 11,
                ),
                itemBuilder: (_, i) => _CategoryTile(category: kCategories[i]),
              );
            }),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Row(
              children: [
                Text('ÖNE ÇIKAN İÇECEKLER',
                    style: AppTypography.label(
                      size: 11,
                      color: AppPalette.gold.withAlpha(220),
                      letterSpacing: 3,
                    )),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      context.go('/category/${kCategories.first.name}'),
                  child: Text('Tümünü Gör',
                      style: AppTypography.label(
                        size: 11,
                        color: AppPalette.gold,
                        letterSpacing: 1.4,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: drinksAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                    child: CircularProgressIndicator(color: AppPalette.gold)),
              ),
              error: (e, _) => Text('Hata: $e',
                  style: AppTypography.body(color: AppPalette.danger)),
              data: (drinks) {
                final featured = drinks.take(8).toList();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featured.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, i) {
                    final d = featured[i];
                    return GlowBox(
                      onTap: () => context.go('/drink/${d.id}'),
                      radius: 16,
                      child: FrostedPanel(
                        padding: const EdgeInsets.all(0),
                        radius: 16,
                        alpha: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: d.imageUrl.startsWith('http')
                                    ? CachedNetworkImage(
                                        imageUrl: d.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppPalette.mocha.withAlpha(200),
                                                AppPalette.espresso
                                                    .withAlpha(220),
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                            child: SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppPalette.gold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppPalette.mocha,
                                                AppPalette.cocoa,
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.local_cafe_rounded,
                                            color: AppPalette.gold,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        d.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppPalette.mocha,
                                                AppPalette.cocoa,
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.local_cafe_rounded,
                                            color: AppPalette.gold,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    d.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.label(
                                      size: 12,
                                      color: AppPalette.cream,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    d.category,
                                    style: AppTypography.body(
                                      size: 10,
                                      color: AppPalette.gold.withAlpha(200),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final CategoryMeta category;

  @override
  Widget build(BuildContext context) {
    return GlowBox(
      onTap: () => context.go('/category/${category.name}'),
      glowColor: category.accentColor,
      radius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              category.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppPalette.mocha),
            ),
            // Dark gradient overlay (alttan koyu, üst hafif transparan)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppPalette.obsidian.withAlpha(20),
                    AppPalette.obsidian.withAlpha(180),
                  ],
                ),
              ),
            ),
            // İçerik
            Positioned(
              left: 22,
              right: 22,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(category.emoji,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: category.accentColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: category.accentColor.withAlpha(120)),
                        ),
                        child: Text(
                          'KEŞFET',
                          style: AppTypography.label(
                            size: 9,
                            color: AppPalette.cream,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.display(
                      size: 22,
                      color: AppPalette.cream,
                      letterSpacing: 2,
                      weight: FontWeight.w700,
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
}
