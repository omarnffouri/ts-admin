import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final String? label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool passwordView;
  final bool showCounting;
  final bool readOnly;
  final int maxLength;
  final int? maxLines;
  final int? minLines;
  final EdgeInsets contentPadding;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Function? onTap;
  final bool isRequired;
  final FocusNode? focusNode;
  final bool? autoFoucs;
  final TextStyle? textStyle;
  final TextStyle? lableTextStyle;
  final TextStyle? hintTextStyle;
  final TextAlign textAlign;
  final bool enableBorders;
  final Color borderColor;
  final double borderRadius;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const RoundedInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.passwordView = false,
    this.maxLength = 50,
    this.suffixIcon,
    this.validator,
    this.showCounting = false,
    this.onTap,
    this.readOnly = false,
    this.label,
    this.isRequired = false,
    this.maxLines = 1,
    this.minLines,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.focusNode,
    this.autoFoucs,
    this.textStyle,
    this.lableTextStyle,
    this.hintTextStyle,
    this.textAlign = TextAlign.start,
    this.enableBorders = true,
    this.borderColor = Colors.grey,
    this.borderRadius = 8,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: TextFormField(
        textAlign: widget.textAlign,
        autofocus: widget.autoFoucs ?? false,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.passwordView ? hidePassword : false,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
        minLines: widget.minLines,
        style: widget.textStyle,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          counterText: widget.showCounting ? null : "",
          hintText: widget.hintText,
          label: widget.label == null
              ? null
              : RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      if (widget.isRequired)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )
                    ],
                  ),
                ),
          enabledBorder: widget.readOnly
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                )
              : null,
          focusedBorder: widget.enableBorders
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                      color: widget.readOnly
                          ? Colors.grey
                          : AppColorsLight.mainColor),
                )
              : null,
          border: widget.enableBorders
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.2,
                    color: widget.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                )
              : null,
          contentPadding: widget.contentPadding,
          suffixIcon: widget.passwordView
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColorsLight.mainColor,
                  ),
                )
              : widget.suffixIcon,
          labelStyle: widget.lableTextStyle,
          hintStyle: widget.hintTextStyle,
        ),
        validator: widget.validator ??
            (value) {
              return null;
            },
        onTap: widget.onTap as void Function()?,
      ),
    );
  }
}
