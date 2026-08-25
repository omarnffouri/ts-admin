import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionDetailsSection extends StatelessWidget {
  const InspectionDetailsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
    this.trailing,
    this.padded = true,
    this.spacing = 16,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Optional widget rendered under the heading (e.g. the progress summary).
  final Widget? trailing;

  /// When false the children are laid out without the card surface — used by
  /// the checklist, whose categories are cards of their own.
  final bool padded;

  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: children,
    );

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
            const SizedBox(width: 6),
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

        if (trailing != null) ...[
          const SizedBox(height: 12),
          trailing!,
        ],

        const SizedBox(height: 12),

        //
        // body
        if (!padded)
          content
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.tileColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.hairlineBorderColor),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.applyOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: content,
          ),
      ],
    );
  }
}
