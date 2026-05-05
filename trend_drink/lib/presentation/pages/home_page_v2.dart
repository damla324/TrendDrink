import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

// ── Category meta ─────────────────────────────────────────────────────────
class _CategoryMeta {
  const _CategoryMeta({
    required this.name,
    required this.emoji,
    required this.imageUrl,
    required this.accentColor,
  });
  final String name;
  final String emoji;
  final String imageUrl;
  final Color accentColor;
}

const List<_CategoryMeta> _categories = [
  _CategoryMeta(
    name: 'Kahve',
    emoji: '☕',
    imageUrl:
        'https://images.unsplash.com/photo-1580613854894-37517173e659?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF8B4513),
  ),
  _CategoryMeta(
    name: 'Matcha',
    emoji: '🍵',
    imageUrl:
        'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF3CA55C),
  ),
  _CategoryMeta(
    name: 'Frozen',
    emoji: '🧊',
    imageUrl:
        'https://images.unsplash.com/photo-1572490122747-3968b75cc699?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF00BCD4),
  ),
  _CategoryMeta(
    name: 'Kokteyl',
    emoji: '🍹',
    imageUrl:
        'https://images.unsplash.com/photo-1595981267035-7b04ca84a82d?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFFE91E63),
  ),
  _CategoryMeta(
    name: 'Smoothie',
    emoji: '🥤',
    imageUrl:
        'https://images.unsplash.com/photo-1543255006-d6395b6f1171?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF8BC34A),
  ),
  _CategoryMeta(
    name: 'Çay',
    emoji: '🫖',
    imageUrl:
        'https://images.unsplash.com/photo-1576092762740-410023a10526?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF9C27B0),
  ),
  _CategoryMeta(
    name: 'Soda',
    emoji: '🫧',
    imageUrl:
        'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFFFFC107),
  ),
  _CategoryMeta(
    name: 'Fit',
    emoji: '💪',
    imageUrl:
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF4CAF50),
  ),
];

// ── Home Page ─────────────────────────────────────────────────────────────
class HomePageV2 extends ConsumerWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drinkNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.gold),
        ),
        error: (e, _) => Center(
          child: Text('Hata: $e',
              style: TextStyle(color: AppTheme.cream.withAlpha(180))),
        ),
        data: (drinks) => _HomeContent(drinks: drinks),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.drinks});
  final List<DrinkModel> drinks;

  @override
  Widget build(BuildContext context) {
    final trending = drinks.take(4).toList();
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final hPad = isMobile ? 20.0 : 48.0;
    final hPadInner = isMobile ? 16.0 : 40.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 56, hPad, 0),
            child: _HeroHeader(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, isMobile ? 32 : 48, hPad, 0),
            child: const _SectionLabel(
              label: 'Kategoriler',
              sublabel: 'Ne içmek istiyorsun?',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPadInner, 24, hPadInner, 0),
            child: _CategoryGrid(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, isMobile ? 36 : 52, hPad, 0),
            child: const _SectionLabel(
              label: 'Öne Çıkanlar',
              sublabel: 'Bugünün en popüler seçimleri',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPadInner, 24, hPadInner, 48),
            child: _TrendingRow(drinks: trending, isMobile: isMobile),
          ),
        ),
      ],
    );
  }
}

