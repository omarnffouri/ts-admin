import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Themed empty/error state shown under a dropdown-driven step when its list
/// failed to load or came back empty, with a retry action.
class DropdownNotAvailableWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const DropdownNotAvailableWidget(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        border: Border.all(color: context.hairlineBorderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: context.secondaryTextColor,
          ),
          const SizedBox(width: 8),

          //
          // message
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.labelMedium?.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),

          //
          // retry action
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: context.brandColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Retry",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: context.brandColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
