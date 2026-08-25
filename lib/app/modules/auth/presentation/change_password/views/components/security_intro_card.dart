import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Compact security introduction above the form.
///
/// The only requirement shown is the one the existing validation already
/// enforces (a minimum of 8 characters) — no new rule is implied or added.
class SecurityIntroCard extends StatelessWidget {
  const SecurityIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // lock badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.brandColor.applyOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 20,
              color: context.brandColor,
            ),
          ),

          const SizedBox(width: 12),

          //
          // copy
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account security',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose a secure password for your account.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                const _RequirementChip(
                  label: 'At least 8 characters',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single password requirement — icon plus text, so it never relies on color
/// alone to be understood.
class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 14,
            color: context.secondaryTextColor,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
