import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';

class HomeTabHeader extends GetView<ClockInOutController> {
  const HomeTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isAnnouncements =
          controller.currentTab.value == HomeTabs.annoucments;

      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.hairlineBorderColor),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _TabLabel(
                    label: 'Announcement',
                    active: isAnnouncements,
                    onTap: () =>
                        controller.currentTab.value = HomeTabs.annoucments,
                  ),
                ),
                Expanded(
                  child: _TabLabel(
                    label: 'Forms',
                    active: !isAnnouncements,
                    badge: isAnnouncements ? controller.forms.length : 0,
                    onTap: () => controller.currentTab.value = HomeTabs.forms,
                  ),
                ),
              ],
            ),
            // Single sliding accent indicator.
            SizedBox(
              height: 3,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                alignment: isAnnouncements
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Center(
                    child: Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColorsLight.mainColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.active,
    required this.onTap,
    this.badge = 0,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: active
                    ? AppColorsLight.mainColorLight
                    : context.secondaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              child: Text(label),
            ),
            if (badge > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.brandColor.applyOpacity(0.22),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  badge > 99 ? "99+" : "$badge",
                  style: const TextStyle(
                    color: AppColorsLight.mainColorLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
