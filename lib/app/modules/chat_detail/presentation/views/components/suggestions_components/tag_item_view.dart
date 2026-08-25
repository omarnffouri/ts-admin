import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class TagItemView extends StatelessWidget {
  final String tag;
  final VoidCallback? onClick;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  const TagItemView({
    super.key,
    required this.tag,
    this.onClick,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: backgroundColor ??
              (Get.isDarkMode
                  ? Colors.grey.applyOpacity(0.2)
                  : AppColorsLight.mainColor.applyOpacity(0.05)),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: borderColor ??
                (Get.isDarkMode
                    ? Colors.grey.applyOpacity(0.5)
                    : AppColorsLight.mainColor.applyOpacity(0.5)),
          ),
        ),
        child: Text(
          tag,
          style: context.textTheme.bodySmall?.copyWith(
            color: textColor ??
                (Get.isDarkMode ? Colors.white : AppColorsLight.mainColor),
          ),
        ),
      ),
    );
  }
}
