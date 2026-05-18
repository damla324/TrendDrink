import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
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
            child: CircularProgressIndicator(color: AppTheme.gold)),
        error: (e, _) => Center(
          child: Text('Hata: $e',
              style: TextStyle(color: AppTheme.cream.withAlpha(180))),
        ),
        data: (drinks) {
          final filtered =
              drinks.where((d) => d.category == categoryName).toList();
          return _CategoryContent(
            categoryName: categoryName,
            drinks: filtered,
          );
        },
      ),
      // Mobile: floating back button
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: MediaQuery.sizeOf(context).width < 768
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E140A).withAlpha(220),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppTheme.gold.withAlpha(80)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: AppTheme.cream, size: 18),
                  ),
                ),
              ),
            )
          : null,
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

  // Representative image per category
  String get _coverImage {
    switch (categoryName) {
      case 'Kahve':
        return 'Assets/photos/kahve.jpg';
      case 'Matcha':
        return 'Assets/photos/matcha.jpg';
      case 'Frozen':
        return 'Assets/photos/frozen.jpg';
      case 'Kokteyl':
        return 'Assets/photos/kokteyl.jpg';
      case 'Smoothie':
        return 'Assets/photos/smothe.jpg';
      case 'Çay':
        return 'Assets/photos/çay.jpg';
      case 'Soda':
        return 'Assets/photos/soda.jpg';
      case 'Fit':
        return 'Assets/photos/fit.jpg';
      default:
        return 'Assets/photo/background.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Header banner ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _CategoryHero(
            name: categoryName,
            coverImage: _coverImage,
            drinkCount: drinks.length,
          ),
        ),
        // ── Drink grid ────────────────────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.sizeOf(context).width < 768 ? 16 : 40,
            36,
            MediaQuery.sizeOf(context).width < 768 ? 16 : 40,
            48,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _DrinkCircleCard(
                drink: drinks[index],
                delayMs: index * 60,
              ),
              childCount: drinks.length,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisExtent: 168,
              mainAxisSpacing: 28,
              crossAxisSpacing: 24,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Category Hero Banner ──────────────────────────────────────────────────
class _CategoryHero extends StatelessWidget {
  const _CategoryHero({
    required this.name,
    required this.coverImage,
    required this.drinkCount,
  });
  final String name;
  final String coverImage;
  final int drinkCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Cover image
          coverImage.startsWith('Assets/')
              ? Image.asset(
                  coverImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppTheme.mocha),
                )
              : CachedNetworkImage(
                  imageUrl: coverImage,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppTheme.mocha),
                  errorWidget: (_, __, ___) => Container(color: AppTheme.mocha),
                ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.espresso.withAlpha(100),
                  AppTheme.espresso.withAlpha(220),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 28,
            left: MediaQuery.sizeOf(context).width < 768 ? 20 : 48,
            right: MediaQuery.sizeOf(context).width < 768 ? 20 : 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: MediaQuery.sizeOf(context).width < 768 ? 28 : 40,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.cream,
                    letterSpacing: -0.3,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 6),
                Text(
                  '$drinkCount içecek seçeneği sizi bekliyor',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppTheme.dimCream.withAlpha(200),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Drink Circle Card ────────────────────────────────────────────────────
class _DrinkCircleCard extends StatefulWidget {
  const _DrinkCircleCard({required this.drink, required this.delayMs});
  final DrinkModel drink;
  final int delayMs;

  @override
  State<_DrinkCircleCard> createState() => _DrinkCircleCardState();
}

class _DrinkCircleCardState extends State<_DrinkCircleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/drink/${widget.drink.id}'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppTheme.gold.withAlpha(80),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha(70),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                border: Border.all(
                  color: _hovered
                      ? AppTheme.gold.withAlpha(200)
                      : AppTheme.gold.withAlpha(40),
                  width: _hovered ? 2.5 : 1.5,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.drink.imageUrl,
                  fit: BoxFit.cover,
                  width: 130,
                  height: 130,
                  placeholder: (_, __) => Container(color: AppTheme.mocha),
                  errorWidget: (_, __, ___) => Container(color: AppTheme.mocha),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.drink.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
                  color: _hovered ? AppTheme.cream : AppTheme.dimCream,
                  height: 1.3,
                ),
              ),
            ),
            if (_hovered)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  widget.drink.temperature,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppTheme.gold.withAlpha(200),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms, delay: Duration(milliseconds: widget.delayMs))
        .scale(begin: const Offset(0.88, 0.88), end: const Offset(1, 1));
  }
}
