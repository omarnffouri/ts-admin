import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/service_orders/create_edit_service_order/controllers/create_edit_service_order_controller.dart';

import '../../../../../domain/entities/service_details.dart';
import '../../../../../domain/entities/service_order_file.dart';

class FilesBeforServiceView extends GetView<CreateEditServiceOrderController> {
  const FilesBeforServiceView({super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.tileColor.applyOpacity(0.5),
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
            'Files Before Service:',
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
              padding: EdgeInsets.zero,
              itemCount: serviceDetails.filesBeforService.length,
              itemBuilder: (context, index) {
                final file = serviceDetails.filesBeforService.elementAt(index);
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

class _FileItemView extends GetView<CreateEditServiceOrderController> {
  const _FileItemView({required this.orderFile, required this.serviceDetails});
  final ServiceOrderFile orderFile;
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    //
    //
    return Opacity(
      opacity: serviceDetails.isEnabled.value ? 1 : 0.5,
      child: SizedBox(
        width: 100,
        child: Stack(
          children: [
            //
            //
            // file item
            Positioned.fill(
              child: orderFile.isAdd && serviceDetails.isEnabled.value
                  ? InkWell(
                      onTap: () {
                        controller.showBeforServiceAttachmentBottomSheet(
                          theme,
                          serviceDetails.filesBeforService,
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
                    if (serviceDetails.isEnabled.value == false) return;
                    if (orderFile.onlineFile?.id != null) {
                      serviceDetails.filesBeforServiceToBeDeleted
                          .add(orderFile.onlineFile!.id!);
                    }
                    serviceDetails.filesBeforService.remove(orderFile);
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
