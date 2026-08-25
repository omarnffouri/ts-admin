import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color headingColor = context.secondaryTextColor;

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
              child: Icon(icon, size: 16, color: headingColor),
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

        //
        // rows
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _withDividers(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _withDividers(BuildContext context) {
    final List<Widget> rows = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          Divider(
            height: 1,
            thickness: 0.6,
            indent: 60,
            color: context.hairlineBorderColor,
          ),
        );
      }
      rows.add(children[i]);
    }

    return rows;
  }
}
