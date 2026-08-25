import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionCardShell extends StatelessWidget {
  const InspectionCardShell({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Hairline separator between two groups inside the same card.
class InspectionCardDivider extends StatelessWidget {
  const InspectionCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, color: context.hairlineBorderColor),
    );
  }
}

/// A titled group of rows — heading, then its content. Rendered without a
/// surface of its own so several groups can share one card.
class InspectionInfoGroup extends StatelessWidget {
  const InspectionInfoGroup({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
    this.spacing = 10,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // heading
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 16, color: context.secondaryTextColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.primaryTextColor,
                      ),
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.tertiaryTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        //
        // body
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing,
          children: children,
        ),
      ],
    );
  }
}

/// A single group that owns its card — used by blocks that stand alone.
class InspectionInfoCard extends StatelessWidget {
  const InspectionInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
    this.spacing = 10,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return InspectionCardShell(
      children: [
        InspectionInfoGroup(
          icon: icon,
          title: title,
          subtitle: subtitle,
          spacing: spacing,
          children: children,
        ),
      ],
    );
  }
}
