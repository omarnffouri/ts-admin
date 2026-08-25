import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';

/// The clock-in / clock-out call to action. Fixed width so the label flipping
/// between "Start" and "End" never resizes the button.
class QuickStartButton extends GetView<ClockInOutController> {
  const QuickStartButton({
    super.key,
    required this.height,
    required this.width,
    required this.glow,
  });

  final double height;
  final double width;
  final double glow;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCheckingClockIn || controller.isClockingInOut) {
        return _shell(
          context,
          glowing: false,
          child: const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: AppColorsLight.mainColor,
            ),
          ),
        );
      }

      if (controller.isCheckingClockInFailed) {
        return GestureDetector(
          onTap: controller.refeshClockInState,
          child: _shell(
            context,
            glowing: false,
            child: const _CtaLabel(icon: Icons.refresh_rounded, text: "Retry"),
          ),
        );
      }

      final clockedIn = controller.isClockedIn;
      return GestureDetector(
        onTap: controller.onClockInOutClicked,
        child: _shell(
          context,
          glowing: !clockedIn,
          child: _CtaLabel(
            icon: clockedIn
                ? Icons.stop_circle_outlined
                : Icons.play_arrow_rounded,
            text: clockedIn ? "End" : "Start",
          ),
        ),
      );
    });
  }

  Widget _shell(BuildContext context,
      {required Widget child, required bool glowing}) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.applyOpacity(0.9),
        borderRadius: BorderRadius.circular(lerpDouble(14, 12, 1 - glow)!),
        border:
            glowing ? null : Border.all(color: Colors.white.applyOpacity(0.16)),
        boxShadow: glowing && glow > 0.01 ? context.accentGlow(glow) : null,
      ),
      child: child,
    );
  }
}

class _CtaLabel extends StatelessWidget {
  const _CtaLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColorsLight.mainColor, size: 20),
        const SizedBox(width: 2),
        Text(
          text,
          maxLines: 1,
          style: const TextStyle(
            color: AppColorsLight.mainColor,
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
