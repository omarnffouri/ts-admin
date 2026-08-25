import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// One grouped surface used by every section of the shop create/edit forms
/// (supplier and client information, contact information) — an icon + label
/// heading above a themed, bordered card, matching CreateTaskView /
/// CreateAnnouncementView.
class ShopFormSection extends StatelessWidget {
  const ShopFormSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.spacing = 16,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 16, color: context.secondaryTextColor),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.tileColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.hairlineBorderColor),
            boxShadow: dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing,
            children: children,
          ),
        ),
      ],
    );
  }
}
