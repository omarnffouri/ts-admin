import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/entities/service_order_file.dart';
import '../../controllers/service_order_details_controller.dart';

class FilesAfterServiceView extends GetView<ServiceOrderDetailsController> {
  const FilesAfterServiceView({super.key, required this.serviceDetails});
  final CompleteServiceParams serviceDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white10 : Colors.black12,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Files After Service:',
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(
            () => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                mainAxisExtent: 100,
              ),
              shrinkWrap: true,
              primary: false,
              itemCount: serviceDetails.filesAfterService.length,
              itemBuilder: (context, index) {
                final file = serviceDetails.filesAfterService.elementAt(index);
                return _FileItemView(
                  orderFile: file,
                  serviceDetails: serviceDetails,
                );
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _FileItemView extends GetView<ServiceOrderDetailsController> {
  final ServiceOrderFile orderFile;
  final CompleteServiceParams serviceDetails;
  const _FileItemView({required this.orderFile, required this.serviceDetails});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    //
    //
    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          //
          //
          // file item
          Positioned.fill(
            child: orderFile.isAdd
                ? InkWell(
                    onTap: () {
                      controller.showAfterServiceAttachmentBottomSheet(
                        theme,
                        serviceDetails.filesAfterService,
                      );
                    },
                    child: _buildFileView(theme.textTheme),
                  )
                : _buildFileView(theme.textTheme),
          ),

          //
          //
          // remove file item icon
          if (!orderFile.isAdd)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (orderFile.onlineFile?.id != null) {
                    serviceDetails.filesAfterServiceToBeDeleted
                        .add(orderFile.onlineFile!.id!);
                  }
                  serviceDetails.filesAfterService.remove(orderFile);
                },
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildFileView(TextTheme textTheme) {
    return Container(
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
          orderFile.isAdd
              ? const Icon(
                  Icons.add_rounded,
                  size: 50,
                )
              : Image.asset(
                  controller.fileExtensionHelper.getFileIconFromUrl(
                      orderFile.file != null
                          ? orderFile.file!.path
                          : orderFile.onlineFile?.url ?? ""),
                  width: 50,
                  height: 50,
                ),

          //
          //
          // file name
          Text(
            orderFile.isAdd
                ? "Add File"
                : controller.fileExtensionHelper.getFileName(
                    orderFile.file != null
                        ? orderFile.file!.path
                        : orderFile.onlineFile?.name ?? "file",
                    withExtension: true,
                  ),
            style: textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
