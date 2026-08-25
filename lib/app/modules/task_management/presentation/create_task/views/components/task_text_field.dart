import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// The one themed text-field shape reused by every field on the Create Task
/// form (title, category, due date, description): filled card-surface
/// background, hairline idle border, brand-colored focus ring, and a
/// required asterisk in the label — matching the styling used in
/// CreateAnnouncementView. Only the field-specific props change per use.
class TaskTextField extends StatelessWidget {
  const TaskTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.label,
    this.isRequired = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.showCounter = false,
    this.prefixIcon,
    this.inputFormatters,
    this.onChanged,
  });

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
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final OutlineInputBorder idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.hairlineBorderColor),
    );
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                      text: ' *', style: TextStyle(color: context.brandColor)),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
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
            border: idleBorder,
            enabledBorder: idleBorder,
            focusedBorder: focusedBorder,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 18, color: context.secondaryTextColor),
          ),
        ),
      ],
    );
  }
}
