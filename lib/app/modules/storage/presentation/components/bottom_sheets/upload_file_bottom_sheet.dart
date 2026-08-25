import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/storage/domain/params/upload_file_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/upload_file_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/dialogs/cancel_upload_confirmation_dialog.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class UploadFileBottomSheet extends StatefulWidget {
  final int? parentId;
  final void Function() onSuccess;

  const UploadFileBottomSheet({
    super.key,
    this.parentId,
    required this.onSuccess,
  });

  @override
  State<UploadFileBottomSheet> createState() => _UploadFileBottomSheetState();
}

class _UploadFileBottomSheetState extends State<UploadFileBottomSheet> {
  //
  // usecase
  final uploadFileUsecase = sl<UploadFileResourceUsecase>();

//
// states and variables
  final uploadProgress = (0.0).obs;
  final RxBool uploadingResource = false.obs;
  bool canceledByUser = false;
  CancelToken cancelToken = CancelToken();
  final RxList<_FileResource> files = RxList(
    [
      _FileResource(isAdd: true, file: File("")),
    ],
  );
  final fileExtensionHelper = FileExtensionHelper();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Obx(
      () => PopScope(
        canPop: !uploadingResource.value,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await cancelUpload();
          }
        },
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Heading
                    Text(
                      "Upload Resources",
                      style: textTheme.titleLarge,
                    ),
                    // Close icon
                    GestureDetector(
                      onTap: () async {
                        if (!uploadingResource.value) {
                          Get.back();
                        } else {
                          await cancelUpload();
                        }
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color:
                            Get.isDarkMode ? Colors.white : theme.primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                // Body
                Obx(
                  () => uploadingResource.value
                      ? _buildUploadProgressIndicator()
                      : _buildFilesGridList(textTheme),
                ).marginOnly(top: 20),

                // upload/cancel resource button
                Obx(
                  () => MainAppButton(
                    label: uploadingResource.value ? "Cancel" : "Upload",
                    onPressed: uploadingResource.value
                        ? cancelUpload
                        : uploadResources,
                  ),
                ).marginSymmetric(vertical: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  //
  /// function to build the selected items list view
  Widget _buildFilesGridList(TextTheme textTheme) {
    return Container(
      constraints: BoxConstraints(maxHeight: Get.height * 0.5),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 100,
        ),
        shrinkWrap: true,
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files.elementAt(index);

          return file.isAdd
              ? _buildAddItem(file, textTheme)
              : _buildFileItem(file, textTheme);
        },
      ),
    );
  }

