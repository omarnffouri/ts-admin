import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/enum/assets_management_category.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/inspection_management.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../controllers/safety_controller.dart';

class SafetyView extends GetView<SafetyController> {
  const SafetyView({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Hero(
                topInset: topInset,
                titleAnim: controller.slice(0.00, 0.55),
              ),

              // ── Fleet Assets ──────────────────────────────────────────
              _SectionLabel(
                text: "Fleet Assets",
                animation: controller.slice(0.30, 0.75),
              ),
              if (controller.menu.canViewAssets) ...[
                _Reveal(
                  animation: controller.slice(0.34, 0.74),
                  child: _SpotlightCard(
                    index: 1,
                    label: "Trucks",
                    caption: "Fleet vehicles & maintenance",
                    imagePath: Assets.icons.truckIcon,
                    onTap: () => Get.toNamed(
                      Routes.TRUCKS,
                      arguments: AssetsCategory.trucks,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _Reveal(
                  animation: controller.slice(0.44, 0.84),
                  child: _SpotlightCard(
                    index: 2,
                    label: "Trailers",
                    caption: "Hauling units & cargo specs",
                    imagePath: Assets.icons.trailerIcon,
                    onTap: () => Get.toNamed(
                      Routes.TRAILERS,
                      arguments: AssetsCategory.trailers,
                    ),
                  ),
                ),
              ],

              // ── Compliance ────────────────────────────────────────────
              if (controller.menu.canViewInspections) ...[
                _SectionLabel(
                  text: "Compliance",
                  animation: controller.slice(0.55, 0.90),
                ),
                _Reveal(
                  animation: controller.slice(0.60, 1.0),
                  child: _SpotlightCard(
                    index: 3,
                    label: "Inspections",
                    caption: "Schedule, review & stay compliant",
                    imagePath: Assets.icons.inspectionMenuIcon,
                    onTap: () => Get.to(() => const InspectionManagement()),
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Immersive hero: back control, editorial title, and a glass stat strip.
class _Hero extends StatelessWidget {
  const _Hero({
    required this.topInset,
    required this.titleAnim,
  });

  final double topInset;
  final Animation<double> titleAnim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppRedHeader(
      width: double.infinity,
      radius: 32,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),

          // Title + description
          Text(
            "Safety Management",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Oversee your fleet assets and keep every inspection on track.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.applyOpacity(0.82),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section heading with an accent bar; fades up on load.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.animation});

  final String text;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Reveal(
      animation: animation,
      offsetY: 20,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 20, 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5A5F), Color(0xFFE21F26)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Large white spotlight card for a fleet asset / compliance entry.
class _SpotlightCard extends StatefulWidget {
  const _SpotlightCard({
    required this.index,
    required this.label,
    required this.caption,
    required this.imagePath,
    required this.onTap,
  });

  final int index;
  final String label;
  final String caption;
  final String imagePath;
  final VoidCallback onTap;

  @override
  State<_SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<_SpotlightCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark
                  ? Colors.white.applyOpacity(0.08)
                  : const Color(0xFFEDEDED),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.applyOpacity(0.05),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Oversized watermark icon bleeding off the edge (subtle grey).
              Positioned(
                right: -22,
                bottom: -26,
                child: Opacity(
                  opacity: 0.05,
                  child: SvgPicture.asset(
                    widget.imagePath,
                    width: 168,
                    height: 168,
                    colorFilter: ColorFilter.mode(
                      Get.isDarkMode
                          ? AppColorsLight.senderCallColor
                          : AppColorsLight.secondaryHeaderColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              // Index badge, top-right (light grey chip).
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.applyOpacity(0.08)
                        : const Color(0xFFF2F2F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "0${widget.index}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? Colors.white.applyOpacity(0.7)
                          : AppColorsLight.textColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              // Foreground content.
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColorsLight.mainColor.applyOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        widget.imagePath,
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          AppColorsLight.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.label,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1A1A),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.caption,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? Colors.white.applyOpacity(0.6)
                                      : AppColorsLight.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColorsLight.mainColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic one-shot reveal: fades + slides its child up as [animation] runs.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.child,
    this.offsetY = 30,
  });

  final Animation<double> animation;
  final Widget child;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final v = animation.value;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, offsetY * (1 - v)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
