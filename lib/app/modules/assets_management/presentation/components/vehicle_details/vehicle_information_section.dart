import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/helpers/clipboard_helper.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import 'vehicle_section.dart';

class VehicleInformationSection extends StatelessWidget {
  const VehicleInformationSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;

  /// Rows of the section, usually [VehicleInformationRow]s.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VehicleSection(
      icon: icon,
      title: title,
      bodyPadding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: children,
      ),
    );
  }
}

/// One label/value pair.
///
/// The value keeps the tap-to-copy affordance the page already had. Layout is
/// fluid: label and value sit side by side when there is room and stack once
/// the row gets narrow or the user scales text up, so long VINs, owner names
/// and state names wrap instead of overflowing.
class VehicleInformationRow extends StatelessWidget {
  const VehicleInformationRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;

  /// Raw value as the page resolves it today — already formatted by the
  /// existing date/weight/fallback helpers.
  final String? value;

  /// Fallback the page has always used for values the API did not return.
  static const String fallback = 'N/A';

  bool get _hasValue {
    final String? trimmed = value?.trim();
    return trimmed != null &&
        trimmed.isNotEmpty &&
        trimmed != 'null' &&
        trimmed != fallback;
  }

  void _copy() {
    try {
      ClipboardHelper.copyPlainText(
        value ?? "",
        showSnackBar: true,
        message: "$label copied successfully.",
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasValue = _hasValue;

    final Widget labelView = Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: context.secondaryTextColor,
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
    );

    return Semantics(
      label: '$label: ${hasValue ? value! : fallback}',
      button: hasValue,
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: labelView),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _ValueView(
                value: value,
                hasValue: hasValue,
                align: TextAlign.end,
                onCopy: hasValue ? _copy : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Muted rendering of a value the API did not provide, so a missing field still
/// reads as a deliberate row instead of a blank line.
class VehicleInformationEmptyValue extends StatelessWidget {
  const VehicleInformationEmptyValue({super.key, this.align = TextAlign.end});

  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      VehicleInformationRow.fallback,
      textAlign: align,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.tertiaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
    );
  }
}

class _ValueView extends StatelessWidget {
  const _ValueView({
    required this.value,
    required this.hasValue,
    required this.align,
    required this.onCopy,
  });

  final String? value;
  final bool hasValue;
  final TextAlign align;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    if (!hasValue) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: VehicleInformationEmptyValue(align: align),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            value!,
            textAlign: align,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
          ),
        ),
      ),
    );
  }
}
