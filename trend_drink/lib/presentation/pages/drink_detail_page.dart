import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/i18n/app_strings.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

class DrinkDetailPage extends ConsumerWidget {
  const DrinkDetailPage({super.key, required this.drinkId});
  final String drinkId;

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
          final drink = drinks.cast<DrinkModel?>().firstWhere(
                (d) => d?.id == drinkId,
                orElse: () => null,
              );
          if (drink == null) {
            return Center(
              child: Text('İçecek bulunamadı.',
                  style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.cream.withAlpha(160))),
            );
          }
          final related = drinks
              .where((d) => d.category == drink.category && d.id != drink.id)
              .take(6)
              .toList();
          return _DrinkDetailContent(drink: drink, related: related);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
class _DrinkDetailContent extends StatelessWidget {
  const _DrinkDetailContent({required this.drink, required this.related});
  final DrinkModel drink;
  final List<DrinkModel> related;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= 768;
    final hPad = isDesktop ? 48.0 : 20.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _HeroSection(drink: drink)),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(hPad, isDesktop ? 40.0 : 28.0, hPad, 0),
            child: _BodyContent(drink: drink, related: related),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ── Hero Section ──────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.drink});
  final DrinkModel drink;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= 768;

    return SizedBox(
      height: isDesktop ? 420.0 : 340.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(),
          // Bottom-only fade (let top of image breathe)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.30, 0.70, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppPalette.obsidian.withAlpha(140),
                  AppPalette.obsidian.withAlpha(250),
                ],
              ),
            ),
          ),
          // Floating back + AI nav
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GlassNavButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/'),
                ),
                _AiChip(drinkTitle: drink.title),
              ],
            ),
          ),
          // Title block at bottom
          Positioned(
            bottom: 28,
            left: isDesktop ? 48 : 20,
            right: isDesktop ? 48 : 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _TemperatureBadge(temperature: drink.temperature),
                    _CategoryBadge(category: drink.category),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  drink.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isDesktop ? 40 : 28,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.cream,
                    height: 1.15,
                    shadows: [
                      Shadow(
                          color: Colors.black.withAlpha(220), blurRadius: 18),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.05),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(80),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        drink.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppPalette.dimCream.withAlpha(230),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 80.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final url = drink.imageUrl;
    if (!url.startsWith('http')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Container(decoration: BoxDecoration(gradient: drink.gradient)),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          Container(decoration: BoxDecoration(gradient: drink.gradient)),
      errorWidget: (_, __, ___) =>
          Container(decoration: BoxDecoration(gradient: drink.gradient)),
    );
  }
}

// ── Body Content ──────────────────────────────────────────────────────────────
class _BodyContent extends ConsumerWidget {
  const _BodyContent({required this.drink, required this.related});
  final DrinkModel drink;
  final List<DrinkModel> related;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: s.historyTitle),
        const SizedBox(height: 14),
        _GlassCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.history_edu_rounded,
                  color: AppPalette.gold.withAlpha(180), size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  drink.history,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: AppPalette.dimCream.withAlpha(220),
                      height: 1.7),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 50.ms),
        const SizedBox(height: 36),
        _SectionHeader(label: s.prosConsTitle),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ProsCard(pros: drink.pros, s: s)),
            SizedBox(width: isDesktop ? 16.0 : 10.0),
            Expanded(child: _ConsCard(cons: drink.cons, s: s)),
          ],
        ).animate().fadeIn(duration: 450.ms, delay: 100.ms),
        const SizedBox(height: 12),
        _SuggestionChip(drinkTitle: drink.title, s: s),
        const SizedBox(height: 36),
        _SectionHeader(label: s.preparationTitle),
        const SizedBox(height: 14),
        _PreparationCard(preparation: drink.preparation),
        const SizedBox(height: 20),
        if (drink.tip.isNotEmpty) ...[
          _TipCard(tip: drink.tip, s: s),
          const SizedBox(height: 36),
        ],
        if (related.isNotEmpty) ...[
          _SectionHeader(label: s.suggestionsTitle),
          const SizedBox(height: 14),
          _RelatedDrinks(drinks: related),
        ],
      ],
    );
  }
}

// ── Suggestion Chip ───────────────────────────────────────────────────────────
class _SuggestionChip extends StatefulWidget {
  const _SuggestionChip({required this.drinkTitle, required this.s});
  final String drinkTitle;
  final AppStrings s;
  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/assistant'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: _hovered
                    ? AppPalette.ledCyan.withAlpha(25)
                    : AppPalette.obsidian.withAlpha(150),
                border: Border.all(
                  color: _hovered
                      ? AppPalette.ledCyan.withAlpha(160)
                      : AppPalette.ledCyan.withAlpha(50),
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                            color: AppPalette.ledCyan.withAlpha(40),
                            blurRadius: 18),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AppPalette.ledCyan, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.s.isTr
                          ? '${widget.drinkTitle} için kişisel öneri almak ister misin?'
                          : 'Want a personalised recommendation for ${widget.drinkTitle}?',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppPalette.dimCream,
                          height: 1.4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.s.askAI,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.ledCyan,
                        letterSpacing: 0.4),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppPalette.ledCyan, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 180.ms);
  }
}

// ── Related Drinks ────────────────────────────────────────────────────────────
class _RelatedDrinks extends StatelessWidget {
  const _RelatedDrinks({required this.drinks});
  final List<DrinkModel> drinks;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: drinks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _RelatedCard(drink: drinks[i]),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 150.ms);
  }
}

