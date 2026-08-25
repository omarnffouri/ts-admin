import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/helpers/image_matrixes.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/read_more_text.dart';
import 'package:ts_admin/app/modules/chat/data/models/chat_theme_model.dart';
import 'package:ts_admin/app/modules/chat/presentation/chat_theme_settings/controllers/chat_theme_settings_controller.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

part './components/message_sender_view.dart';
part './components/message_receiver_view.dart';

class ChatThemePreviewView extends GetView<ChatThemeSettingsController> {
  const ChatThemePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.selectedThemeType.value = ChatThemeType.color;
        controller.selectedFile.value = null;
      },
      child: Scaffold(
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
                  child: Stack(
                    children: [
                      //
                      //
                      // background
                      Obx(
                        () => ColorFiltered(
                          colorFilter: ColorFilter.matrix(
                            ImageEditingMatrixes.brightnessAdjustMatrix(
                              controller.brightness.value,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.selectedFile.value == null
                                  ? controller.selectedColor.value
                                  : null,
                              image: controller.selectedFile.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        controller.selectedFile.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      //
                      //
                      // chat patteren
                      Positioned.fill(
                        child: Obx(
                          () => Visibility(
                            visible: controller.patterenEnabled.value,
                            child: Image.asset(
                              Assets.chatIcons.chatBackgroundCover.path,
                              fit: BoxFit.cover,
                              opacity: AlwaysStoppedAnimation(
                                Get.isDarkMode ? 0.2 : 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //
                      //
                      // body content
                      Column(
                        children: [
                          //
                          //
                          // receiver message view
                          const _MessageReceiverView().marginOnly(top: 20),

                          //
                          //
                          // sender message view
                          const _MessageSenderView().marginOnly(top: 5),

                          const Spacer(),

                          //
                          //
                          // options view
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              //
                              // pattern option
                              _PatternButton(),

                              //
                              //
                              // brightness sliding view
                              _BrightnessBar(),
                            ],
                          ).marginSymmetric(vertical: 40, horizontal: 20)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  'Preview',
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
              controller.saveTheme();
            },
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternButton extends GetView<ChatThemeSettingsController> {
  const _PatternButton();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.selectedFile.value == null,
        child: GestureDetector(
          onTap: () {
            controller.patterenEnabled.toggle();
          },
          child: Stack(
            children: [
              //
              //
              // pattern button
              Container(
                margin: const EdgeInsets.only(top: 5, right: 5),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? context.theme.scaffoldBackgroundColor
                      : AppColorsLight.mainColor,
                  borderRadius: BorderRadius.circular(
                    99,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_nature_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),

              //
              //
              // enabled/ disabled indicator
              Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: controller.patterenEnabled.value,
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrightnessBar extends GetView<ChatThemeSettingsController> {
  const _BrightnessBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        //
        // brightness slider
        RotatedBox(
          quarterTurns: -1, // Make slider vertical
          child: Obx(
            () => Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Slider(
                value: controller.brightness.value,
                min: -1.0,
                max: 0.0,
                divisions: 10,
                label: ((controller.brightness.value * 100) + 100)
                    .toStringAsFixed(0),
                onChanged: (value) {
                  controller.brightness.value = value;
                },
              ),
            ),
          ),
        ),

        //
        //
        // brighness icon
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? context.theme.scaffoldBackgroundColor
                : AppColorsLight.mainColor,
            borderRadius: BorderRadius.circular(
              99,
            ),
          ),
          child: const Icon(
            Icons.brightness_4_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
