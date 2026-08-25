import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/create_announcement_controller.dart';

/// Pill segmented control letting the admin choose how to target drivers:
/// hand-pick individual drivers or broadcast to an application-status topic.
///
/// A single indicator glides between the two segments while the labels lerp
/// their colour/weight, so switching feels smooth rather than snapping.
class AudienceModeToggle extends GetView<CreateAnnouncementController> {
  const AudienceModeToggle({super.key});

  static const Duration _duration = Duration(milliseconds: 260);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool dark = context.isDark;
    return Container(
      height: 52,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: (dark ? Colors.white : Colors.grey)
            .applyOpacity(dark ? 0.08 : 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Obx(
        () {
          final bool topic = controller.isTopicMode;
          return Stack(
            fit: StackFit.expand,
            children: [
              // Sliding indicator — glides to the active half.
              AnimatedAlign(
                duration: _duration,
                curve: _curve,
                alignment: topic ? Alignment.centerRight : Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.brandColor,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: context.brandColor.applyOpacity(0.30),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Labels sit above the indicator.
              Row(
                children: [
                  _Segment(
                    label: 'Select Drivers',
                    icon: Icons.people_alt_outlined,
                    selected: !topic,
                    onTap: () =>
                        controller.setAudienceMode(DriverAudienceMode.specific),
                    theme: theme,
                  ),
                  _Segment(
                    label: 'By Topic',
                    icon: Icons.campaign_outlined,
                    selected: topic,
                    onTap: () =>
                        controller.setAudienceMode(DriverAudienceMode.topic),
                    theme: theme,
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

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Colors.white;
    final Color idleColor = context.isDark ? Colors.white70 : Colors.black54;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: selected ? 1 : 0),
          duration: AudienceModeToggle._duration,
          curve: AudienceModeToggle._curve,
          builder: (context, t, _) {
            final Color color = Color.lerp(idleColor, selectedColor, t)!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight:
                          FontWeight.lerp(FontWeight.w500, FontWeight.w600, t),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
