import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/category_meta.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/glow_box.dart';
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
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 28, 36, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TrendDrink',
                  style: AppTypography.display(
                    size: 32,
                    color: AppPalette.cream,
                    letterSpacing: 1.2,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Lezzet, sanat ve teknolojinin buluştuğu içecek atölyen.',
                  style: AppTypography.body(
                    size: 13,
                    color: AppPalette.dimCream.withAlpha(180),
                  ),
                ),
              ],
            ),
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
          drinksAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                  child: CircularProgressIndicator(color: AppPalette.gold)),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text('Hata: $e',
                  style: AppTypography.body(color: AppPalette.danger)),
            ),
            data: (drinks) => _FeaturedSection(drinks: drinks.toList()),
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

// ── Featured Section — infinite auto-scroll horizontal ────────────────────────
const double _kFeaturedCardWidth = 180.0;
const double _kFeaturedCardSpacing = 14.0;

class _FeaturedSection extends StatefulWidget {
  const _FeaturedSection({required this.drinks});
  final List drinks;

  @override
  State<_FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<_FeaturedSection>
    with SingleTickerProviderStateMixin {
  late final ScrollController _sc;
  Ticker? _ticker;
  bool _paused = false;
  Duration? _lastTick;

  static const double _pxPerMs = 0.05;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_paused || !_sc.hasClients) return;
    _lastTick ??= elapsed;
    final dt = (elapsed - _lastTick!).inMilliseconds.toDouble();
    _lastTick = elapsed;
    if (!_sc.position.hasContentDimensions) return;
    final max = _sc.position.maxScrollExtent;
    if (max <= 0) return;
    final next = _sc.offset + dt * _pxPerMs;
    _sc.jumpTo(next > max ? 0 : next);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _paused = true,
      onExit: (_) => _paused = false,
      child: SizedBox(
        height: 240,
        child: ListView.separated(
          controller: _sc,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 36),
          itemCount: widget.drinks.length * 100,
          separatorBuilder: (_, __) =>
              const SizedBox(width: _kFeaturedCardSpacing),
          itemBuilder: (_, i) {
            final d = widget.drinks[i % widget.drinks.length];
            return _FeaturedCard(drink: d);
          },
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatefulWidget {
  const _FeaturedCard({required this.drink});
  final dynamic drink;

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.drink;
    return GestureDetector(
      onTap: () => context.go('/drink/${d.id}'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: _kFeaturedCardWidth,
          transform: _hovered
              ? (Matrix4.identity()..translate(0.0, -6.0))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _hovered ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: d.imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: d.imageUrl as String,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            decoration: BoxDecoration(gradient: d.gradient),
                          ),
                        )
                      : Image.asset(
                          d.imageUrl as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(gradient: d.gradient),
                          ),
                        ),
                ),
                // Bottom gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(210),
                      ],
                    ),
                  ),
                ),
                // Category + title
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppPalette.gold.withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: AppPalette.gold.withAlpha(100)),
                        ),
                        child: Text(
                          (d.category as String).toUpperCase(),
                          style: AppTypography.label(
                            size: 8,
                            color: AppPalette.cream,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d.title as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label(
                          size: 12,
                          color: AppPalette.cream,
                          letterSpacing: 0.3,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Hover glow border
                if (_hovered)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppPalette.gold.withAlpha(160),
                        width: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
