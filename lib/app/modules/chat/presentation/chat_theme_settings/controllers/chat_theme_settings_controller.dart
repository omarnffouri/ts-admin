import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_theme_file_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/data/models/chat_theme_model.dart';
import 'package:ts_admin/app/modules/chat/presentation/chat_theme_settings/views/chat_theme_preview_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class ChatThemeSettingsController extends GetxController {
  //
  final storage = GetStorage();

  //
  // data variables
  final Rx<Color> selectedColor = const Color(0xFFF44336).obs;
  final Rxn<File> selectedFile = Rxn();
  final RxBool patterenEnabled = true.obs;
  final RxDouble brightness = (-0.5).obs;
  final Rx<ChatThemeType> selectedThemeType = ChatThemeType.color.obs;

  ///
  ///
  /// function that will select image from the gallery and
  /// navigate to preview screen
  void chooseFromGallery() async {
    try {
      final havePermission = await PermissionHelper.havePhotosPermission(
        "Need photos permission in order to set photo as chat background.",
      );

      if (!havePermission) {
        return;
      }

      final result = await MediaPicker.selectSingleImage();

      if (result != null) {
        selectedFile.value = result;
        patterenEnabled.value = false;
        brightness.value = (-0.5);
        selectedThemeType.value = ChatThemeType.image;
        Get.to(() => const ChatThemePreviewView());
      }
    } catch (_) {}
  }

  ///
  ///
  ///
  /// user this selected solid color
  void useSolidColor() async {
    selectedFile.value = null;
    patterenEnabled.value = true;
    brightness.value = (-0.5);
    selectedThemeType.value = ChatThemeType.color;
    Get.to(() => const ChatThemePreviewView());
  }

  //
  //
  // reset theme
  void resetTheme() async {
    try {
      selectedThemeType.value = ChatThemeType.color;
      await storage.remove(UserPrefKeys.chatTheme);
      await ChatThemeFileHelper.instance.deleteFile();
      CommonWidgets.showSnackBar(
        title: "Success",
        message: "Chat theme set to default.",
        isError: false,
      );
    } catch (_) {}
  }

  //
  //
  // on theme confirmations
  void saveTheme() async {
    try {
      File? savedFile;
      if (selectedFile.value != null) {
        savedFile = await ChatThemeFileHelper.instance
            .saveThemeFile(selectedFile.value!);
      }

      //
      // build chat theme data object
      final data = ChatThemeModel(
        type: selectedThemeType.value,
        // ignore: deprecated_member_use
        color: selectedColor.value.value,
        image: savedFile?.path,
        patternEnabled: patterenEnabled.value,
        brightness: brightness.value,
      );

      debugPrint("saving chat theme data : ${data.toJson()}");

      //
      // save theme
      await storage.write(UserPrefKeys.chatTheme, data.toJson());

      Get.until((route) {
        return route.settings.name == Routes.SETTINGS;
      });
    } catch (_) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Error while saving chat theme.",
      );
    }
  }
}
