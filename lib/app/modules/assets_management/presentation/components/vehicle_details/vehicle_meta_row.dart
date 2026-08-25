import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class VehicleMetaRow extends StatelessWidget {
  const VehicleMetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final String display = value ?? 'N/A';

    return Semantics(
      label: '$label: $display',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 14, color: context.tertiaryTextColor),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$label: ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextSpan(
                      text: display,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: value == null
                                ? context.tertiaryTextColor
                                : context.primaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                style: const TextStyle(height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
