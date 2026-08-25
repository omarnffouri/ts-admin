import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:ts_admin/app/core/widgets/common_widget.dart';

import '../widgets/app_text.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

Future<CroppedFile?> _getImage({
  required ImageSource imageSource,
  bool enableSquare = true,
  bool enableOriginal = true,
  bool enable3x2 = true,
}) async {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  try {
    image = await picker.pickImage(
      source: imageSource,
      imageQuality: 70,
    );
  } on Exception catch (_) {
    // showSnackBar(Get.context!, title: "Error", content: "Invalid Image");
  }

  if (image != null) {
    // check if image extinsion is heic or heif
    final String ext = image.path.split('.').last;
    if (ext == 'heic' || ext == 'heif') {
      await convertHeicOrHeifToJpeg(image);
    }

    final List<CropAspectRatioPreset> aspectRatio = <CropAspectRatioPreset>[];
    if (enableSquare) {
      aspectRatio.add(CropAspectRatioPreset.square);
    }
    if (enable3x2) {
      aspectRatio.add(CropAspectRatioPreset.ratio5x3);
    }
    if (enableOriginal) {
      aspectRatio.add(CropAspectRatioPreset.original);
    }
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 50,
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
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: aspectRatio,
        ),
        WebUiSettings(
          context: Get.context!,
        ),
      ],
    );
    return croppedFile!;
  }
  return null;
}

Future<CroppedFile?> pickFile(
  BuildContext context, {
  bool allowFiles = false,
}) async {
  final pickedFile = await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext builder) => bottomSheet(
      builder,
      allowFiles: allowFiles,
    ),
  );
  return pickedFile;
}

Future<XFile?> convertHeicOrHeifToJpeg(XFile heicOrHeifImage) async {
  final Uint8List imageBytes = await heicOrHeifImage.readAsBytes();

  // Check if the image format is HEIC or HEIF based on the file extension or other criteria.
  // Perform the conversion to JPEG using the flutter_image_compress package.
  final Uint8List jpegBytes = await FlutterImageCompress.compressWithList(
    imageBytes,
    format: CompressFormat.jpeg,
    quality: 70, // Adjust the quality as needed.
  );

  if (jpegBytes.isNotEmpty) {
    // Save the converted JPEG bytes to a temporary file and return its path.
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String tempFileName = '${DateTime.now().millisecondsSinceEpoch}.jpeg';
    final File tempFile = File('$tempPath/$tempFileName');
    await tempFile.writeAsBytes(jpegBytes);
    return XFile(tempFile.path);
  }
  return null; // Return null if the conversion failed.
}

String getFileName(String filePath) {
  String fileName = path.basename(filePath);
  return fileName;
}

Widget bottomSheet(BuildContext context, {bool allowFiles = false}) {
  return SizedBox(
    height: 190.h,
    width: MediaQuery.of(context).size.width,
    child: Card(
      // margin: const EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                addHorizontalSpace(8.h),
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    size: 17.w,
                  ),
                ),
                addHorizontalSpace(8.h),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                iconCreation(
                  Icons.camera_alt,
                  AppColorsLight.mainColor,
                  "Camera".tr,
                  () async {
                    if (!(await PermissionHelper.haveCameraPermission(
                        "Grant camera permission in settings to click photos."))) {
                      return;
                    }
                    final CroppedFile? file = await _getImage(
                      imageSource: ImageSource.camera,
                    );
                    Get.back(result: file);
                  },
                ),
                SizedBox(width: 40.w),
                iconCreation(
                  Icons.photo,
                  AppColorsLight.mainColor,
                  "Gallery".tr,
                  () async {
                    if (!(await PermissionHelper.havePhotosPermission(
                        "Grant photos permission in settings to select photos from the gallery."))) {
                      return;
                    }
                    final CroppedFile? file = await _getImage(
                      imageSource: ImageSource.gallery,
                    );
                    Get.back(result: file);
                  },
                ),
                if (allowFiles) const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}

Widget iconCreation(
  IconData icons,
  Color color,
  String text,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        CircleAvatar(
          radius: 35.r,
          backgroundColor: color,
          child: Icon(
            icons,
            color: Colors.white,
            size: 25.w,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            // fontWeight: FontWeight.w100,
          ),
        )
      ],
    ),
  );
}

String getFileBase64(File? image) {
  if (image != null) {
    List<int> bytes = image.readAsBytesSync();
    String base64Image = base64.encode(bytes);
    // String base64Image = base64Encode(bytes);
    return base64Image;
  }
  return '';
}

String getSignatureBase64(Uint8List? bytes) {
  if (bytes != null) {
    String base64Image = base64.encode(bytes.toList());
    return base64Image;
  }
  return '';
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

formatedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute:$second";
}

