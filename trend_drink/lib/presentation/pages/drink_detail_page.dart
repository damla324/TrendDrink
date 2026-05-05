import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
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
              child: Text(
                'İçecek bulunamadı.',
                style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.cream.withAlpha(160)),
              ),
            );
          }
          return _DrinkDetailContent(drink: drink);
        },
      ),
    );
  }
}

class _DrinkDetailContent extends StatelessWidget {
  const _DrinkDetailContent({required this.drink});
  final DrinkModel drink;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _HeroSection(drink: drink)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                isMobile ? 20 : 48, isMobile ? 28 : 40, isMobile ? 20 : 48, 0),
            child: _BodyContent(drink: drink),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }
}

// ── Hero Section ──────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.drink});
  final DrinkModel drink;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return SizedBox(
      height: isMobile ? 310 : 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          CachedNetworkImage(
            imageUrl: drink.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppTheme.mocha),
            errorWidget: (_, __, ___) => Container(color: AppTheme.mocha),
          ),
          // Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.55, 1.0],
                colors: [
                  Colors.black.withAlpha(40),
                  Colors.transparent,
                  AppTheme.espresso.withAlpha(240),
                ],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 20,
            left: 20,
            child: _BackButton(),
          ),
          // AI button (top right)
          Positioned(
            top: 20,
            right: 20,
            child: _AiButton(drinkTitle: drink.title),
          ),
          // Title block
          Positioned(
            bottom: 24,
            left: isMobile ? 20 : 48,
            right: isMobile ? 20 : 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TemperatureBadge(temperature: drink.temperature),
                    const SizedBox(width: 8),
                    _CategoryBadge(category: drink.category),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  drink.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isMobile ? 26 : 36,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.cream,
                    height: 1.2,
                    shadows: [
                      Shadow(color: Colors.black.withAlpha(180), blurRadius: 12)
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                const SizedBox(height: 8),
                Text(
                  drink.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.dimCream.withAlpha(220),
                    height: 1.5,
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

// ── Body Content ──────────────────────────────────────────────────────────
class _BodyContent extends StatelessWidget {
  const _BodyContent({required this.drink});
  final DrinkModel drink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // History card
        _SectionHeader(label: 'Tarih & Kültür'),
        const SizedBox(height: 14),
        _HistoryCard(history: drink.history),
        const SizedBox(height: 36),
        // Pros & Cons
        _SectionHeader(label: 'Artıları ve Eksileri'),
        const SizedBox(height: 14),
        _ProsConsRow(pros: drink.pros, cons: drink.cons),
        const SizedBox(height: 36),
        // Preparation
        _SectionHeader(label: 'Hazırlanışı'),
        const SizedBox(height: 14),
        _PreparationCard(preparation: drink.preparation),
        const SizedBox(height: 28),
        // Tip
        if (drink.tip.isNotEmpty) _TipCard(tip: drink.tip),
      ],
    );
  }
}

// ── Reusable Section Header ───────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.cream,
          ),
        ),
      ],
    );
  }
}

// ── History Card ──────────────────────────────────────────────────────────
class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.history});
  final String history;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.mocha.withAlpha(160),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.gold.withAlpha(30), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history_edu_rounded,
              color: AppTheme.gold.withAlpha(180), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              history,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: AppTheme.dimCream.withAlpha(220),
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }
}

// ── Pros & Cons ───────────────────────────────────────────────────────────
class _ProsConsRow extends StatelessWidget {
  const _ProsConsRow({required this.pros, required this.cons});
  final List<String> pros;
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _ProsCard(pros: pros)),
        SizedBox(width: isMobile ? 10 : 16),
        Expanded(child: _ConsCard(cons: cons)),
      ],
    );
  }
}

class _ProsCard extends StatelessWidget {
  const _ProsCard({required this.pros});
  final List<String> pros;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2818).withAlpha(200),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF2ECC71).withAlpha(60), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.thumb_up_rounded,
                  color: Color(0xFF2ECC71), size: 16),
              const SizedBox(width: 8),
              Text(
                'Faydaları',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...pros.map((pro) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2ECC71),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pro,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppTheme.dimCream.withAlpha(200),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms, delay: 150.ms);
  }
}

class _ConsCard extends StatelessWidget {
  const _ConsCard({required this.cons});
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0A).withAlpha(200),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFFE74C3C).withAlpha(60), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.thumb_down_rounded,
                  color: Color(0xFFE74C3C), size: 16),
              const SizedBox(width: 8),
              Text(
                'Dikkat Edilmesi Gerekenler',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...cons.map((con) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE74C3C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        con,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppTheme.dimCream.withAlpha(200),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms, delay: 200.ms);
  }
}

// ── Preparation Card ──────────────────────────────────────────────────────
class _PreparationCard extends StatelessWidget {
  const _PreparationCard({required this.preparation});
  final String preparation;

  @override
  Widget build(BuildContext context) {
    final lines = preparation.split('\n');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkMocha.withAlpha(200),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.gold.withAlpha(25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.asMap().entries.map((entry) {
          final line = entry.value;
          if (line.isEmpty) return const SizedBox(height: 8);

          final isBold = line.endsWith(':') ||
              line.startsWith('Malzeme') ||
              line.startsWith('Yapılış');
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              line,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: isBold
                    ? AppTheme.caramel
                    : AppTheme.dimCream.withAlpha(200),
                height: 1.6,
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }
}

// ── Tip Card ──────────────────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.gold.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gold.withAlpha(50), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: AppTheme.gold, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.caramel,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 250.ms);
  }
}

// ── Badges ────────────────────────────────────────────────────────────────
class _TemperatureBadge extends StatelessWidget {
  const _TemperatureBadge({required this.temperature});
  final String temperature;

  @override
  Widget build(BuildContext context) {
    final isHot = temperature == 'Sıcak';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isHot ? Colors.orange : Colors.lightBlue).withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isHot ? Colors.orange : Colors.lightBlue).withAlpha(120),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHot ? Icons.local_fire_department_rounded : Icons.ac_unit_rounded,
            color: isHot ? Colors.orange : Colors.lightBlue,
            size: 12,
          ),
          const SizedBox(width: 5),
          Text(
            temperature,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isHot ? Colors.orange : Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.gold.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.gold.withAlpha(80), width: 1),
      ),
      child: Text(
        category,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.gold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Back Button ───────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.gold.withAlpha(60), width: 1),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

// ── AI Button ─────────────────────────────────────────────────────────────
class _AiButton extends StatefulWidget {
  const _AiButton({required this.drinkTitle});
  final String drinkTitle;

  @override
  State<_AiButton> createState() => _AiButtonState();
}

class _AiButtonState extends State<_AiButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/assistant'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.ledCyan.withAlpha(30)
                : Colors.black.withAlpha(100),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? AppTheme.ledCyan.withAlpha(180)
                  : AppTheme.ledCyan.withAlpha(80),
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.ledCyan.withAlpha(60),
                      blurRadius: 12,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppTheme.ledCyan,
                size: 14,
              ),
              const SizedBox(width: 7),
              Text(
                'AI ile Sor',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
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
