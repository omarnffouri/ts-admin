import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class StepNavigationBar extends StatelessWidget {
  const StepNavigationBar({
    super.key,
    required this.onNext,
    required this.nextLabel,
    this.onBack,
    this.isLoading = false,
    this.nextIcon,
  });

  final VoidCallback? onBack;
  final VoidCallback onNext;
  final String nextLabel;
  final bool isLoading;
  final IconData? nextIcon;

  static const double _minActionSize = 52;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = context.brandColor;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final IconData backIcon =
        isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded;
    final IconData forwardIcon = nextIcon ??
        (isRtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onBack != null) ...[
            Semantics(
              button: true,
              label: 'Back to previous step',
              child: Material(
                color: context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: isLoading ? null : onBack,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: _minActionSize,
                      minHeight: _minActionSize,
                    ),
                    alignment: Alignment.center,
                    child: Icon(backIcon, color: context.primaryTextColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Semantics(
              button: true,
              enabled: !isLoading,
              label: isLoading ? 'Submitting, please wait' : nextLabel,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: isLoading ? null : onNext,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: accent.applyOpacity(0.30),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: _minActionSize,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: isLoading
                            ? const SizedBox(
                                key: ValueKey('loading'),
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.4,
                                  strokeCap: StrokeCap.round,
                                ),
                              )
                            : Row(
                                key: const ValueKey('label'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      nextLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.titleSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(forwardIcon,
                                      size: 18, color: Colors.white),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
