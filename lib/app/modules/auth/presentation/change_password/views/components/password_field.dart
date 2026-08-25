import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/shop_form/shop_text_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hintText,
    required this.semanticsLabel,
    required this.showToggleLabel,
    required this.hideToggleLabel,
    required this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  final GlobalKey<FormFieldState<String>> fieldKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hintText;

  /// Screen-reader label for the input itself.
  final String semanticsLabel;

  /// Screen-reader labels for the visibility control in each of its states.
  final String showToggleLabel;
  final String hideToggleLabel;

  final String? Function(String?) validator;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  /// Obscured until the user asks otherwise.
  bool _obscured = true;

  void _toggleObscured() {
    setState(() => _obscured = !_obscured);
  }

  @override
  Widget build(BuildContext context) {
    return ShopTextField(
      fieldKey: widget.fieldKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      label: widget.label,
      hintText: widget.hintText,
      semanticsLabel: widget.semanticsLabel,
      isRequired: true,
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: _obscured,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      suffixIcon: _VisibilityToggle(
        obscured: _obscured,
        onPressed: _toggleObscured,
        showLabel: widget.showToggleLabel,
        hideLabel: widget.hideToggleLabel,
      ),
    );
  }
}

class _VisibilityToggle extends StatelessWidget {
  const _VisibilityToggle({
    required this.obscured,
    required this.onPressed,
    required this.showLabel,
    required this.hideLabel,
  });

  final bool obscured;
  final VoidCallback onPressed;
  final String showLabel;
  final String hideLabel;

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: Semantics(
        button: true,
        label: obscured ? showLabel : hideLabel,
        child: IconButton(
          onPressed: onPressed,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          padding: EdgeInsets.zero,
          splashRadius: 22,
          icon: Icon(
            obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            size: 20,
            color: context.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
