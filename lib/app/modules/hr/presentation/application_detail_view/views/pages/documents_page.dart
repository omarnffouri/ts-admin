import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/document_request_entity.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/controllers/application_detail_view_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DocumentsPage extends GetView<ApplicationDetailViewController> {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

    return Obx(
      () => SmartRefresher(
        controller: controller.documentsRefreshController,
        header: const WaterDropMaterialHeader(),
        onRefresh: () {
          controller.documentsRefreshController.refreshCompleted();
          controller.handleRefresh();
        },
        child: controller.isLaodingApplicationDetails
            ? _buildLoadingView()
            : controller.documentRequests.isEmpty
                ? const NoDataView()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requested Documents',
                          style: Get.theme.textTheme.titleLarge,
                        ).marginOnly(left: 14, top: 20),
                        Divider(
                          height: 0,
                          color: Get.isDarkMode ? Colors.grey : null,
                        ).marginSymmetric(horizontal: 14),
                        const SizedBox(height: 20),
                        ListView.separated(
                          itemCount: controller.documentRequests.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final document =
                                controller.documentRequests.elementAt(index);
                            return _DocumentItemView(
                              document: document,
                              index: index,
                              fileExtensionHelper: fileExtensionHelper,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requested Documents',
              style: Get.theme.textTheme.titleLarge,
            ).marginOnly(left: 14, top: 20),
            Divider(
              height: 0,
              color: Get.isDarkMode ? Colors.grey : null,
            ).marginSymmetric(horizontal: 14),
            ListView.builder(
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: index == 0 ? 30 : 10,
                    bottom: index == 9 ? 50 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentItemView extends GetView<ApplicationDetailViewController> {
  final DocumentRequestEntity document;
  final int index;
  final FileExtensionHelper fileExtensionHelper;

  const _DocumentItemView({
    required this.document,
    required this.index,
    required this.fileExtensionHelper,
  });

  @override
  Widget build(BuildContext context) {
    //
    //
    // theme
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        controller.openFile(document.file);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 14,
          right: 14,
          bottom: index == (controller.documentRequests.length - 1) ? 50 : 0,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.applyOpacity(0.1),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Column(
          children: [
            //
            //
            // form
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                // form signed or not
                Icon(
                  document.isUploaded == true
                      ? Icons.check_circle_rounded
                      : Icons.info_rounded,
                  color: document.isUploaded == true
                      ? Colors.green
                      : Colors.orange,
                ).marginOnly(right: 5),

                //
                //
                // form name
                Expanded(
                  child: Text(
                    document.collectionName ?? "",
                    style: theme.textTheme.titleMedium,
                  ),
                ),

                //
                //
                // form type
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: document.isUploaded == true
                        ? Colors.green
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    document.hasExpiration == true
                        ? document.expirationDate ?? "N/A"
                        : "Non Expirable",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),

            //
            //
            // uploaded by
            if (document.isUploaded == true)
              Row(
                children: [
                  //
                  //
                  // modified date heading
                  Text(
                    "Uploaded by: ",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),

                  //
                  //
                  //
                  Expanded(
                    child: Text(
                      document.file?.uploadedBy ?? "N/A",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ).marginOnly(top: 5),

            //
            //
            // modified date, file
            Row(
              children: [
                //
                //
                // modified date heading
                Text(
                  "Last modified: ",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),

                //
                //
                //
                Expanded(
                  child: Text(
                    (document.updatedAt ?? "N/A").replaceFirst(" ", " at "),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                //
                //
                // show file icon if have file
                if ((document.file?.url ?? "").isNotEmpty)
                  Obx(
                    () => document.file!.isDownloading.value
                        ? SizedBox(
                            width: 25,
                            height: 25,
                            child: Obx(
                              () => CircularProgressIndicator(
                                value: document.file!.downloadProgress.value,
                                color: AppColorsLight.mainColor,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 5,
                              ),
                            ),
                          )
                        : Image.asset(
                            fileExtensionHelper.getFileIcon(fileExtensionHelper
                                .getFileType(document.file!.fileNameExt ?? "")),
                            width: 25,
                            height: 25,
                          ),
                  ),
              ],
            ).marginOnly(top: 5)
          ],
        ),
      ),
    );
  }
}
