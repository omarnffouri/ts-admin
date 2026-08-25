import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_management.dart';
import 'package:ts_admin/app/modules/leave_management/presentation/employee_management.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/shop_management.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../controllers/menu_page_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class MenuPageView extends GetView<MenuPageController> {
  const MenuPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Compact premium header ────────────────────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: _MenuHero(topInset: topInset),
          ),

          // ── Grouped list sections + logout ────────────────────────────
          Expanded(
            child: Obx(() {
              final sections = _buildSections();
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          return FadeInUp(
                            // Subtle cascade as the sections scroll into view.
                            delay: Duration(milliseconds: 70 * i),
                            duration: const Duration(milliseconds: 420),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 22),
                              child: _MenuGroupSection(section: sections[i]),
                            ),
                          );
                        },
                        childCount: sections.length,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  List<_MenuSection> _buildSections() {
    final sections = <_MenuSection>[
      _MenuSection(
        title: 'Administration',
        tiles: [
          if (controller.canViewUserManagement)
            _MenuTile(
              title: 'User Management',
              icon: Assets.icons.usersMenuIcon,
              onTap: () => Get.toNamed(Routes.ALL_USER),
            ),
          if (controller.canViewInvoiceManagement)
            _MenuTile(
              title: 'Invoice Management',
              icon: Assets.icons.invoiceMeunIcon,
              onTap: () => Get.to(() => const InvoiceManagement()),
            ),
          _MenuTile(
            title: 'Leave Management',
            icon: Assets.icons.leaveManagement,
            onTap: () => Get.to(() => const EmployeeManagement()),
          ),
          if (controller.canViewShop)
            _MenuTile(
              title: 'Shop Management',
              icon: Assets.icons.shopManagement,
              onTap: () => Get.to(() => const ShopManagement()),
            ),
          if (controller.canViewForms)
            _MenuTile(
              title: 'Forms',
              icon: Assets.icons.formsMenuIcon,
              onTap: () => Get.toNamed(Routes.FORMS),
            ),
        ],
      ),
      _MenuSection(
        title: 'Operations',
        tiles: [
          if (controller.canViewHr)
            _MenuTile(
              title: 'Human Resources',
              icon: Assets.icons.hrIcon,
              onTap: () => Get.toNamed(Routes.APPLICATIONS),
            ),
          _MenuTile(
            title: 'Announcements',
            icon: Assets.icons.sendAnnouncement,
            onTap: () => Get.toNamed(Routes.ANNOUCMENTS),
          ),
          if (controller.canShowStorage)
            _MenuTile(
              title: 'Storage',
              icon: Assets.icons.storageDrive,
              onTap: () {
                if (controller.authController.stoargeOtpVerified.value) {
                  Get.toNamed(Routes.STORAGE_DRIVE);
                } else {
                  Get.toNamed(Routes.VERIFY_DRIVE_OTP);
                }
              },
            ),
        ],
      ),
    ];

    // Drop any section that ended up empty after permission filtering.
    return sections.where((s) => s.tiles.isNotEmpty).toList();
  }
}

/// Lightweight data holder describing a single menu feature.
class _MenuTile {
  const _MenuTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String icon;
  final VoidCallback onTap;
}

/// A logical grouping of related menu tiles rendered inside one container.
class _MenuSection {
  const _MenuSection({required this.title, required this.tiles});

  final String title;
  final List<_MenuTile> tiles;
}

/// Compact, premium [AppRedHeader] carrying the profile summary, role badge
/// and the theme-toggle / settings glass controls.
class _MenuHero extends GetView<MenuPageController> {
  const _MenuHero({required this.topInset});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppRedHeader(
        width: double.infinity,
        radius: 28,
        padding: EdgeInsets.fromLTRB(20, topInset + 14, 20, 22),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.white.applyOpacity(0.16),
              child: Container(
                padding: const EdgeInsets.all(12),
                // width: 40,
                // height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.applyOpacity(0.22)),
                ),
                child: Row(
                  children: [
                    // Avatar with a soft white ring.
                    Obx(
                      () => GestureDetector(
                        onTap: () => showImageDialog(
                          context,
                          controller.authController.user.value?.image ?? "",
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.applyOpacity(0.55),
                              width: 1.5,
                            ),
                          ),
                          child: ProfileImage.network(
                            url: controller.authController.user.value?.image,
                            width: 50,
                            height: 50,
                            showLetterOnError: true,
                            letter: controller
                                .authController.user.value?.firstName?[0]
                                .toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Welcome back",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.applyOpacity(0.70),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller.authController.user.value?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Role badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.applyOpacity(0.16),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Colors.white.applyOpacity(0.18),
                                ),
                              ),
                              child: Text(
                                controller.authController.user.value
                                        ?.designation?.name ??
                                    "Member",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _GlassControl(
                      icon: Get.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      onTap: controller.toggleThemeMode,
                    ),
                    const SizedBox(width: 10),
                    _GlassControl(
                      icon: Icons.settings_rounded,
                      onTap: () => Get.toNamed(Routes.SETTINGS),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

/// Frosted circular control used in the hero (theme toggle / settings).
class _GlassControl extends StatelessWidget {
  const _GlassControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.applyOpacity(0.16),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.white.applyOpacity(0.22)),
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders one [_MenuSection] as a labelled, grouped list container with
/// refined dividers between its items.
class _MenuGroupSection extends StatelessWidget {
  const _MenuGroupSection({required this.section});

  final _MenuSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    final Color surface = isDark ? const Color(0xFF1C1C1C) : Colors.white;
    final Color borderColor =
        isDark ? Colors.white.applyOpacity(0.08) : const Color(0xFFECECEC);
    final Color dividerColor =
        isDark ? Colors.white.applyOpacity(0.06) : const Color(0xFFF0F0F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
          child: Text(
            section.title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark
                  ? Colors.white.applyOpacity(0.55)
                  : AppColorsLight.textColor.applyOpacity(0.75),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontSize: 11.5,
            ),
          ),
        ),
        // Grouped container
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                for (int i = 0; i < section.tiles.length; i++) ...[
                  _MenuListItem(tile: section.tiles[i]),
                  if (i != section.tiles.length - 1)
                    Padding(
                      // Indent the divider to align with the title, past the icon.
                      padding: const EdgeInsets.only(left: 64),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: dividerColor,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A single grouped-list row: icon · title · chevron, with press/selection
/// feedback and a comfortable touch target.
class _MenuListItem extends StatefulWidget {
  const _MenuListItem({required this.tile});

  final _MenuTile tile;

  @override
  State<_MenuListItem> createState() => _MenuListItemState();
}

class _MenuListItemState extends State<_MenuListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    final Color titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color pressedColor = isDark
        ? Colors.white.applyOpacity(0.05)
        : AppColorsLight.mainColor.applyOpacity(0.04);

    return Material(
      color: _pressed ? pressedColor : Colors.transparent,
      child: InkWell(
        onTap: widget.tile.onTap,
        onHighlightChanged: (v) => setState(() => _pressed = v),
        splashColor: AppColorsLight.mainColor.applyOpacity(0.06),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              // Icon tile
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColorsLight.mainColor.applyOpacity(0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: SvgPicture.asset(
                  widget.tile.icon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColorsLight.mainColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Title
              Expanded(
                child: Text(
                  widget.tile.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Navigation indicator
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: isDark
                    ? Colors.white.applyOpacity(0.35)
                    : AppColorsLight.textColor.applyOpacity(0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width red gradient logout CTA with a loading state.
