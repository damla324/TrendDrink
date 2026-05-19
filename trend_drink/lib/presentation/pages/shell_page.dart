import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/models/category_meta.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
import 'package:trenddrink/presentation/widgets/left_sidebar.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return isMobile ? _MobileShell(child: child) : _DesktopShell(child: child);
  }
}

// ── Desktop Shell (sidebar) ────────────────────────────────────────────────
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('Assets/photos/background.png', fit: BoxFit.cover),
          Container(color: const Color(0xFF0D0905).withAlpha(210)),
          Row(
            children: [
              const LeftSidebar(),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Mobile Shell (bottom nav) ──────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.child});
  final Widget child;

  String _currentLocation(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.path;
    } catch (_) {
      return '/';
    }
  }

  bool _isTopLevel(String location) =>
      location == '/' || location == '/assistant';

  int _selectedIndex(String location) {
    if (location == '/assistant') return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = _currentLocation(context);
    final isTop = _isTopLevel(location);

    return Scaffold(
      backgroundColor: const Color(0xFF120B04),
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('Assets/photos/background.png', fit: BoxFit.cover),
          Container(color: const Color(0xFF0D0905).withAlpha(210)),
          Padding(
            padding: EdgeInsets.only(bottom: isTop ? 74 : 0),
            child: child,
          ),
        ],
      ),
      bottomNavigationBar:
          isTop ? _MobileNavBar(selectedIndex: _selectedIndex(location)) : null,
    );
  }
}

class _MobileNavBar extends StatelessWidget {
  const _MobileNavBar({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E140A).withAlpha(230),
        border: Border(
          top: BorderSide(color: AppTheme.gold.withAlpha(40)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Ana Sayfa',
                isSelected: selectedIndex == 0,
                onTap: () => context.go('/'),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Kategoriler',
                isSelected: false,
                onTap: () => _showCategoriesSheet(context),
              ),
              _NavItem(
                icon: Icons.auto_awesome_rounded,
                label: 'AI',
                isSelected: selectedIndex == 2,
                isLed: true,
                onTap: () => context.go('/assistant'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoriesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CategoriesSheet(),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isLed = false,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isLed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isLed
        ? AppTheme.ledCyan
        : isSelected
            ? AppTheme.gold
            : AppTheme.dimCream.withAlpha(140);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Categories Bottom Sheet ────────────────────────────────────────────────
class _CategoriesSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E140A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppTheme.gold.withAlpha(50)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.gold.withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
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
                  'Kategoriler',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.cream,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: kCategories.length,
              itemBuilder: (context, i) {
                final cat = kCategories[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/category/${cat.name}');
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cat.accentColor.withAlpha(120),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cat.accentColor.withAlpha(40),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: cat.imageUrl.startsWith('Assets/')
                              ? Image.asset(
                                  cat.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppTheme.mocha,
                                    child: Center(
                                      child: Text(cat.emoji,
                                          style:
                                              const TextStyle(fontSize: 22)),
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: cat.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: AppTheme.mocha,
                                    child: Center(
                                      child: Text(cat.emoji,
                                          style:
                                              const TextStyle(fontSize: 22)),
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: AppTheme.mocha,
                                    child: Center(
                                      child: Text(cat.emoji,
                                          style:
                                              const TextStyle(fontSize: 22)),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.dimCream,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
