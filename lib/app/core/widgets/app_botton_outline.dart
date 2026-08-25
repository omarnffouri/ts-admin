import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButtonOutline extends StatefulWidget {
  const AppButtonOutline({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });

  final bool isLoading;
  final void Function() onTap;
  final String text;

  @override
  State<AppButtonOutline> createState() => _AppButtonOutlineState();
}

class _AppButtonOutlineState extends State<AppButtonOutline> {
  @override
  Widget build(BuildContext context) {
    // Neutral grey secondary action, so it never competes with the primary
    // (brand red) button next to it.
    final bool isDark = Get.isDarkMode;
    final Color background =
        isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final Color border = isDark ? Colors.grey.shade600 : Colors.grey.shade400;
    final Color foreground =
        isDark ? Colors.grey.shade200 : Colors.grey.shade800;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: widget.isLoading
            ? SizedBox(
                height: 25,
                width: 25,
                child: Center(
                  child: CircularProgressIndicator(
                    color: foreground,
                    strokeWidth: 3,
                  ),
                ),
              )
            : Text(
                widget.text,
                style: TextStyle(
                  color: foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
