import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/storage/domain/params/rename_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/rename_resource_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class RenameResourceBottomSheet extends StatefulWidget {
  final int resourceId;
  final int? parentId;
  final String resourceName;
  final String resourceType;
  final void Function(String newName) onSuccess;

  const RenameResourceBottomSheet({
    super.key,
    required this.resourceId,
    this.parentId,
    required this.resourceName,
    required this.resourceType,
    required this.onSuccess,
  });

  @override
  State<RenameResourceBottomSheet> createState() =>
      _RenameResourceBottomSheetState();
}

class _RenameResourceBottomSheetState extends State<RenameResourceBottomSheet> {
  final RxBool renamingResource = false.obs;
  late TextEditingController newNameController;
  final renameResourceUsecase = sl<RenameResourceUsecase>();

  @override
  void initState() {
    super.initState();
    newNameController = TextEditingController(
      text: widget.resourceName,
    ); // Initialize the controller
  }

  @override
  void dispose() {
    newNameController.dispose(); // Dispose the controller
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
              children: [
                // Heading
                Expanded(
                  child: Text(
                    "Rename ${widget.resourceName}",
                    style: textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Close icon
                GestureDetector(
                  onTap: () {
                    if (!renamingResource.value) {
                      Get.back();
                    }
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: Get.isDarkMode ? Colors.white : theme.primaryColor,
                  ),
                ).marginOnly(left: 15),
              ],
            ),

            // Body
            RoundedInputField(
              label: "Resource Name",
              hintText: "Enter resource name",
              controller: newNameController,
            ).marginOnly(top: 20),

            // rename resource button
            Obx(
              () => MainAppButton(
                label: "Rename",
                isLoading: renamingResource.value,
                onPressed: renameResource,
              ),
            ).marginSymmetric(vertical: 20),
          ],
        ),
      ),
    );
  }

  //
  /// Function will hit API and rename resource
  Future<void> renameResource() async {
    if (newNameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please enter a valid resource name.",
      );
      return;
    }

    if (renamingResource.value) {
      return;
    }

    renamingResource.value = true;

    try {
      final response = await renameResourceUsecase.call(
        RenameResourceParams(
          id: widget.resourceId,
          parentId: widget.parentId,
          resourceName: newNameController.text,
          resourceType: widget.resourceType,
        ),
      );

      response.fold((bool success) {
        if (success) {
          widget.onSuccess(newNameController.text);
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Something went wrong while renaming resource.",
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
        message: "Something went wrong while renaming resource.",
      );
    }

    renamingResource.value = false;
  }
}