// ── Hero Header ───────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mükemmel İçeceğini\nKeşfet',
          style: GoogleFonts.playfairDisplay(
            fontSize: MediaQuery.sizeOf(context).width < 768 ? 28 : 46,
            fontWeight: FontWeight.w700,
            color: AppTheme.cream,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.15, end: 0),
        const SizedBox(height: 16),
        Text(
          'Kahveden matchaya, kokteyleden fit içeceklere — her damak zevkine göre özenle seçilmiş tarifler.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: MediaQuery.sizeOf(context).width < 768 ? 13 : 15,
            fontWeight: FontWeight.w400,
            color: AppTheme.dimCream.withAlpha(200),
            height: 1.6,
          ),
        ).animate().fadeIn(duration: 700.ms, delay: 150.ms),
        const SizedBox(height: 28),
        // CTA buttons
        Row(
          children: [
            _PrimaryButton(
              label: 'İçecek Keşfet',
              icon: Icons.explore_rounded,
              onTap: () => context.go('/category/Kahve'),
            ),
            const SizedBox(width: 12),
            _SecondaryButton(
              label: 'AI Öneri Al',
              icon: Icons.auto_awesome_rounded,
              onTap: () => context.go('/assistant'),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.gold.withAlpha(230)
                : AppTheme.gold.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.gold.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: AppTheme.espresso),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.espresso,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color:
                _hovered ? AppTheme.ledCyan.withAlpha(20) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppTheme.ledCyan.withAlpha(150)
                  : AppTheme.ledCyan.withAlpha(80),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: AppTheme.ledCyan),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ledCyan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.sublabel});
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 22,
              decoration: BoxDecoration(
                color: AppTheme.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppTheme.cream,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            sublabel,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.dimCream.withAlpha(160),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Category Grid ─────────────────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return Wrap(
      spacing: isMobile ? 12 : 24,
      runSpacing: isMobile ? 20 : 28,
      children: _categories.asMap().entries.map((entry) {
        return _CategoryCircle(
          meta: entry.value,
          delayMs: entry.key * 60,
        );
      }).toList(),
    );
  }
}

class _CategoryCircle extends StatefulWidget {
  const _CategoryCircle({required this.meta, required this.delayMs});
  final _CategoryMeta meta;
  final int delayMs;

  @override
  State<_CategoryCircle> createState() => _CategoryCircleState();
}

class _CategoryCircleState extends State<_CategoryCircle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final circleSize = isMobile ? 70.0 : 86.0;
    final boxWidth = isMobile ? 82.0 : 104.0;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/category/${widget.meta.name}'),
        child: SizedBox(
          width: boxWidth,
          child: Column(
            children: [
              // Circular image
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: widget.meta.accentColor.withAlpha(100),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withAlpha(80),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                  border: Border.all(
                    color: _hovered
                        ? widget.meta.accentColor.withAlpha(200)
                        : AppTheme.gold.withAlpha(50),
                    width: _hovered ? 2.5 : 1.5,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.meta.imageUrl,
                    fit: BoxFit.cover,
                    width: circleSize,
                    height: circleSize,
                    placeholder: (_, __) => Container(
                      color: AppTheme.mocha,
                      child: Center(
                        child: Text(
                          widget.meta.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.mocha,
                      child: Center(
                        child: Text(
                          widget.meta.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.meta.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
                  color: _hovered ? AppTheme.cream : AppTheme.dimCream,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: widget.delayMs))
        .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1));
  }
}

// ── Trending Row ──────────────────────────────────────────────────────────
class _TrendingRow extends StatelessWidget {
  const _TrendingRow({required this.drinks, required this.isMobile});
  final List<DrinkModel> drinks;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: drinks.length,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 200,
              child: Padding(
                padding:
                    EdgeInsets.only(right: index < drinks.length - 1 ? 12 : 0),
                child: _TrendingCard(
                  drink: drinks[index],
                  delayMs: index * 80,
                ),
              ),
            );
          },
        ),
      );
    }
    return Row(
      children: drinks.asMap().entries.map((entry) {
        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(right: entry.key < drinks.length - 1 ? 16 : 0),
            child: _TrendingCard(
              drink: entry.value,
              delayMs: entry.key * 80,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TrendingCard extends StatefulWidget {
  const _TrendingCard({required this.drink, required this.delayMs});
  final DrinkModel drink;
  final int delayMs;

  @override
  State<_TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<_TrendingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/drink/${widget.drink.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(120),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(60),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Drink image
                CachedNetworkImage(
                  imageUrl: widget.drink.imageUrl,
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
                        Colors.transparent,
                        AppTheme.espresso.withAlpha(220),
                      ],
                    ),
                  ),
                ),
                // Content
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppTheme.gold.withAlpha(60), width: 1),
                        ),
                        child: Text(
                          widget.drink.category,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.drink.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.cream,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Hover top-right badge
                if (_hovered)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withAlpha(220),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppTheme.espresso,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: widget.delayMs))
        .slideY(begin: 0.1, end: 0);
  }
}
