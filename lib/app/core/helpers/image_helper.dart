import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageHelper {
  static Future<CroppedFile?> cropProcess(
      File image, List<CropAspectRatioPreset> aspectRatio) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 80,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image'.tr,
            toolbarColor: Get.theme.primaryColor,
            toolbarWidgetColor: const Color(0xff2D264B),
            aspectRatioPresets: aspectRatio,
            initAspectRatio: aspectRatio.isEmpty
                ? CropAspectRatioPreset.original
                : aspectRatio[0]),
        IOSUiSettings(title: 'Cropper', aspectRatioPresets: aspectRatio),
        WebUiSettings(
          context: Get.context!,
        ),
      ],
    );
    return croppedFile;
  }
}
