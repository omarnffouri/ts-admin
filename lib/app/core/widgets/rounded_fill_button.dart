import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class RoundedFillButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color labelColor;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double radius;

  const RoundedFillButton({
    super.key,
    required this.label,
    this.labelColor = Colors.white,
    this.backgroundColor = AppColorsLight.mainColor,
    required this.onPressed,
    this.isLoading = false,
    this.radius = 10,
    this.leadingIcon,
    this.trailingIcon,
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
                borderRadius: BorderRadius.circular(radius),
                // Adjust the radius as needed
              ),
              backgroundColor: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leadingIcon != null) leadingIcon!,
                        Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: labelColor,
                          ),
                        ),
                        if (trailingIcon != null) trailingIcon!,
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
