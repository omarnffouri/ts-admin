import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/storage_files_manager.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/download_resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/download_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/dialogs/cancel_download_confirmation_dialog.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DownloadResourceBottomSheet extends StatefulWidget {
  final int resourceId;
  final String resourceType;
  final void Function() onSuccess;

  const DownloadResourceBottomSheet({
    super.key,
    required this.resourceId,
    required this.resourceType,
    required this.onSuccess,
  });

  @override
  State<DownloadResourceBottomSheet> createState() =>
      _DownloadResourceBottomSheetState();
}

class _DownloadResourceBottomSheetState
    extends State<DownloadResourceBottomSheet> {
  //
  // usecase
  final downloadResourceUsecase = sl<DownloadResourceUsecase>();

//
// states and variables
  final downloadProgress = (0.0).obs;
  final RxBool gettingResourceLink = false.obs;
  final RxBool resourceLinkReady = false.obs;
  final RxBool downloadingResource = false.obs;
  final RxString resourceLink = "".obs;
  final RxString filePath = "".obs;
  bool canceledByUser = false;
  CancelToken cancelToken = CancelToken();
  final storageFilesManager = Get.find<StorageFilesManager>();

  @override
  void initState() {
    getResourceLink();
    super.initState();
  }

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
        canPop: !downloadingResource.value,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await cancelDownload();
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
                      "Download",
                      style: textTheme.titleLarge,
                    ),
                    // Close icon
                    GestureDetector(
                      onTap: () async {
                        if (!downloadingResource.value) {
                          Get.back();
                        } else {
                          await cancelDownload();
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
                  () => gettingResourceLink.value
                      ? _buildGettingDownloadLinkView(textTheme)
                      : resourceLink.value.isEmpty
                          ? _buildGetDownloadLinkView(textTheme)
                          : downloadingResource.value
                              ? _buildDownloadProgressIndicator()
                              : _buildDownloadLinkReadyView(textTheme),
                ).marginOnly(top: 20),

                // rename resource button
                Obx(
                  () => MainAppButton(
                    label: (!resourceLinkReady.value)
                        ? "Get Resource Link"
                        : downloadingResource.value
                            ? "Cancel"
                            : widget.resourceType == "file"
                                ? "View"
                                : "Download",
                    isLoading: gettingResourceLink.value,
                    onPressed: (!resourceLinkReady.value)
                        ? getResourceLink
                        : downloadingResource.value
                            ? cancelDownload
                            : downloadResource,
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
  /// function to build a getting download link view
  Widget _buildGettingDownloadLinkView(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Getting your link ready...",
            style: textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  //
  //
  /// function to build a get download link view
  Widget _buildGetDownloadLinkView(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Unable to get a resource download link. Please try again.",
            style: textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  //
  //
  /// function to build a upload progress
  Widget _buildDownloadProgressIndicator() {
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
                value: downloadProgress.value,
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
              "${(downloadProgress.value * 100).toStringAsFixed(2)} %",
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
  /// function to build a link ready view
  Widget _buildDownloadLinkReadyView(TextTheme textTheme) {
    //
    //
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        //
        // download icon
        const Icon(
          Icons.cloud_download_rounded,
          color: AppColorsLight.mainColor,
        ).marginOnly(right: 14),

        //
        //
        // text
        Expanded(
          child: Text(
            "Your download link is ready, click ${widget.resourceType == "file" ? "view" : "download"} to proceed further.",
            style: textTheme.labelLarge,
          ),
        )
      ],
    );
  }

  //
  /// Function will hit API and rename resource
  Future<void> getResourceLink() async {
    if (gettingResourceLink.value || resourceLinkReady.value) {
      return;
    }

    gettingResourceLink.value = true;

    try {
      final response = await downloadResourceUsecase.call(widget.resourceId);

      response.fold((BaseResponse<DownloadResourceEntity?> data) {
        if (data.code == 200 && (data.data?.link ?? "").isNotEmpty) {
          resourceLink.value = data.data!.link!;
          resourceLinkReady.value = true;
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Something went wrong while getting resource link.",
          );
        }
      }, (Failure failure) {
        debugPrint(failure.message.toString());
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message,
        );
      });
    } catch (e) {
      debugPrint(e.toString());
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong while getting resource link.",
      );
    }

    gettingResourceLink.value = false;
  }

  Future<void> downloadResource() async {
    if (filePath.value.isNotEmpty) {
      await FileOpener.openFile(filePath.value);
      return;
    }

    canceledByUser = false;
    downloadingResource.value = true;
    downloadProgress.value = 0.0;
    try {
      final filePath = await storageFilesManager.downloadFile(
        resourceLink.value,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          downloadProgress.value = (received / total);
        },
        onFailure: (message) {
          if (!canceledByUser) {
            CommonWidgets.showSnackBar(
              title: "Error",
              message: message,
            );
          }
        },
      );

      if (filePath != null) {
        this.filePath.value = filePath;
        await FileOpener.openFile(filePath);
      }
    } catch (_) {}
    downloadingResource.value = false;
    downloadProgress.value = 0.0;
  }

  //
  //
  /// Function will cancel the on download process
  Future<void> cancelDownload() async {
    await Get.defaultDialog(
      title: 'Cancel Download',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      onWillPop: () async {
        return false;
      },
      titlePadding: EdgeInsets.only(top: 10.h),
      content: CancelDownloadConfirmationDialog(
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
}
