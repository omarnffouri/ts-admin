import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionFieldLabel extends StatelessWidget {
  const InspectionFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: isRequired ? '$label, required' : label,
      excludeSemantics: true,
      child: RichText(
        text: TextSpan(
          text: label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
          children: [
            if (isRequired)
              TextSpan(
                text: ' *',
                style: TextStyle(color: context.brandColor),
              ),
          ],
        ),
      ),
    );
  }
}

/// Themed text input with a persistent label. Every behavioural property
/// (controller, keyboard type, formatters, max length, validator, read-only)
/// is passed through unchanged by the caller.
class InspectionTextField extends StatelessWidget {
  const InspectionTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.fieldKey,
    this.isRequired = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.suffixIcon,
    this.semanticsLabel,
  });

  final Key? fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget field = Column(
      key: fieldKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InspectionFieldLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          validator: validator,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: context.fieldFillColor,
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(color: context.hintTextColor, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: inspectionIdleInputBorder(context),
            enabledBorder: inspectionIdleInputBorder(context),
            focusedBorder: inspectionFocusedInputBorder(context),
            errorBorder: inspectionErrorInputBorder(context),
            focusedErrorBorder:
                inspectionErrorInputBorder(context, focused: true),
            disabledBorder: inspectionIdleInputBorder(context),
            suffixIcon: suffixIcon,
            suffixIconConstraints: suffixIcon == null
                ? null
                : const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ),
      ],
    );

    if (semanticsLabel == null) {
      return field;
    }

    return Semantics(
      label: semanticsLabel,
      textField: !readOnly,
      button: readOnly,
      child: field,
    );
  }
}

OutlineInputBorder inspectionIdleInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.hairlineBorderColor),
  );
}

OutlineInputBorder inspectionFocusedInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
  );
}

OutlineInputBorder inspectionErrorInputBorder(
  BuildContext context, {
  bool focused = false,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: Theme.of(context).colorScheme.error,
      width: focused ? 1.4 : 1,
    ),
  );
}
