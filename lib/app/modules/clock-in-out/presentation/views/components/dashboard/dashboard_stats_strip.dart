import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';
import 'package:ts_admin/app/core/widgets/glass_panel.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_hero_primitives.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_timesheet_dialog.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

/// Four glanceable stats, each a shortcut. Labels are kept to ≤7 characters so
/// they survive the hero's 1.3× text-scale clamp inside a 52pt content box.
class DashboardStatsStrip extends GetView<ClockInOutController> {
  const DashboardStatsStrip({super.key});

  static const double _gap = 10;

  /// Tile padding 24 + icon 18 + gap 10 + value 18 + gap 3 + label ~15, plus
  /// headroom so the label's line height never overflows. The hero measures
  /// its collapse travel off this — keep it in step with [_StatTile].
  static const double height = 92;

  @override
  Widget build(BuildContext context) {
    // Outer Obx subscribes to the permission list only, so the pays tile
    // appears if permissions land after the first paint. Per-value rebuilds
    // stay in each tile's own Obx.
    return Obx(() {
      final List<Widget> tiles = [
        _weekTile(),
        _tasksTile(),
        _unreadTile(),
        // Hidden outright without the resolve permission — a permanently
        // meaningless tile is worse than three wider ones.
        if (controller.canSeePendingPays) _pendingTile(),
      ];

      return Row(
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            Expanded(child: tiles[i]),
          ],
        ],
      );
    });
  }

  Widget _weekTile() => Obx(
        () => _StatTile(
          icon: Icons.timelapse_rounded,
          value: _formatHours(controller.totalHours.value),
          label: "Week",
          isLoading: controller.isLoadingTimeSheetHours,
          onTap: () => showTimesheetDialog(controller),
        ),
      );

  Widget _tasksTile() => Obx(
        () => _StatTile(
          icon: Icons.fact_check_rounded,
          value: "${controller.forms.length}",
          label: "Tasks",
          isLoading: controller.isLoadingForms,
          onTap: () => controller.currentTab.value = HomeTabs.forms,
        ),
      );

  Widget _unreadTile() => Obx(
        () => _StatTile(
          icon: Icons.campaign_rounded,
          value: "${_unread()}",
          label: "Unread",
          isLoading: controller.annoucementController.isLoadingAnnoucements,
          onTap: () => controller.currentTab.value = HomeTabs.annoucments,
        ),
      );

  Widget _pendingTile() => Obx(() {
        final int? pending = controller.pendingAdditionalPays.value;
        return _StatTile(
          icon: Icons.monetization_on,
          value: "${pending ?? 0}",
          label: "Pending",
          isLoading: controller.isLoadingPendingPays,
          // The dot is the ONLY state channel — the value stays white so
          // colour never doubles as meaning.
          showAttention: (pending ?? 0) > 0,
          onTap: () async {
            await Get.toNamed(Routes.ADDITIONAL_PAY);
            controller.fetchPendingAdditionalPays();
          },
        );
      });

  int _unread() => controller.annoucementController.annoucements
      .where((a) => a.read != 1)
      .length;

  String _formatHours(double hours) {
    if (hours <= 0) return "0h";
    if (hours == hours.roundToDouble()) return "${hours.toInt()}h";
    return "${hours.toStringAsFixed(1)}h";
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
    this.showAttention = false,
    this.isLoading = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  /// Pulsing amber dot beside the icon — "this one wants you".
  final bool showAttention;

  /// Swaps the contents for bones. A `0` shown before the fetch lands reads as
  /// real data ("nothing pending"), which is the one thing it must not say.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 16,
      blur: 14,
      onTap: isLoading ? null : onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: isLoading ? const _StatTileBones() : _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color:
                  context.isDark ? AppColorsLight.mainColorLight : Colors.white,
              size: 18,
            ),
            const Spacer(),
            if (showAttention)
              const PulseDot(
                color: AppColorsLight.onHeroAttention,
                active: true,
                size: 6,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1.0,
            // Counts tick live — untabulated digits jiggle.
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColorsLight.onHeroTextSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

/// Bones mirroring [_StatTile]'s anatomy — icon chip, value, label — at the
/// same sizes and offsets, so nothing shifts when the real content arrives.
class _StatTileBones extends StatelessWidget {
  const _StatTileBones();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBones(
      baseColor: heroBoneBase,
      highlightColor: heroBoneHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonBone(width: 18, height: 18), // icon
          SizedBox(height: 10),
          SkeletonBone(width: 34, height: 18, radius: 5), // value
          SizedBox(height: 3),
          SkeletonBone(width: 42, height: 11, radius: 4), // label
        ],
      ),
    );
  }
}
