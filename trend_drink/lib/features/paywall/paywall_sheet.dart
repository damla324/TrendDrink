import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/frosted_panel.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

/// Premium paywall – aşağıdan gelir, özellikleri listeler, Pro'ya geçiş yapar.
class PaywallSheet {
  PaywallSheet._();

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'paywall',
      barrierColor: Colors.black.withAlpha(170),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, __, ___) {
        final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curve),
          child: FadeTransition(
            opacity: curve,
            child: const Center(child: _PaywallContent()),
          ),
        );
      },
    );
  }
}

class _PaywallContent extends ConsumerStatefulWidget {
  const _PaywallContent();

  @override
  ConsumerState<_PaywallContent> createState() => _PaywallContentState();
}

class _PaywallContentState extends ConsumerState<_PaywallContent>
    with TickerProviderStateMixin {
  late final AnimationController _led;
  bool _upgrading = false;

  @override
  void initState() {
    super.initState();
    _led = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _led.dispose();
    super.dispose();
  }

  Future<void> _upgrade() async {
    if (_upgrading) return;
    setState(() => _upgrading = true);

    // Pop ÖNCE: modal kapan\u0131p mouse-tracker'\u0131n yeni a\u011fac\u0131 stabil olduktan
    // sonra membership state\u2019i de\u011fi\u015ftirelim ki rebuild s\u0131ras\u0131nda
    // hover olay\u0131yla \u00e7ak\u0131\u015fmas\u0131n.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(membershipProvider.notifier);

    navigator.pop();

    // Bir sonraki frame'de upgrade et + snackbar.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notifier.upgradeToPro();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppPalette.espresso,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: const [
              Icon(Icons.workspace_premium_rounded,
                  color: AppPalette.gold, size: 20),
              SizedBox(width: 10),
              Text(
                  'Pro \u00fcyeli\u011fin etkin! T\u00fcm \u00f6zellikler a\u00e7\u0131k. \ud83c\udf89',
                  style: TextStyle(color: AppPalette.cream)),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FrostedPanel(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
          alpha: 230,
          blur: 30,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 22),
                _LedFeatureTile(
                  led: _led,
                  icon: Icons.auto_awesome_rounded,
                  title: 'AI ile Sıradışı İçeceğin Gücü',
                  description:
                      'Görsel + metin destekli AI: malzemenden veya fotoğrafından tarif üretir, ruh haline göre öneri sunar.',
                ),
                const SizedBox(height: 12),
                _FeatureTile(
                  icon: Icons.image_rounded,
                  title: 'Görsel Tabanlı Malzeme Tanıma',
                  description:
                      'Buzdolabının fotoğrafını çek, AI sana özel içecek önersin.',
                ),
                _FeatureTile(
                  icon: Icons.palette_rounded,
                  title: '5 Premium Tema',
                  description:
                      'Ocean Wave, Purple Gradient, Gold Lux, Dark Crimson, Matrix Green.',
                ),
                _FeatureTile(
                  icon: Icons.all_inclusive_rounded,
                  title: 'Sınırsız AI Sorgu',
                  description: 'Günlük kota yok – istediğin kadar sohbet et.',
                ),
                _FeatureTile(
                  icon: Icons.bookmark_rounded,
                  title: 'Sınırsız Koleksiyon',
                  description:
                      'Favori tarifleri kendi listelerinde topla, dilediğin kadar.',
                ),
                _FeatureTile(
                  icon: Icons.support_agent_rounded,
                  title: 'Öncelikli Destek',
                  description:
                      'Premium destek hattı – sorularına 24 saat içinde yanıt.',
                ),
                const SizedBox(height: 20),
                _buildPriceCta(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppPalette.goldAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppPalette.gold.withAlpha(150),
                blurRadius: 22,
              ),
            ],
          ),
          child: const Icon(Icons.workspace_premium_rounded,
              color: AppPalette.espresso, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TrendDrink Pro',
                  style: AppTypography.display(
                      size: 24, color: AppPalette.cream, letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text(
                'Premium içecek deneyiminin kilidini aç',
                style: AppTypography.body(
                  size: 12,
                  color: AppPalette.dimCream.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: AppPalette.cream),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildPriceCta() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppPalette.gold.withAlpha(40),
            AppPalette.gold.withAlpha(12),
          ],
        ),
        border: Border.all(color: AppPalette.gold.withAlpha(120)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '100',
                      style: GoogleFonts.questrial(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.gold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '₺',
                        style: AppTypography.display(
                          size: 22,
                          color: AppPalette.gold,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '/ay',
                        style: AppTypography.body(
                          size: 13,
                          color: AppPalette.dimCream,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'İstediğin zaman iptal edebilirsin.',
                  style: AppTypography.body(
                    size: 10.5,
                    color: AppPalette.dimCream.withAlpha(170),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _upgrading ? null : _upgrade,
              icon: _upgrading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppPalette.espresso),
                    )
                  : const Icon(Icons.bolt_rounded, size: 18),
              label: Text(
                _upgrading ? 'İşleniyor...' : 'Pro\'ya Geç',
                style: AppTypography.label(
                  size: 12.5,
                  color: AppPalette.espresso,
                  letterSpacing: 1.4,
                  weight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppPalette.gold.withAlpha(24),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppPalette.gold.withAlpha(60)),
            ),
            child: Icon(icon, size: 18, color: AppPalette.gold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.label(
                      size: 12.5,
                      color: AppPalette.cream,
                      letterSpacing: 0.4,
                      weight: FontWeight.w700,
                    )),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.body(
                    size: 11.5,
                    color: AppPalette.dimCream.withAlpha(180),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LedFeatureTile extends StatelessWidget {
  const _LedFeatureTile({
    required this.led,
    required this.icon,
    required this.title,
    required this.description,
  });
  final AnimationController led;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: led,
      builder: (ctx, _) {
        final g = led.value;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppPalette.ledCyan.withAlpha((26 + (g * 35)).round()),
                AppPalette.ledViolet.withAlpha(16),
              ],
            ),
            border: Border.all(
              color: AppPalette.ledCyan.withAlpha((90 + (g * 110)).round()),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ledCyan.withAlpha((60 + (g * 90)).round()),
                blurRadius: 18 + g * 12,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppPalette.aiAccent,
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.ledCyan
                          .withAlpha((140 + (g * 100)).round()),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: AppPalette.espresso, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label(
                              size: 12.5,
                              color: AppPalette.ledCyan,
                              letterSpacing: 1.0,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppPalette.ledCyan.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppPalette.ledCyan.withAlpha(120)),
                          ),
                          child: Text('FLAGSHIP',
                              style: AppTypography.label(
                                size: 8.5,
                                color: AppPalette.ledCyan,
                                letterSpacing: 1.6,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.body(
                        size: 11.5,
                        color: AppPalette.dimCream.withAlpha(210),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