Future<Directory?> getDownloadDirectory() async {
  if (Platform.isAndroid) {
    return await getExternalStorageDirectory();
  }
  return await getApplicationDocumentsDirectory();
}

Future<bool> saveFile({
  required String url,
  required String fileName,
  required String folderName,
  required String extnsion,
}) async {
  try {
    if (!(await PermissionHelper.haveStoragePermission(
        "Grant storage permission in settings to download files on your device."))) {
      return false;
    }
    Directory? directory = await getDownloadDirectory();
    String newPath = "";
    List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }
    newPath = "$newPath/$folderName";
    directory = Directory(newPath);
    File saveFile = File("${directory.path}/$fileName$extnsion");
    debugPrint(saveFile.path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await directory.exists()) {
      await Dio().download(
        url,
        saveFile.path,
      );

      CommonWidgets.showSnackBar(
        title: 'Success'.tr,
        isError: false,
        message: 'Downloaded Successfully',
      );
      return true;
    }
  } catch (e) {
    debugPrint('error $e');
    return false;
  }
  return false;
}

void showDeleteDialog(
  BuildContext context,
  Function onDelete,
) {
  Get.defaultDialog(
    title: 'Delete Request',
    titleStyle: Get.theme.textTheme.labelLarge,
    titlePadding: const EdgeInsets.only(top: 10),
    content: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(10),
            Text(
              "are you sure you want to delete this request?",
              style: Get.theme.textTheme.bodyMedium,
            ),
            addVerticalSpace(10),
          ],
        ).paddingSymmetric(horizontal: 20),
        Row(
          children: [
            addHorizontalSpace(10),
            Expanded(
              child: InkWell(
                onTap: () {
                  onDelete();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  child: const Center(
                    child: AppText(
                      text: 'Yes, Delete',
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Get.theme.primaryColor,
                  ),
                  child: const Center(
                    child: AppText(
                      text: 'No',
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ),
            addHorizontalSpace(20),
          ],
        ),
      ],
    ),
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
  );
}

void showImageDialog(BuildContext context, String imageUrl, {String? title}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 60),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Expanded(
                    child: Text(
                      title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white, fontSize: 22),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    value: event == null
                        ? null
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                    color: AppColorsLight.mainColor,
                  ),
                ),
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Color getShipmentStatusColor(String? status) {
  if (status == null) {
    return Colors.grey;
  }
  switch (status.toLowerCase()) {
    case 'waiting':
      return Get.isDarkMode ? Colors.grey.shade700 : Colors.black54;
    case 'transit':
      return Colors.orange;
    case 'transit-complete':
    case 'manual-completed':
    case 'completed':
      return Get.isDarkMode ? Colors.green.shade700 : Colors.green;
    case 'ready-to-invoice':
      return Get.isDarkMode ? Colors.grey.shade700 : Colors.black38;
    case 'invoiced':
      return AppColorsLight.mainColor;
    default:
      return Get.isDarkMode ? Colors.grey.shade700 : Colors.black38;
  }
}

Color getSettlementStatusColor(String? status) {
  if (status == null) {
    return Get.isDarkMode ? Colors.white38 : Colors.grey;
  }
  switch (status.toLowerCase()) {
    case 'pending' || 'under review':
      return Get.isDarkMode ? Colors.white38 : Colors.grey;
    case 'ready to approve':
      return Get.isDarkMode ? Colors.blue : Colors.blue.shade300;
    case 'approved':
      return Colors.orange;
    case 'paid':
      return Get.isDarkMode ? Colors.green.shade700 : Colors.green;
    case 'rejected':
      return Get.isDarkMode ? Colors.red.shade700 : Colors.red;
    default:
      return Get.isDarkMode ? Colors.white38 : Colors.grey;
  }
}

String formatSettlementStatus(String? status) {
  switch (status) {
    case 'pending':
      return 'Pending';
    case 'under review':
      return 'Under Review';
    case 'ready to approve':
      return 'R-T-Approve';
    case 'approved':
      return 'Approved';
    case 'paid':
      return 'Paid';
    case 'rejected':
      return 'Rejected';

    default:
      return status ?? '';
  }
}

String getDriverType(String? status) {
  if (status == null) {
    return '';
  }
  switch (status.toLowerCase()) {
    case 'pickup_delivery':
      return 'PD';
    case 'pickup':
      return 'P';
    case 'delivery':
      return 'D';
    default:
      return '';
  }
}

String getFileNameWithExtenshion(String filePath) {
  var paths = filePath.split("/");
  if (paths.isNotEmpty) {
    return paths.last.replaceAll(" ", "_");
  } else {
    return "Unkown";
  }
}
