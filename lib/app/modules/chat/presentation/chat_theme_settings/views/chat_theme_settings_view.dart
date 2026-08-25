import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../controllers/chat_theme_settings_controller.dart';

class ChatThemeSettingsView extends GetView<ChatThemeSettingsController> {
  const ChatThemeSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              //
              //
              // header
              const _Header(),

              //
              //
              // body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //
                      //
                      // image from gallery button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.chooseFromGallery();
                          },
                          child: Row(
                            children: [
                              //
                              // icon
                              Icon(
                                Icons.photo_library_outlined,
                                size: 25,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : AppColorsLight.mainColor,
                              ).marginOnly(right: 10),

                              //
                              // text
                              Text(
                                "Choose from gallery",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColorsLight.mainColor,
                                ),
                              ),
                            ],
                          ).marginSymmetric(horizontal: 14, vertical: 10),
                        ),
                      ).marginOnly(top: 20),

                      //
                      //
                      // sold color heading
                      Row(
                        children: [
                          Text(
                            "Solid Color",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ).marginOnly(top: 20, left: 14),

                      //
                      //
                      // color picker
                      Container(
                        margin: const EdgeInsets.only(
                          top: 5,
                          left: 14,
                          right: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ColorPicker(
                          pickerColor: controller.selectedColor.value,
                          onColorChanged: (color) {
                            controller.selectedColor.value = color;
                          },
                          pickerAreaBorderRadius: BorderRadius.circular(20),
                          pickerAreaHeightPercent: 0.5,
                          colorPickerWidth: Get.width - 28,
                          portraitOnly: true,
                          paletteType: PaletteType.hsl,
                          labelTypes: const [],
                          displayThumbColor: true,
                        ),
                      ),

                      //
                      //
                      // use this color button
                      TextButton(
                        onPressed: () {
                          controller.useSolidColor();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Use this color",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : AppColorsLight.mainColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 25,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColorsLight.mainColor,
                            ).marginOnly(left: 10),
                          ],
                        ),
                      ).marginOnly(right: 14, top: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<ChatThemeSettingsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ).paddingOnly(right: 10),

          //
          //
          //
          Expanded(
            child: Row(
              children: [
                Text(
                  'Chat Wallpaper',
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          //
          //
          // action button
          IconButton(
            onPressed: () {
              controller.resetTheme();
            },
            icon: const Icon(
              Icons.settings_backup_restore_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