  //
  //
  /// function to build a upload progress
  Widget _buildUploadProgressIndicator() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          //
          // upload progress
          Positioned.fill(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? Colors.white : AppColorsLight.mainColor,
                backgroundColor:
                    (Get.isDarkMode ? Colors.white : AppColorsLight.mainColor)
                        .applyOpacity(0.1),
                value: uploadProgress.value,
                strokeCap: StrokeCap.round,
                strokeWidth: 10,
              ),
            ),
          ),

          //
          //
          // percentage indicator
          Center(
            child: Text(
              "${(uploadProgress.value * 100).toStringAsFixed(2)} %",
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : AppColorsLight.mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  //
  //
  /// add icon builder
  Widget _buildAddItem(_FileResource file, TextTheme textTheme) {
    final fileType = fileExtensionHelper.getFileType(file.file.path);
    return InkWell(
      onTap: () {
        if (!uploadingResource.value) {
          _pickFiles();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            //
            // file icon or add icon
            file.isAdd
                ? const Icon(
                    Icons.add_rounded,
                    size: 50,
                  )
                : Image.asset(
                    fileExtensionHelper.getFileIcon(fileType),
                    width: 50,
                    height: 50,
                  ),

            //
            //
            // file name
            Text(
              "Add File",
              style: textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  //
  //
  /// file item builder
  Widget _buildFileItem(_FileResource file, TextTheme textTheme) {
    final fileName = fileExtensionHelper.getFileName(
      file.file.path,
      withExtension: true,
    );
    final fileType = fileExtensionHelper.getFileType(file.file.path);

    //
    //
    return Stack(
      children: [
        //
        //
        // file item
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                //
                // file icon
                Image.asset(
                  fileExtensionHelper.getFileIcon(fileType),
                  width: 50,
                  height: 50,
                ),

                //
                //
                // file name
                Text(
                  fileName,
                  style: textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        //
        //
        // remove file item icon
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              if (!uploadingResource.value) {
                files.remove(file);
              }
            },
            child: const Icon(
              Icons.remove_circle,
              color: Colors.red,
              size: 20,
            ),
          ),
        )
      ],
    );
  }

  //
  /// Function will hit API and upload resource
  Future<void> uploadResources() async {
    if (uploadingResource.value) {
      return;
    }

    final filtertedFiles =
        files.where((item) => !item.isAdd).map((item) => item.file).toList();

    if (filtertedFiles.isEmpty) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please select at least one file.",
      );
      return;
    }

    uploadingResource.value = true;
    canceledByUser = false;

    try {
      final response = await uploadFileUsecase.call(
        UploadFileResourceParams(
          parentId: widget.parentId,
          resourceName: fileExtensionHelper
              .getFileName(filtertedFiles.first.path, withExtension: true),
          cancelToken: cancelToken,
          files: filtertedFiles,
          onSendProgress: (count, total) {
            uploadProgress.value = count / total;
          },
        ),
      );

      response.fold((bool success) {
        if (success) {
          widget.onSuccess();
        } else {
          if (!canceledByUser) {
            CommonWidgets.showSnackBar(
              title: "Error",
              message: "Something went wrong while uploading resources.",
            );
          }
        }
      }, (Failure failure) {
        debugPrint(failure.message.toString());
        if (!canceledByUser) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: failure.message,
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      if (!canceledByUser) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: "Something went wrong while uploading resources.",
        );
      }
    }

    uploadingResource.value = false;
    uploadProgress.value = 0.0;
  }

  //
  //
  /// Function will cancel the on going uploads
  cancelUpload() async {
    await Get.defaultDialog(
      title: 'Cancel Upload',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      onWillPop: () async {
        return false;
      },
      titlePadding: EdgeInsets.only(top: 10.h),
      content: CancelUploadConfirmationDialog(
        onConfirmationCalled: () async {
          canceledByUser = true;
          cancelToken.cancel();
          cancelToken = CancelToken();
          Get.back();
        },
        onCancelCalled: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );
  }

  //
  //
  /// function to show cancel confirmation

  _pickFiles() async {
    MediaPicker.showAttachmentBottomSheet(
      enableCompression: false,
      enableEditing: false,
      enablePreviewer: false,
      allowedDocExtensions: [
        'jpeg',
        'jpg',
        'gif',
        'png',
        'webp',
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'mp4',
        'mp3',
      ],
      onGalleryPicked: (files) {
        if (files.isNotEmpty) {
          try {
            if (this.files.isNotEmpty) {
              this.files.removeLast();
            }
            this.files.addAll(
                files.map((file) => _FileResource(isAdd: false, file: file)));
          } catch (_) {}
          this.files.add(_FileResource(isAdd: true, file: File("")));
        }
      },
      onDocumentPicked: (files) {
        if (files.isNotEmpty) {
          try {
            if (this.files.isNotEmpty) {
              this.files.removeLast();
            }
            this.files.addAll(
                files.map((file) => _FileResource(isAdd: false, file: file)));
          } catch (_) {}
          this.files.add(_FileResource(isAdd: true, file: File("")));
        }
      },
      onCameraPicked: (file) {
        if (file != null) {
          try {
            if (files.isNotEmpty) {
              files.removeLast();
            }
            files.add(_FileResource(isAdd: false, file: file));
          } catch (_) {}
          files.add(_FileResource(isAdd: true, file: File("")));
        }
      },
      onAudiosPicked: (files) {
        if (files.isNotEmpty) {
          try {
            if (this.files.isNotEmpty) {
              this.files.removeLast();
            }
            this.files.addAll(
                files.map((file) => _FileResource(isAdd: false, file: file)));
          } catch (_) {}
          this.files.add(_FileResource(isAdd: true, file: File("")));
        }
      },
    );
  }
}

class _FileResource {
  final bool isAdd;
  final File file;

  _FileResource({required this.isAdd, required this.file});
}
