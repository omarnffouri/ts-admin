import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../controllers/login_controller.dart';

class GlassTextField extends StatefulWidget {
  const GlassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.passwordView = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool passwordView;

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.passwordView && _hidePassword,
      maxLength: 80,
      style: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      cursorColor: const Color(0xFFFF2D3B),
      textInputAction:
          widget.passwordView ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (_) {
        if (widget.passwordView) {
          Get.find<LoginController>().login();
        }
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Get.isDarkMode
              ? Colors.white.applyOpacity(0.42)
              : Colors.black.applyOpacity(0.42),
          fontSize: 13.sp,
          letterSpacing: 0,
        ),
        prefixIcon: Icon(
          widget.icon,
          color: const Color(0xFFFF3342).applyOpacity(0.9),
          size: 21.r,
        ),
        suffixIcon: widget.passwordView
            ? IconButton(
                splashRadius: 20.r,
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: (Get.isDarkMode ? Colors.white : Colors.black)
                      .applyOpacity(0.48),
                  size: 20.r,
                ),
              )
            : null,
        filled: true,
        fillColor: Get.isDarkMode
            ? Colors.white.applyOpacity(0.075)
            : Colors.black.applyOpacity(0.075),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 17.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
              color: Get.isDarkMode
                  ? Colors.white.applyOpacity(0.12)
                  : Colors.black.applyOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: Color(0xFFFF2A39), width: 1.2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
              color: (Get.isDarkMode ? Colors.white : Colors.black)
                  .applyOpacity(0.12)),
        ),
      ),
    );
  }
}
