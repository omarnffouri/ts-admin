import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionSignaturePad extends StatelessWidget {
  const InspectionSignaturePad({
    super.key,
    required this.controller,
    required this.onUndo,
    this.undoLabel = 'Undo',
    this.helperText,
  });

  final SignatureController controller;
  final VoidCallback onUndo;
  final String undoLabel;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final double padHeight =
        (MediaQuery.sizeOf(context).height * 0.18).clamp(140.0, 220.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // pad surface
        Semantics(
          label: 'Signature pad, draw your signature inside this area',
          child: Container(
            height: padHeight,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: context.tileColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.panelBorderColor),
            ),
            child: Signature(
              controller: controller,
              // Matches the pen color chosen for the active theme, so strokes
              // stay legible in both light and dark mode.
              backgroundColor: context.tileColor,
            ),
          ),
        ),

        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.tertiaryTextColor,
            ),
          ),
        ],

        const SizedBox(height: 12),

        //
        // secondary action
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _SecondaryButton(
            icon: Icons.undo_rounded,
            label: undoLabel,
            onTap: onUndo,
          ),
        ),
      ],
    );
  }
}

/// Outlined secondary action sized for comfortable tapping.
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.panelBorderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: context.primaryTextColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