class _RelatedCard extends StatefulWidget {
  const _RelatedCard({required this.drink});
  final DrinkModel drink;
  @override
  State<_RelatedCard> createState() => _RelatedCardState();
}

class _RelatedCardState extends State<_RelatedCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final d = widget.drink;
    final isLocal = !d.imageUrl.startsWith('http');
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/drink/${d.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 115,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? AppPalette.gold.withAlpha(180)
                  : AppPalette.gold.withAlpha(40),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: AppPalette.gold.withAlpha(50), blurRadius: 14)
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(fit: StackFit.expand, children: [
              isLocal
                  ? Image.asset(d.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(gradient: d.gradient)))
                  : CachedNetworkImage(
                      imageUrl: d.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                          decoration: BoxDecoration(gradient: d.gradient))),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withAlpha(200)],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(d.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label(
                        size: 10, color: AppPalette.cream, letterSpacing: 0.2)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Glass Card ────────────────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppPalette.obsidian.withAlpha(140),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.gold.withAlpha(35)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppPalette.goldAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(label,
            style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppPalette.cream)),
      ],
    );
  }
}

// ── Pros Card ─────────────────────────────────────────────────────────────────
class _ProsCard extends StatelessWidget {
  const _ProsCard({required this.pros, required this.s});
  final List<String> pros;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2ECC71);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0D2818).withAlpha(170),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.thumb_up_rounded, color: accent, size: 16),
                const SizedBox(width: 8),
                Text(s.benefitsLabel,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: accent)),
              ]),
              const SizedBox(height: 12),
              ...pros.map((p) => _BulletItem(text: p, color: accent)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Cons Card ─────────────────────────────────────────────────────────────────
class _ConsCard extends StatelessWidget {
  const _ConsCard({required this.cons, required this.s});
  final List<String> cons;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE74C3C);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0A0A).withAlpha(170),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.warning_amber_rounded,
                    color: accent, size: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(s.cautionsLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: accent)),
                ),
              ]),
              const SizedBox(height: 12),
              ...cons.map((c) => _BulletItem(text: c, color: accent)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: AppPalette.dimCream.withAlpha(200),
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}

// ── Preparation Card ──────────────────────────────────────────────────────────
class _PreparationCard extends StatelessWidget {
  const _PreparationCard({required this.preparation});
  final String preparation;

  @override
  Widget build(BuildContext context) {
    final lines = preparation.split('\n');
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppPalette.cocoa.withAlpha(150),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.gold.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines.map((line) {
              if (line.isEmpty) return const SizedBox(height: 8);
              final isBold = line.endsWith(':') ||
                  line.startsWith('Malzeme') ||
                  line.startsWith('Yapılış') ||
                  line.startsWith('Ingre') ||
                  line.startsWith('Steps') ||
                  line.startsWith('Method');
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(line,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                      color: isBold
                          ? AppPalette.caramel
                          : AppPalette.dimCream.withAlpha(200),
                      height: 1.6,
                    )),
              );
            }).toList(),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 150.ms);
  }
}

// ── Tip Card ──────────────────────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.s});
  final String tip;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPalette.gold.withAlpha(18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppPalette.gold.withAlpha(60)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_rounded,
                  color: AppPalette.gold, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(tip,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppPalette.caramel,
                        height: 1.5,
                        fontStyle: FontStyle.italic)),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 450.ms, delay: 200.ms);
  }
}

// ── Glass Nav Button ──────────────────────────────────────────────────────────
class _GlassNavButton extends StatefulWidget {
  const _GlassNavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  State<_GlassNavButton> createState() => _GlassNavButtonState();
}

class _GlassNavButtonState extends State<_GlassNavButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered
                    ? Colors.white.withAlpha(40)
                    : Colors.black.withAlpha(80),
                border: Border.all(
                    color: AppPalette.gold.withAlpha(_hovered ? 200 : 70)),
              ),
              child: Icon(widget.icon, color: AppPalette.cream, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

// ── AI Chip ───────────────────────────────────────────────────────────────────
class _AiChip extends StatefulWidget {
  const _AiChip({required this.drinkTitle});
  final String drinkTitle;
  @override
  State<_AiChip> createState() => _AiChipState();
}

class _AiChipState extends State<_AiChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/assistant'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _hovered
                    ? AppPalette.ledCyan.withAlpha(30)
                    : Colors.black.withAlpha(80),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hovered
                      ? AppPalette.ledCyan.withAlpha(200)
                      : AppPalette.ledCyan.withAlpha(90),
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                            color: AppPalette.ledCyan.withAlpha(60),
                            blurRadius: 14),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AppPalette.ledCyan, size: 14),
                  const SizedBox(width: 6),
                  Text('AI ile Sor',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.ledCyan)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Temperature Badge ─────────────────────────────────────────────────────────
class _TemperatureBadge extends StatelessWidget {
  const _TemperatureBadge({required this.temperature});
  final String temperature;

  @override
  Widget build(BuildContext context) {
    final isHot = temperature == 'Sıcak' || temperature == 'Hot';
    final color = isHot ? Colors.orange : Colors.lightBlue;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(120)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isHot
                    ? Icons.local_fire_department_rounded
                    : Icons.ac_unit_rounded,
                color: color,
                size: 12,
              ),
              const SizedBox(width: 5),
              Text(temperature,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Badge ────────────────────────────────────────────────────────────
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppPalette.gold.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppPalette.gold.withAlpha(90)),
          ),
          child: Text(category,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.gold,
                  letterSpacing: 0.5)),
        ),
      ),
    );
  }
}
