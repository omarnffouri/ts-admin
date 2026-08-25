import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class RoundedBorderButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color labelColor;
  final Color borderColor;
  final Widget? startIcon;
  final Widget? endIcon;
  final double? borderWidth;

  const RoundedBorderButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.labelColor = AppColorsLight.mainColor,
    this.borderColor = AppColorsLight.mainColor,
    this.borderWidth,
    this.startIcon,
    this.endIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: borderColor,
                  width: borderWidth ?? 0.5,
                ),
              ),
              backgroundColor: backgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (startIcon != null) startIcon!,
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: labelColor),
                  ),
                ),
                if (endIcon != null) endIcon!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
