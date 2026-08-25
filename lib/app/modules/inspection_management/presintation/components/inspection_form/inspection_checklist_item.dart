import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_custom_switch.dart';

class InspectionChecklistItem extends StatelessWidget {
  const InspectionChecklistItem({
    super.key,
    required this.title,
    required this.isPassed,
    required this.onChanged,
  });

  final String title;
  final bool isPassed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return MergeSemantics(
      child: Semantics(
        toggled: isPassed,
        label: title,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // Same handler as the switch — tapping the row is just a bigger
            // target for the identical action.
            onTap: () => onChanged(!isPassed),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: context.primaryTextColor,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ExcludeSemantics(
                    child: CustomSwitch(
                      value: isPassed,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
