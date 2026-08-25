import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

// ignore: must_be_immutable
class CustomSwitch extends StatefulWidget {
  CustomSwitch({super.key, this.value = false, required this.onChanged});
  bool value;
  Function(bool val) onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      activeThumbColor: Colors.white,
      activeTrackColor: Get.isDarkMode
          ? AppColorsDark.mainRedColor
          : AppColorsLight.mainColor,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.applyOpacity(0.3),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.transparent
            : Colors.grey.applyOpacity(0.5),
      ),
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
