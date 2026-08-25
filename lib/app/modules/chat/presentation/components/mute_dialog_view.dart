import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat/domain/enums/mute_enums.dart';

class MuteDialogView extends StatelessWidget {
  final void Function(String muteDuration) onDurationSelection;
  final void Function() onCancle;

  MuteDialogView({
    super.key,
    required this.onDurationSelection,
    required this.onCancle,
  });

  final selectedOption = MuteEnums.hours.obs;

  @override
  Widget build(BuildContext context) {
    //
    // theme
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? const Color.fromARGB(255, 27, 27, 27)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            constraints: BoxConstraints(maxWidth: Get.width * 0.70),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                // heading
                Text(
                  "Mute notifications",
                  style: theme.textTheme.titleLarge,
                ),

                //
                //
                // message description
                Text(
                  "Other members will not see that you muted this chat.",
                  style: theme.textTheme.bodyMedium,
                ).marginOnly(top: 10),

                //
                //
                // mute duration radio buttons
                Obx(
                  () => RadioGroup<String>(
                    groupValue: selectedOption.value,
                    onChanged: (value) {
                      if (value != null) {
                        selectedOption.value = value;
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 8 hours
                        _buildRadioButton(MuteEnums.hours).marginOnly(top: 20),

                        // 1 week
                        _buildRadioButton(MuteEnums.week),

                        // always
                        _buildRadioButton(MuteEnums.always),
                      ],
                    ),
                  ),
                ),

                //
                //
                // confirmation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //
                    //
                    // cancel button
                    GestureDetector(
                      onTap: () {
                        onCancle();
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColorsLight.mainColor,
                        ),
                      ),
                    ),

                    //
                    //
                    // ok button
                    GestureDetector(
                      onTap: () {
                        onDurationSelection(selectedOption.value);
                        Get.back();
                      },
                      child: Text(
                        "OK",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColorsLight.mainColor,
                        ),
                      ),
                    ).marginOnly(left: 50),
                  ],
                ).marginOnly(bottom: 10, right: 20, top: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
        ),
        GestureDetector(
          onTap: () {
            selectedOption.value = value;
          },
          child: Text(
            MuteEnums.getName(value),
          ),
        )
      ],
    );
  }
}
