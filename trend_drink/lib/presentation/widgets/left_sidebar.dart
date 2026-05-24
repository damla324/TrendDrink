import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/category_meta.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/about_dialog.dart';
import 'package:trenddrink/features/paywall/paywall_sheet.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

class _NavEntry {
  const _NavEntry({
    required this.icon,
    required this.label,
    required this.route,
    this.isAi = false,
    this.children = const [],
  });
  final IconData icon;
  final String label;
  final String route;
  final bool isAi;
  final List<_NavChild> children;
}

class _NavChild {
  const _NavChild({required this.label, required this.route});
  final String label;
  final String route;
}

class LeftSidebar extends ConsumerStatefulWidget {
  const LeftSidebar({super.key});

  @override
  ConsumerState<LeftSidebar> createState() => _LeftSidebarState();
}

class _LeftSidebarState extends ConsumerState<LeftSidebar>
    with SingleTickerProviderStateMixin {
  bool _railExpanded = false;
  int? _expandedItem; // hangi grup açık
  late final AnimationController _ledCtrl;

  // Tüm içecek kategorileri "İçecekler" başlığı altında tek hub.
  static final List<_NavEntry> _entries = [
    const _NavEntry(
      icon: Icons.home_rounded,
      label: 'Ana Sayfa',
      route: '/',
    ),
    _NavEntry(
      icon: Icons.local_bar_rounded,
      label: 'İçecekler',
      route: '/category/${kCategories.first.name}',
      children: kCategories
          .map((c) => _NavChild(label: c.name, route: '/category/${c.name}'))
          .toList(),
    ),
    const _NavEntry(
      icon: Icons.auto_awesome_rounded,
      label: 'İçecek AI',
      route: '/assistant',
      isAi: true,
    ),
    const _NavEntry(
      icon: Icons.settings_rounded,
      label: 'Ayarlar',
      route: '/settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ledCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ledCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final width = _railExpanded
        ? AppPalette.sidebarExpandedWidth
        : AppPalette.sidebarCollapsedWidth;

    return MouseRegion(
      onEnter: (_) => setState(() => _railExpanded = true),
      onExit: (_) => setState(() {
        _railExpanded = false;
        _expandedItem = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: width,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppPalette.sidebarGradient,
                border: Border(
                  right: BorderSide(color: AppPalette.gold.withAlpha(34)),
                ),
              ),
              child: Column(
                children: [
                  _buildLogo(),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: AppPalette.gold.withAlpha(28),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      itemCount: _entries.length,
                      itemBuilder: (context, i) {
                        final e = _entries[i];
                        final active = _isActive(e, location);
                        return _SidebarItem(
                          entry: e,
                          isActive: active,
                          isExpanded: _expandedItem == i,
                          railExpanded: _railExpanded,
                          ledCtrl: _ledCtrl,
                          currentLocation: location,
                          onTap: () {
                            if (e.children.isNotEmpty && _railExpanded) {
                              setState(() => _expandedItem =
                                  _expandedItem == i ? null : i);
                            }
                            context.go(e.route);
                          },
                          onChildTap: (child) => context.go(child.route),
                        );
                      },
                    ),
                  ),
                  _MembershipCard(railExpanded: _railExpanded),
                  const SizedBox(height: 10),
                  _AboutButton(railExpanded: _railExpanded),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isActive(_NavEntry e, String location) {
    if (e.route == '/' && location == '/') return true;
    if (e.route != '/' && location.startsWith(e.route.split('?').first)) {
      return true;
    }
    for (final c in e.children) {
      if (location.startsWith(c.route)) return true;
    }
    return false;
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 78,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 6),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppPalette.goldAccent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.gold.withAlpha(120),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_cafe_rounded,
                color: AppPalette.espresso,
                size: 20,
              ),
            ),
            if (_railExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'TrendDrink',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.display(
                      size: 18,
                      color: AppPalette.cream,
                      letterSpacing: 1.2,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Sidebar item ───────────────────────────────────────────────────────────
class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.entry,
    required this.isActive,
    required this.isExpanded,
    required this.railExpanded,
    required this.ledCtrl,
    required this.currentLocation,
    required this.onTap,
    required this.onChildTap,
  });
  final _NavEntry entry;
  final bool isActive;
  final bool isExpanded;
  final bool railExpanded;
  final AnimationController ledCtrl;
  final String currentLocation;
  final VoidCallback onTap;
  final ValueChanged<_NavChild> onChildTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    // Sidebar genişlediği anda tüm etiketler doğrudan görünür.
    final showLabel = widget.railExpanded;
    final Color iconColor = widget.entry.isAi
        ? AppPalette.ledCyan
        : widget.isActive
            ? AppPalette.gold
            : _hover
                ? AppPalette.cream
                : AppPalette.dimCream.withAlpha(190);

    final bgColor = widget.isActive
        ? AppPalette.gold.withAlpha(28)
        : _hover
            ? AppPalette.gold.withAlpha(16)
            : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: widget.entry.isAi
                  ? _buildAiTile(iconColor)
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 52,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: widget.isActive
                            ? Border.all(color: AppPalette.gold.withAlpha(70))
                            : null,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: AppPalette.sidebarCollapsedWidth - 24,
                            child: Icon(widget.entry.icon,
                                size: 26, color: iconColor),
                          ),
                          if (showLabel)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  widget.entry.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.label(
                                    size: 12.5,
                                    color: iconColor,
                                    letterSpacing: 0.8,
                                    weight: widget.isActive
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.railExpanded &&
                              widget.entry.children.isNotEmpty &&
                              showLabel)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 200),
                                turns: widget.isExpanded ? 0.5 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 16,
                                  color: AppPalette.dimCream.withAlpha(160),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
          if (widget.entry.children.isNotEmpty)
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: (widget.isExpanded && widget.railExpanded)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 22, top: 4),
                      child: Column(
                        children: widget.entry.children.map((c) {
                          final active =
                              widget.currentLocation.startsWith(c.route);
                          return _ChildTile(
                            label: c.label,
                            isActive: active,
                            onTap: () => widget.onChildTap(c),
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  Widget _buildAiTile(Color iconColor) {
    return AnimatedBuilder(
      animation: widget.ledCtrl,
      builder: (ctx, _) {
        final glow = widget.ledCtrl.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppPalette.ledCyan.withAlpha((60 + (glow * 110)).round()),
              width: 1.2,
            ),
            gradient: LinearGradient(
              colors: [
                AppPalette.ledCyan.withAlpha((20 + (glow * 28)).round()),
                AppPalette.ledViolet.withAlpha(12),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ledCyan.withAlpha((50 + (glow * 70)).round()),
                blurRadius: 14 + glow * 10,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: AppPalette.sidebarCollapsedWidth - 24,
                child: Icon(widget.entry.icon, size: 26, color: iconColor),
              ),
              if (widget.railExpanded)
                Expanded(
                  child: Text(
                    widget.entry.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label(
                      size: 12.5,
                      color: AppPalette.ledCyan,
                      letterSpacing: 0.8,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              if (widget.railExpanded)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPalette.ledCyan,
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.ledCyan
                              .withAlpha((110 + (glow * 140)).round()),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ChildTile extends StatefulWidget {
  const _ChildTile(
      {required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_ChildTile> createState() => _ChildTileState();
}

class _ChildTileState extends State<_ChildTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? AppPalette.gold
        : _hover
            ? AppPalette.cream
            : AppPalette.dimCream.withAlpha(160);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isActive
                ? AppPalette.gold.withAlpha(18)
                : _hover
                    ? AppPalette.gold.withAlpha(10)
                    : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(
                    size: 12,
                    color: color,
                    letterSpacing: 0.4,
                    weight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Membership / About at the bottom ───────────────────────────────────────
class _MembershipCard extends ConsumerWidget {
  const _MembershipCard({required this.railExpanded});
  final bool railExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipProvider);
    final isPro = membership.isPro;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: isPro ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (!isPro) {
              PaywallSheet.show(context);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: isPro
                  ? AppPalette.goldAccent
                  : LinearGradient(
                      colors: [
                        AppPalette.gold.withAlpha(40),
                        AppPalette.gold.withAlpha(15),
                      ],
                    ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppPalette.gold.withAlpha(isPro ? 0 : 90),
              ),
              boxShadow: isPro
                  ? [
                      BoxShadow(
                          color: AppPalette.gold.withAlpha(80), blurRadius: 14)
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isPro ? Icons.workspace_premium_rounded : Icons.bolt_rounded,
                  size: 22,
                  color: isPro ? AppPalette.espresso : AppPalette.gold,
                ),
                if (railExpanded) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isPro ? 'PRO ÜYE' : 'FREE',
                          style: AppTypography.label(
                            size: 11,
                            color:
                                isPro ? AppPalette.espresso : AppPalette.gold,
                            letterSpacing: 2,
                            weight: FontWeight.w900,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          isPro ? 'Sınırsız erişim' : 'Premium\'a yükselt',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body(
                            size: 10.5,
                            color: isPro
                                ? AppPalette.espresso.withAlpha(190)
                                : AppPalette.dimCream.withAlpha(190),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutButton extends StatefulWidget {
  const _AboutButton({required this.railExpanded});
  final bool railExpanded;

  @override
  State<_AboutButton> createState() => _AboutButtonState();
}

class _AboutButtonState extends State<_AboutButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color =
        _hover ? AppPalette.cream : AppPalette.dimCream.withAlpha(170);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => showTrendDrinkAbout(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  _hover ? AppPalette.gold.withAlpha(14) : Colors.transparent,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: AppPalette.sidebarCollapsedWidth - 24,
                  child:
                      Icon(Icons.info_outline_rounded, size: 22, color: color),
                ),
                if (widget.railExpanded)
                  Expanded(
                    child: Text(
                      'Hakkında',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label(
                        size: 12,
                        color: color,
                        letterSpacing: 0.8,
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
