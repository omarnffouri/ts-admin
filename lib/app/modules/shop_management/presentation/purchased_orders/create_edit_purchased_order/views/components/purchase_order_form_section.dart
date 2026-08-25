import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class PurchaseOrderFormSection extends StatelessWidget {
  const PurchaseOrderFormSection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget child;

  final Widget? action;

  static const double _stackActionBelowWidth = 360;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.045),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final bool stackAction = action != null &&
                  constraints.maxWidth < _stackActionBelowWidth;

              final Widget heading = Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.brandColor.applyOpacity(0.08),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, size: 19, color: context.brandColor),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                  if (action != null && !stackAction) ...[
                    const SizedBox(width: 10),
                    action!,
                  ],
                ],
              );

              if (!stackAction) return heading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading,
                  const SizedBox(height: 12),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: action!),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Theme(
            data: theme.copyWith(
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                filled: true,
                fillColor: context.fieldFillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                border: _border(context),
                enabledBorder: _border(context),
                focusedBorder: _border(context, focused: true),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context, {bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: focused
          ? BorderSide(color: context.focusedBorderColor, width: 1.4)
          : BorderSide(color: context.hairlineBorderColor),
    );
  }
}

/// Pill action used for section-level actions such as "Add Part": an icon and
/// a label, with a tooltip and a screen-reader label for the icon.
class PurchaseOrderSectionAction extends StatelessWidget {
  const PurchaseOrderSectionAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.semanticsLabel,
    this.tooltip,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? semanticsLabel;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      excludeSemantics: true,
      child: Tooltip(
        message: tooltip ?? label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.brandColor.applyOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.brandColor.applyOpacity(0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: context.brandColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: context.brandColor,
                        fontWeight: FontWeight.w700,
                      ),
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
