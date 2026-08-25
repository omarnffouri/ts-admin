import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ClipboardHelper {
  /// This function will copy plain text/string to clipboard as plain text
  static Future copyPlainText(String plainText,
      {bool showSnackBar = false, String message = ""}) async {
    Clipboard.setData(ClipboardData(text: plainText));

    if (showSnackBar) {
      try {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            duration: const Duration(seconds: 1),
            backgroundColor: AppColorsLight.mainColor.applyOpacity(0.8),
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ).marginOnly(right: 5),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      } catch (_) {}
    }
  }

  /// This function will check for the plain text in clipboard and return plain text as String?
  static Future<String?> readPlainText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}
