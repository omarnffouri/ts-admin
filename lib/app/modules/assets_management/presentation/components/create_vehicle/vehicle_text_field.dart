import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class VehicleTextField extends StatelessWidget {
  const VehicleTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.fieldKey,
    this.label,
    this.isRequired = false,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLength = 50,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.showCounter = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.semanticsLabel,
  });

  final GlobalKey<FormFieldState<String>>? fieldKey;
  final TextEditingController controller;
  final String hintText;
  final String? label;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showCounter;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          VehicleFieldLabel(label: label!, isRequired: isRequired),
          const SizedBox(height: 8),
        ],
        TextFormField(
          key: fieldKey,
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          style: theme.textTheme.bodyMedium,
          validator: validator,
          buildCounter: showCounter
              ? (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$currentLength / ${maxLength ?? 0}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.tertiaryTextColor,
                      ),
                    ),
                  );
                }
              : null,
          decoration: InputDecoration(
            counterText: showCounter ? null : '',
            filled: true,
            fillColor: context.fieldFillColor,
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(color: context.hintTextColor, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: vehicleIdleInputBorder(context),
            enabledBorder: vehicleIdleInputBorder(context),
            focusedBorder: vehicleFocusedInputBorder(context),
            errorBorder: vehicleErrorInputBorder(context),
            focusedErrorBorder: vehicleErrorInputBorder(context, focused: true),
            disabledBorder: vehicleIdleInputBorder(context),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 18, color: context.secondaryTextColor),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );

    if (semanticsLabel == null) {
      return field;
    }

    return Semantics(
      label: semanticsLabel,
      textField: true,
      child: field,
    );
  }
}

class VehicleFieldLabel extends StatelessWidget {
  const VehicleFieldLabel({
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

OutlineInputBorder vehicleIdleInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.hairlineBorderColor),
  );
}

OutlineInputBorder vehicleFocusedInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
  );
}

OutlineInputBorder vehicleErrorInputBorder(
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
