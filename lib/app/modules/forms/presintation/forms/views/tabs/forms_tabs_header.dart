import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/controllers/forms_controller.dart';

class FormsTabsHeader extends GetView<FormsController> {
  const FormsTabsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              //
              // back button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: Colors.white.applyOpacity(0.16),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.applyOpacity(0.22),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              //
              // heading
              Expanded(
                child: Text(
                  "Driver Violation Forms",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          //
          // segmented tabs
          const _FormsSegmentedTabs(),
        ],
      ),
    );
  }
}

/// Segmented control matching the Messages / Task Management headers: a
/// frosted track with a sliding pill indicator (solid white in light mode,
/// shadow-only in dark mode).
class _FormsSegmentedTabs extends GetView<FormsController> {
  const _FormsSegmentedTabs();

  @override
  Widget build(BuildContext context) {
    final bool isLight = !Get.isDarkMode;

    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white.applyOpacity(0.15),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.applyOpacity(0.20),
        ),
      ),
      child: Obx(
        () {
          final bool pendingSelected =
              controller.currentTab == FormsTabs.pending;

          return Stack(
            children: [
              //
              // sliding pill indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: pendingSelected
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isLight ? Colors.white : null,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.applyOpacity(isLight ? 0.12 : 0.14),
                          blurRadius: isLight ? 8 : 18,
                          offset: Offset(0, isLight ? 3 : 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //
              // labels
              Row(
                children: [
                  _FormsTabItem(
                    label: "Pending",
                    selected: pendingSelected,
                    badgeCount: controller.pendingForms.length,
                    onTap: () => controller.switchTab(FormsTabs.pending),
                  ),
                  _FormsTabItem(
                    label: "Signed",
                    selected: !pendingSelected,
                    onTap: () => controller.switchTab(FormsTabs.signed),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FormsTabItem extends StatelessWidget {
  const _FormsTabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String label;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isLight = !Get.isDarkMode;
    final Color labelColor = selected
        ? (isLight ? AppColorsLight.mainColor : AppColorsLight.white)
        : (isLight
            ? Colors.white.applyOpacity(0.9)
            : Colors.grey.applyOpacity(0.9));

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13.sp,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColorsLight.mainColor
                        : Colors.white.applyOpacity(0.28),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount > 99 ? "99+" : "$badgeCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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
