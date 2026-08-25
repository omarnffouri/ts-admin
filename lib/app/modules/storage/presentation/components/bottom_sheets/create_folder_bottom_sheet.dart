import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/storage/domain/params/create_folder_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/create_folder_resource_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class CreateFolderBottomSheet extends StatefulWidget {
  final int? parentId;
  final void Function() onSuccess;

  const CreateFolderBottomSheet({
    super.key,
    this.parentId,
    required this.onSuccess,
  });

  @override
  State<CreateFolderBottomSheet> createState() =>
      _CreateFolderBottomSheetState();
}

class _CreateFolderBottomSheetState extends State<CreateFolderBottomSheet> {
  final RxBool creatingFolder = false.obs;
  late TextEditingController folderNameController;
  final createFolderUsecase = sl<CreateFolderResourceUsecase>();

  @override
  void initState() {
    super.initState();
    folderNameController = TextEditingController(); // Initialize the controller
  }

  @override
  void dispose() {
    folderNameController.dispose(); // Dispose the controller
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
                  "Create Folder",
                  style: textTheme.titleLarge,
                ),
                // Close icon
                GestureDetector(
                  onTap: () {
                    if (!creatingFolder.value) {
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
            RoundedInputField(
              label: "Folder Name",
              hintText: "Enter folder name",
              controller: folderNameController,
            ).marginOnly(top: 20),

            // Create folder button
            Obx(
              () => MainAppButton(
                label: "Create",
                isLoading: creatingFolder.value,
                onPressed: createFolder,
              ),
            ).marginSymmetric(vertical: 20),
          ],
        ),
      ),
    );
  }

  //
  /// Function will hit API and create folder
  Future<void> createFolder() async {
    if (folderNameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please enter a valid folder name.",
      );
      return;
    }

    if (creatingFolder.value) {
      return;
    }

    creatingFolder.value = true;

    try {
      final response = await createFolderUsecase.call(
        CreateFolderParams(
          resourceName: folderNameController.text,
          parentId: widget.parentId,
        ),
      );

      response.fold((bool success) {
        if (success) {
          widget.onSuccess();
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Something went wrong while creating folder.",
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
        message: "Something went wrong while creating folder.",
      );
    }

    creatingFolder.value = false;
  }
}
