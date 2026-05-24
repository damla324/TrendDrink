import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/category_meta.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/section_header_hero.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drinkNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: state.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppPalette.gold)),
        error: (e, _) => Center(
          child: Text('Hata: $e',
              style: AppTypography.body(color: AppPalette.cream)),
        ),
        data: (drinks) {
          final filtered =
              drinks.where((d) => d.category == categoryName).toList();
          return _CategoryContent(categoryName: categoryName, drinks: filtered);
        },
      ),
    );
  }
}

class _CategoryContent extends StatelessWidget {
  const _CategoryContent({
    required this.categoryName,
    required this.drinks,
  });
  final String categoryName;
  final List<DrinkModel> drinks;

  CategoryMeta? get _meta {
    try {
      return kCategories.firstWhere((c) => c.name == categoryName);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final hPad = isMobile ? 16.0 : 40.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeaderHero(
            title: categoryName,
            subtitle:
                '${drinks.length} özenle seçilmiş tarif · ${_meta?.emoji ?? ""}',
            height: 180,
            actions: [
              if (!isMobile)
                IconButton(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: AppPalette.cream, size: 22),
                  tooltip: 'Ana sayfa',
                ),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 50),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _DrinkCard(
                drink: drinks[index],
                delayMs: index * 60,
                accent: _meta?.accentColor ?? AppPalette.gold,
              ),
              childCount: drinks.length,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 270,
              mainAxisSpacing: 22,
              crossAxisSpacing: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _DrinkCard extends StatefulWidget {
  const _DrinkCard(
      {required this.drink, required this.delayMs, required this.accent});
  final DrinkModel drink;
  final int delayMs;
  final Color accent;

  @override
  State<_DrinkCard> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<_DrinkCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.go('/drink/${widget.drink.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_hover ? 1.025 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppPalette.mocha.withAlpha(180),
            border: Border.all(
              color: _hover
                  ? widget.accent.withAlpha(190)
                  : AppPalette.gold.withAlpha(30),
              width: _hover ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withAlpha(_hover ? 90 : 0),
                blurRadius: 22,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.drink.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppPalette.mocha.withAlpha(220),
                                AppPalette.espresso.withAlpha(240),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
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
                                widget.accent.withAlpha(60),
                                AppPalette.mocha,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.local_cafe_rounded,
                                color: AppPalette.gold, size: 36),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppPalette.obsidian.withAlpha(170),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppPalette.obsidian.withAlpha(160),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: widget.accent.withAlpha(120)),
                          ),
                          child: Text(
                            widget.drink.temperature,
                            style: AppTypography.label(
                              size: 9,
                              color: AppPalette.cream,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.drink.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label(
                          size: 13,
                          color: AppPalette.cream,
                          letterSpacing: 0.4,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.drink.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body(
                          size: 11,
                          color: AppPalette.dimCream.withAlpha(180),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: widget.delayMs))
          .fadeIn(duration: 360.ms)
          .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic),
    );
  }
}
