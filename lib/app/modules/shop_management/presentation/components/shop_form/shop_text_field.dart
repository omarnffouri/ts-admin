import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// The one themed text-field shape reused by every field on the redesigned
/// forms (shop supplier/client, update profile, update password): a persistent
/// label with the required asterisk, a filled card-surface background, hairline
/// idle border, brand-colored focus ring and an explicit error border —
/// matching CreateTaskView / CreateAnnouncementView.
///
/// Only the field-specific props change per use; validation, formatters and
/// controllers are always supplied by the caller so behavior stays unchanged.
/// [maxLength] defaults to 50 — the same cap RoundedInputField applied to
/// every field on these forms before the redesign — and the counter stays
/// hidden, as it was.
class ShopTextField extends StatelessWidget {
  const ShopTextField({
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
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.obscureText = false,
    this.autofillHints,
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
  final IconData? prefixIcon;

  /// Trailing widget inside the field (e.g. a password visibility toggle).
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;

  /// Obscures the entered text. The caller owns the toggle state, so a field
  /// can stay hidden by default and reveal on demand.
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final String? semanticsLabel;

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
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: theme.colorScheme.error),
    );

    final Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          ShopFieldLabel(label: label!, isRequired: isRequired),
          const SizedBox(height: 8),
        ],
        TextFormField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          obscureText: obscureText,
          autofillHints: autofillHints,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          style: theme.textTheme.bodyMedium,
          validator: validator,
          decoration: InputDecoration(
            counterText: '',
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
            disabledBorder: idleBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.4,
              ),
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            errorMaxLines: 3,
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

/// Persistent field label with the form-wide required convention (a
/// brand-colored asterisk plus a "required" hint for screen readers, so the
/// state is never carried by color alone).
class ShopFieldLabel extends StatelessWidget {
  const ShopFieldLabel({
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
        textScaler: MediaQuery.textScalerOf(context),
      ),
    );
  }
}
