import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';
import 'package:ts_admin/app/modules/storage/domain/params/delete_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/delete_resource_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class DeleteResourceBottomSheet extends StatefulWidget {
  final String resourceName;
  final int resourceId;
  final void Function() onSuccess;

  const DeleteResourceBottomSheet({
    super.key,
    required this.resourceName,
    required this.resourceId,
    required this.onSuccess,
  });

  @override
  State<DeleteResourceBottomSheet> createState() =>
      _DeleteResourceBottomSheetState();
}

class _DeleteResourceBottomSheetState extends State<DeleteResourceBottomSheet> {
  final RxBool deletingFolder = false.obs;
  final deleteResourceUsecase = sl<DeleteResourceUsecase>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Container(
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
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  "Delete Resource",
                  style: textTheme.titleLarge,
                ),
                // Close icon
                GestureDetector(
                  onTap: () {
                    if (!deletingFolder.value) {
                      Get.back();
                    }
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: Get.isDarkMode ? Colors.white : theme.primaryColor,
                  ),
                ),
              ],
            ),

            // Body
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Are you sure you want to delete the ${widget.resourceName}?\nThis action cannot be undone.",
                    style: textTheme.labelLarge,
                  ),
                ),
              ],
            ).marginOnly(top: 20),

            // delete resource button and loading view
            Obx(
              () => deletingFolder.value
                  ? CircularProgressIndicator(
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColorsLight.mainColor,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 5,
                    )
                  : Row(
                      children: [
                        //
                        //
                        // delete button
                        Expanded(
                          child: RoundedBorderButton(
                            label: "Delete",
                            onPressed: deleteFolder,
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        //
                        //
                        // cancel button
                        Expanded(
                          child: RoundedFillButton(
                            label: "Cancel",
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        )
                      ],
                    ),
            ).marginSymmetric(vertical: 20),
          ],
        ),
      ),
    );
  }

  //
  /// Function will hit API and delete resource
  Future<void> deleteFolder() async {
    if (deletingFolder.value) {
      return;
    }

    deletingFolder.value = true;

    try {
      final response = await deleteResourceUsecase.call(
        DeleteResourcesParams(
          ids: [widget.resourceId],
        ),
      );

      response.fold((bool success) {
        if (success) {
          widget.onSuccess();
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Something went wrong while deleting resource.",
          );
        }
      }, (Failure failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message,
        );
      });
    } catch (e) {
      debugPrint(e.toString());
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong while deleting resource.",
      );
    }

    deletingFolder.value = false;
  }
}
