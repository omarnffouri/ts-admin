import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_hero_primitives.dart';

/// The live work timer — `hh : mm : ss` in every state, seconds ticking in
/// the collapsed bar too. Collapsing only hides the unit captions.
class ShiftTimer extends GetView<ClockInOutController> {
  const ShiftTimer({super.key, required this.unitsOpacity});

  final double unitsOpacity;

  /// Digit font size. The hero's vertical rhythm is measured off it, so this
  /// is the one place it may be changed.
  static const double digitsHeight = 38;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCheckingClockIn) return const _TimerSkeleton();

      final int h = controller.days.value * 24 + controller.hours.value;

      // Baseline alignment keeps the colons sitting on the digits' baseline in
      // every state — bottom-aligning would anchor to the (invisible but still
      // laid-out) unit captions instead.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TimerSegment(value: h, label: "hr", labelOpacity: unitsOpacity),
          const _TimerColon(),
          _TimerSegment(
            value: controller.minutes.value,
            label: "min",
            labelOpacity: unitsOpacity,
          ),
          const _TimerColon(),
          _TimerSegment(
            value: controller.seconds.value,
            label: "sec",
            labelOpacity: unitsOpacity,
          ),
        ],
      );
    });
  }
}

class _TimerSegment extends StatelessWidget {
  const _TimerSegment({
    required this.value,
    required this.label,
    required this.labelOpacity,
  });

  final int value;
  final String label;
  final double labelOpacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: ShiftTimer.digitsHeight,
            fontWeight: FontWeight.w800,
            height: 1.0,
            letterSpacing: -1,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 4),
        Opacity(
          opacity: labelOpacity,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColorsLight.onHeroTextMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimerColon extends StatelessWidget {
  const _TimerColon();

  @override
  Widget build(BuildContext context) {
    // Vertical placement comes from the row's baseline alignment.
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        ":",
        style: TextStyle(
          color: AppColorsLight.onHeroTextMuted,
          fontSize: 30,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      ),
    );
  }
}

class _TimerSkeleton extends StatelessWidget {
  const _TimerSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonBones(
      baseColor: heroBoneBase,
      highlightColor: heroBoneHighlight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i == 2 ? 0 : 14),
            child: const SkeletonBone(
              width: 46,
              height: ShiftTimer.digitsHeight,
              radius: 8,
            ),
          );
        }),
      ),
    );
  }
}
