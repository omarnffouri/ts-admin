import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import 'vehicle_section.dart';

class ExpandableVehicleSection extends StatelessWidget {
  const ExpandableVehicleSection({
    super.key,
    required this.icon,
    required this.title,
    required this.collapsed,
    required this.expanded,
    this.count,
    this.action,
  });

  final IconData icon;
  final String title;

  /// Preview shown while the section is collapsed.
  final Widget collapsed;

  /// Full body shown once the section is expanded.
  final Widget expanded;

  final int? count;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    return VehicleSectionCard(
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          iconColor: context.secondaryTextColor,
          iconSize: 24,
          iconPadding: const EdgeInsets.only(right: 12),
          expandIcon: Icons.keyboard_arrow_down_rounded,
          collapseIcon: Icons.keyboard_arrow_up_rounded,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          animationDuration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 260),
        ),
        header: VehicleSectionHeader(
          icon: icon,
          title: title,
          count: count,
          action: action,
          padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 0, 12),
        ),
        collapsed: _Body(child: collapsed),
        expanded: _Body(child: expanded),
      ),
    );
  }
}

/// Shared insets for both panel states so the body never jumps horizontally
/// while expanding.
class _Body extends StatelessWidget {
  const _Body({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: child,
    );
  }
}
