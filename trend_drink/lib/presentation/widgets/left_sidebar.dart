import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

// ── Sidebar Category Model ─────────────────────────────────────────────────
class _SidebarSection {
  const _SidebarSection({
    required this.label,
    required this.icon,
    required this.route,
    this.children = const [],
    this.isAi = false,
  });
  final String label;
  final IconData icon;
  final String route;
  final List<_SidebarChild> children;
  final bool isAi;
}

class _SidebarChild {
  const _SidebarChild({required this.label, required this.route});
  final String label;
  final String route;
}

// ── Sidebar Widget ─────────────────────────────────────────────────────────
class LeftSidebar extends ConsumerStatefulWidget {
  const LeftSidebar({super.key});

  @override
  ConsumerState<LeftSidebar> createState() => _LeftSidebarState();
}

class _LeftSidebarState extends ConsumerState<LeftSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ledController;
  int? _expandedIndex;

  static const List<_SidebarSection> _sections = [
    _SidebarSection(
      label: 'Ana Sayfa',
      icon: Icons.home_rounded,
      route: '/',
    ),
    _SidebarSection(
      label: 'Kahve Türleri',
      icon: Icons.coffee_rounded,
      route: '/category/Kahve',
      children: [
        _SidebarChild(label: 'Kahve', route: '/category/Kahve'),
        _SidebarChild(label: 'Matcha', route: '/category/Matcha'),
      ],
    ),
    _SidebarSection(
      label: 'Kokteyl & Frozen',
      icon: Icons.local_bar_rounded,
      route: '/category/Kokteyl',
      children: [
        _SidebarChild(label: 'Kokteyl', route: '/category/Kokteyl'),
        _SidebarChild(label: 'Frozen', route: '/category/Frozen'),
      ],
    ),
    _SidebarSection(
      label: 'Sağlıklı Seçenekler',
      icon: Icons.favorite_rounded,
      route: '/category/Smoothie',
      children: [
        _SidebarChild(label: 'Smoothie', route: '/category/Smoothie'),
        _SidebarChild(label: 'Fit', route: '/category/Fit'),
      ],
    ),
    _SidebarSection(
      label: 'Çay & Soda',
      icon: Icons.local_cafe_rounded,
      route: '/category/Çay',
      children: [
        _SidebarChild(label: 'Çay', route: '/category/Çay'),
        _SidebarChild(label: 'Soda', route: '/category/Soda'),
      ],
    ),
    _SidebarSection(
      label: 'İçecek AI',
      icon: Icons.auto_awesome_rounded,
      route: '/assistant',
      isAi: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ledController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return SizedBox(
      width: AppTheme.sidebarWidth,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.espresso.withAlpha(200),
              border: Border(
                right: BorderSide(
                  color: AppTheme.gold.withAlpha(30),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                const SizedBox(height: 8),
                Divider(color: AppTheme.gold.withAlpha(25), height: 1),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final section = _sections[index];
                      return _buildSectionItem(
                        context: context,
                        section: section,
                        index: index,
                        currentLocation: location,
                      );
                    },
                  ),
                ),
                _buildBottomInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.gold.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.gold.withAlpha(60)),
            ),
            child: const Center(
              child: Text('☕', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'TrendDrink',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.cream,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
    );
  }

  Widget _buildSectionItem({
    required BuildContext context,
    required _SidebarSection section,
    required int index,
    required String currentLocation,
  }) {
    final isExpanded = _expandedIndex == index;
    final isActive = _isActive(section, currentLocation);

    if (section.isAi) {
      return _buildAiItem(context, section, isActive);
    }

    if (section.children.isEmpty) {
      return _buildSimpleItem(context, section, isActive);
    }

    return _buildExpandableItem(
      context: context,
      section: section,
      index: index,
      isExpanded: isExpanded,
      isActive: isActive,
      currentLocation: currentLocation,
    );
  }

  bool _isActive(_SidebarSection section, String location) {
    if (section.route == '/' && location == '/') return true;
    if (section.route != '/' && location.startsWith(section.route)) return true;
    for (final child in section.children) {
      if (location.startsWith(child.route)) return true;
    }
    return false;
  }

  Widget _buildSimpleItem(
    BuildContext context,
    _SidebarSection section,
    bool isActive,
  ) {
    return _SidebarTile(
      icon: section.icon,
      label: section.label,
      isActive: isActive,
      onTap: () => context.go(section.route),
    ).animate().fadeIn(duration: 400.ms, delay: 50.ms);
  }

  Widget _buildExpandableItem({
    required BuildContext context,
    required _SidebarSection section,
    required int index,
    required bool isExpanded,
    required bool isActive,
    required String currentLocation,
  }) {
    return Column(
      children: [
        _SidebarTile(
          icon: section.icon,
          label: section.label,
          isActive: isActive,
          trailing: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 220),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.dimCream.withAlpha(160),
              size: 16,
            ),
          ),
          onTap: () {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
            context.go(section.route);
          },
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Column(
              children: section.children.map((child) {
                final childActive = currentLocation.startsWith(child.route);
                return _SidebarChildTile(
                  label: child.label,
                  isActive: childActive,
                  onTap: () => context.go(child.route),
                );
              }).toList(),
            ),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 50.ms);
  }

  Widget _buildAiItem(
    BuildContext context,
    _SidebarSection section,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedBuilder(
        animation: _ledController,
        builder: (context, child) {
          final glow = _ledController.value;
          return GestureDetector(
            onTap: () => context.go(section.route),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: isActive
                        ? [
                            AppTheme.ledCyan.withAlpha(50),
                            AppTheme.ledCyan.withAlpha(20),
                          ]
                        : [
                            AppTheme.ledCyan
                                .withAlpha((15 + (glow * 25)).round()),
                            Colors.transparent,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.ledCyan
                          .withAlpha((40 + (glow * 60)).round()),
                      blurRadius: 12 + glow * 8,
                    ),
                  ],
                  border: Border.all(
                    color:
                        AppTheme.ledCyan.withAlpha((60 + (glow * 80)).round()),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(
                      section.icon,
                      size: 18,
                      color: AppTheme.ledCyan,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      section.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ledCyan,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.ledCyan,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.ledCyan
                                .withAlpha((120 + (glow * 135)).round()),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildBottomInfo() {
    final membership = ref.watch(membershipProvider);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      child: Column(
        children: [
          // Pro Status Card
          Container(
            decoration: BoxDecoration(
              gradient: membership.isPro
                  ? LinearGradient(
                      colors: [
                        AppTheme.gold.withAlpha(180),
                        AppTheme.gold.withAlpha(120),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        AppTheme.mutedBrown.withAlpha(120),
                        AppTheme.mutedBrown.withAlpha(80),
                      ],
                    ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: membership.isPro
                    ? AppTheme.gold.withAlpha(100)
                    : AppTheme.gold.withAlpha(40),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            membership.isPro ? Icons.star_rounded : Icons.star_outline,
                            size: 14,
                            color: membership.isPro ? Colors.white : AppTheme.caramel,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            membership.isPro ? 'PRO' : 'FREE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: membership.isPro ? Colors.white : AppTheme.caramel,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        membership.isPro ? 'Unlimited AI' : 'Limited AI',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8,
                          color: membership.isPro
                              ? Colors.white70
                              : AppTheme.caramel.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!membership.isPro)
                  GestureDetector(
                    onTap: () => context.go('/pro'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withAlpha(200),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Upgrade',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.espresso,
                        ),
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.verified_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Settings & Help
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.go('/settings'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.mutedBrown.withAlpha(80),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.settings_rounded,
                          size: 12,
                          color: AppTheme.caramel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Settings',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.caramel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          Text(
            'v1.0 · Premium Edition',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: AppTheme.dimCream.withAlpha(80),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Tile Components ──────────────────────────────────────────────
class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.isActive
                  ? AppTheme.gold.withAlpha(25)
                  : _hovered
                      ? AppTheme.gold.withAlpha(12)
                      : Colors.transparent,
              border: widget.isActive
                  ? Border.all(
                      color: AppTheme.gold.withAlpha(50),
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 17,
                  color: widget.isActive
                      ? AppTheme.gold
                      : _hovered
                          ? AppTheme.dimCream
                          : AppTheme.dimCream.withAlpha(160),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight:
                          widget.isActive ? FontWeight.w600 : FontWeight.w400,
                      color: widget.isActive
                          ? AppTheme.cream
                          : _hovered
                              ? AppTheme.cream
                              : AppTheme.dimCream.withAlpha(200),
                    ),
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarChildTile extends StatefulWidget {
  const _SidebarChildTile({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_SidebarChildTile> createState() => _SidebarChildTileState();
}

class _SidebarChildTileState extends State<_SidebarChildTile> {
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
          duration: const Duration(milliseconds: 160),
          height: 34,
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isActive
                ? AppTheme.gold.withAlpha(20)
                : _hovered
                    ? AppTheme.gold.withAlpha(10)
                    : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isActive
                      ? AppTheme.gold
                      : AppTheme.dimCream.withAlpha(100),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight:
                      widget.isActive ? FontWeight.w500 : FontWeight.w400,
                  color: widget.isActive
                      ? AppTheme.gold
                      : _hovered
                          ? AppTheme.dimCream
                          : AppTheme.dimCream.withAlpha(160),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
