import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });

  final bool isLoading;
  final void Function() onTap;
  final String text;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColorsDark.mainRedColor
              : AppColorsLight.mainColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColorsLight.mainColor,
          ),
        ),
        child: widget.isLoading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              )
            : Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
