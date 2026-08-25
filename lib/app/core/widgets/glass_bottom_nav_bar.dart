import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Lightweight data holder describing a single tab in [GlassBottomNavBar].
class GlassNavItem {
  const GlassNavItem({required this.title, required this.icon});

  final String title;

  /// SVG asset path for the tab icon.
  final String icon;
}

/// A modern, iOS-inspired floating navigation bar with a glassmorphism look:
/// blurred translucent surface, rounded pill shape, subtle border and soft
/// shadow.
///
/// Inactive tabs are icon-only; the active tab smoothly expands into a solid
/// brand-coloured pill that reveals its label — keeping things uncluttered even
/// with many tabs.
///
/// Driven by a [PersistentTabController] so it stays in sync with
/// `PersistentTabView.custom` (including programmatic / Android-back changes).
class GlassBottomNavBar extends StatelessWidget {
  const GlassBottomNavBar({
    super.key,
    required this.controller,
    required this.items,
    this.onItemSelected,
  });

  final PersistentTabController controller;
  final List<GlassNavItem> items;
  final ValueChanged<int>? onItemSelected;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;

    final Color barColor = isDark
        ? const Color(0xFF1C1C1E).applyOpacity(0.2)
        : Colors.white54.applyOpacity(0.25);
    final Color borderColor = isDark
        ? Colors.white.applyOpacity(0.14)
        : Colors.white.applyOpacity(0.80);
    final Color inactiveColor = isDark
        ? Colors.white.applyOpacity(0.60)
        : AppColorsLight.textColor.applyOpacity(0.55);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final int count = items.length;
        if (count == 0) return const SizedBox.shrink();

        final int current = controller.index.clamp(0, count - 1);

        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  height: 66,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorsLight.calanderBoxColor.applyOpacity(
                          isDark ? 0.0 : 0.10,
                        ),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.black.applyOpacity(isDark ? 0.45 : 0.10),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 0; i < count; i++)
                        _GlassNavTab(
                          item: items[i],
                          selected: i == current,
                          inactiveColor: inactiveColor,
                          onTap: () {
                            if (i != controller.index) {
                              controller.index = i;
                            }
                            onItemSelected?.call(i);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A single tab. Inactive: just the icon. Active: a brand-coloured pill that
/// expands to reveal the label, with a smooth size + colour transition.
class _GlassNavTab extends StatelessWidget {
  const _GlassNavTab({
    required this.item,
    required this.selected,
    required this.inactiveColor,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 300);
    const Curve curve = Curves.easeOutCubic;

    final Color iconColor = selected ? Colors.white : inactiveColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 12 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [
                    AppColorsLight.mainColorDark,
                    AppColorsLight.mainColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(30),
        ),
        child: AnimatedSize(
          duration: duration,
          curve: curve,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                item.icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              if (selected) ...[
                const SizedBox(width: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 96),
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
