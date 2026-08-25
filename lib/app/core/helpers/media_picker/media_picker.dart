import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/media_picker_previewer/bindings/media_picker_previewer_params.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class MediaPicker {
  static final instance = MediaPicker();

  static const defaultAllowedExtensions = [
    'DOCX',
    'DOC',
    'HTML',
    'ODT',
    'PDF',
    'XLS',
    'XLSX',
    'PPT',
    'PPTX',
    'ZIP',
    'TXT',
    'PSD',
    'AI',
    'docx',
    'doc',
    'html',
    'odt',
    'pdf',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'zip',
    'txt',
    'psd',
    'ai',
    'csv',
    'CSV',
  ];

  //
  //
  /// function to pick multiple images and videos
  static Future<List<File>> pickMultipleMedia({
    bool enablePreviewer = true,
    bool enableEditing = true,
    bool enableCompression = true,
  }) async {
    //
    // get selected file
    final files = await instance.selectMultipleImagesVideos();

    if (files.isEmpty || (!enablePreviewer)) {
      return files;
    }

    //
    // if preview is enabled the pass to previewer
    try {
      //
      // pass to previewer and getting result
      final result = await Get.toNamed(
        Routes.MEDIA_PICKER_PREVIEWER,
        arguments: MediaPickerPreviewerParams(
          files: files,
          enableEditing: enableEditing,
          enableCompression: enableCompression,
        ),
      );

      if (result is List<File>) {
        return result;
      }
    } catch (_) {}

    return files;
  }

  //
  /// function to select multiple image and videos base files
  Future<List<File>> selectMultipleImagesVideos() async {
    try {
      //
      // if platform ios then use ImagePicker package for media selection
      if (Platform.isIOS) {
        return (await ImagePicker().pickMultipleMedia())
            .map((file) => File(file.path))
            .toList();
      }

      //
      // if platform android then use FilePicker package for media selection
      if (Platform.isAndroid) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.media,
        );

        // if resturn is not null then map PlatformFile File
        if (result != null) {
          return result.files.map((file) => File(file.path!)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  //
  /// function to select multiple image and videos base files
  static Future<File?> selectSingleImage() async {
    try {
      //
      // if platform ios then use ImagePicker package for image selection
      if (Platform.isIOS) {
        final xFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (xFile != null) {
          return File(xFile.path);
        }
      }

      //
      // if platform android then use FilePicker package for image selection
      if (Platform.isAndroid) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
        );

        // if resturn is not null then map PlatformFile File
        if (result != null) {
          if (result.files.isNotEmpty) {
            return File(result.files.first.path!);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  //
  //
  /// function to pick doc like pdf, xls, etc
  static Future<List<File>> pickDocuments(
      {List<String> allowedExtensions = defaultAllowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    }
    return [];
  }

  static Future<PlatformFile?> pickSingleFile(
      {List<String> allowedExtensions = defaultAllowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.single;
    }
    return null;
  }

  //
  //
  /// function to open camera capture image
  static Future<File?> openCameraAndCaptureImage({
    bool enablePreviewer = true,
    bool enableEditing = true,
    bool enableCompression = true,
  }) async {
    if (!(await PermissionHelper.haveCameraPermission(
        "Grant camera permission in settings to share photos in chat."))) {
      return null;
    }
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final file = File(image.path);

      if (!enablePreviewer) {
        return file;
      }

      //
      // if preview is enabled the pass to previewer
      try {
        //
        // pass to previewer and getting result
        final result = await Get.toNamed(
          Routes.MEDIA_PICKER_PREVIEWER,
          arguments: MediaPickerPreviewerParams(
            files: [file],
            enableEditing: enableEditing,
            enableCompression: enableCompression,
          ),
        );

        if (result is List<File>) {
          if (result.isNotEmpty) {
            return result.first;
          } else {
            return null;
          }
        }
      } catch (_) {}
    }
    return null;
  }

  //
  //
  /// function to pick audio files
  static Future<List<File>> pickAudios() async {
    if (Platform.isIOS &&
        (!(await PermissionHelper.haveAppleMusicPermission(
            "Allow media library permission in settings to share any audio/music files.")))) {
      return [];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.audio,
    );

    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    }
    return [];
  }

  //
  //
  /// function to show attahment picker options
  static void showAttachmentBottomSheet({
    void Function(List<File> files)? onDocumentPicked,
    void Function(File? file)? onCameraPicked,
    void Function(List<File>)? onGalleryPicked,
    void Function(File? file)? onImagePicked,
    void Function(List<File>)? onAudiosPicked,
    void Function()? onLocationPicked,
    bool enablePreviewer = true,
    bool enableEditing = true,
    bool enableCompression = true,
    List<String> allowedDocExtensions = defaultAllowedExtensions,
  }) {
    final theme = Get.theme;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.close_rounded,
                color: AppColorsLight.mainColor,
                size: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 50,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: [
                      //
                      //
                      /// image-only gallery button (no videos)
                      if (onImagePicked != null)
                        _PickerButton(
                          onClick: () async {
                            Get.back();
                            try {
                              final image = await selectSingleImage();
                              onImagePicked(image);
                            } catch (_) {}
                          },
                          label: "Gallery",
                          icon: Icons.image_rounded,
                          iconBackgroundColor: Colors.purple,
                        ),

                      //
                      //
                      /// documents button
                      if (onDocumentPicked != null)
                        _PickerButton(
                          onClick: () async {
                            Get.back();
                            try {
                              final docs = await pickDocuments(
                                  allowedExtensions: allowedDocExtensions);
                              onDocumentPicked(docs);
                            } catch (_) {}
                          },
                          label: "Document",
                          icon: Icons.file_present,
                          iconBackgroundColor: Colors.blue,
                        ),

                      //
                      //
                      /// camera button
                      if (onCameraPicked != null)
                        _PickerButton(
                          onClick: () async {
                            Get.back();
                            try {
                              final image = await openCameraAndCaptureImage(
                                enablePreviewer: enablePreviewer,
                                enableCompression: enableCompression,
                                enableEditing: enableEditing,
                              );
                              onCameraPicked(image);
                            } catch (_) {}
                          },
                          label: "Camera",
                          icon: Icons.photo_camera,
                          iconBackgroundColor: AppColorsLight.mainColor,
                        ),

                      //
                      //
                      /// gallery button
                      if (onGalleryPicked != null)
                        _PickerButton(
                          onClick: () async {
                            Get.back();
                            try {
                              final havePermission =
                                  await PermissionHelper.havePhotosPermission(
                                      "Need photos permission in order to send photos in chat.");
                              if (havePermission) {
                                final files = await pickMultipleMedia(
                                  enablePreviewer: enablePreviewer,
                                  enableCompression: enableCompression,
                                  enableEditing: enableEditing,
                                );
                                onGalleryPicked(files);
                              }
                            } catch (_) {}
                          },
                          label: "Gallery",
                          icon: Icons.image_rounded,
                          iconBackgroundColor: Colors.purple,
                        ),

                      //
                      //
                      /// audio button
                      if (onAudiosPicked != null)
                        _PickerButton(
                          onClick: () async {
                            Get.back();
                            try {
                              final audios = await pickAudios();
                              onAudiosPicked(audios);
                            } catch (_) {}
                          },
                          label: "Audio",
                          icon: Icons.audio_file,
                          iconBackgroundColor: Colors.brown,
                        ),

                      if (onLocationPicked != null)
                        _PickerButton(
                          onClick: () async {
                            Get.back();
                            try {
                              onLocationPicked();
                            } catch (_) {}
                          },
                          label: "Location",
                          icon: Icons.location_on_rounded,
                          iconBackgroundColor: Colors.green,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  final void Function() onClick;
  final String label;
  final IconData icon;
  final Color iconBackgroundColor;
  const _PickerButton(
      {required this.onClick,
      required this.label,
      required this.icon,
      required this.iconBackgroundColor});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackgroundColor,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
