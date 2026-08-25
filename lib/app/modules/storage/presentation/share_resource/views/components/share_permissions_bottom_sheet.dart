import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/storage_users_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/params/share_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/share_resource_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class SharePermissionsBottomSheet extends StatefulWidget {
  final int resourceId;
  final List<EmployeeEntity> users;
  final void Function() onSuccess;

  const SharePermissionsBottomSheet({
    super.key,
    required this.resourceId,
    required this.users,
    required this.onSuccess,
  });

  @override
  State<SharePermissionsBottomSheet> createState() =>
      _SharePermissionsBottomSheetState();
}

class _SharePermissionsBottomSheetState
    extends State<SharePermissionsBottomSheet> {
  //
  // usecases
  final shareResourceUsecase = sl<ShareResourceUsecase>();

  // sharing resource state
  final RxBool _isSharingResource = false.obs;
  bool get isSharingResource => _isSharingResource.value;

  // slected permission
  final Rx<ResourceSharePermissions> selectedPermission =
      ResourceSharePermissions.all.obs;

  @override
  Widget build(BuildContext context) {
    //
    // theme data
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    //
    //
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            //
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                //
                // Heading
                Text(
                  "Select Permission",
                  style: textTheme.titleLarge,
                ),
                //
                //
                // Close icon
                GestureDetector(
                  onTap: () {
                    if (!isSharingResource) {
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

            //
            //
            // Body
            Text(
              "Sharing resource with ${widget.users.length} ${widget.users.length == 1 ? "person" : "people"}.",
              style: textTheme.labelLarge,
            ).marginOnly(top: 10),

            //
            //
            // permission builder
            ListView.builder(
              shrinkWrap: true,
              itemCount: ResourceSharePermissions.values.length,
              itemBuilder: (context, index) {
                final permission =
                    ResourceSharePermissions.values.elementAt(index);

                //
                //
                // item view
                return Obx(
                  () => InkWell(
                    onTap: () {
                      selectedPermission.value = permission;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selectedPermission.value == permission
                            ? AppColorsLight.mainColor
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedPermission.value == permission
                              ? AppColorsLight.mainColor
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        permission.getDisplayName(),
                        style: textTheme.labelLarge?.copyWith(
                          color: selectedPermission.value == permission
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).marginOnly(top: 10),

            //
            //
            // share button
            Obx(
              () => MainAppButton(
                label: "Share",
                isLoading: isSharingResource,
                onPressed: _shareResource,
              ),
            ).marginSymmetric(vertical: 20),
          ],
        ),
      ),
    );
  }

  _shareResource() async {
    if (isSharingResource) {
      return;
    }

    _isSharingResource.value = true;

    try {
      final response = await shareResourceUsecase.call(
        ShareResourceParams(
          users: widget.users.map((user) => user.id!).toList(),
          resourceId: widget.resourceId,
          permission: selectedPermission.value.getApiName(),
        ),
      );

      response.fold(
        (bool data) {
          //
          //
          if (data) {
            widget.onSuccess();
          } else {
            CommonWidgets.showSnackBar(
              title: "Error",
              message: "Something went wrong, while sharing resource.",
            );
          }
        },
        (Failure failure) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: failure.message,
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong, while sharing resource.",
      );
    }

    _isSharingResource.value = false;
  }
}

enum ResourceSharePermissions {
  all,
  r,
  rw,
  rwd,
}

extension on ResourceSharePermissions {
  String getApiName() {
    switch (this) {
      case ResourceSharePermissions.all:
        return 'all';
      case ResourceSharePermissions.r:
        return 'r';
      case ResourceSharePermissions.rw:
        return 'rw';
      case ResourceSharePermissions.rwd:
        return 'rwd';
    }
  }

  String getDisplayName() {
    switch (this) {
      case ResourceSharePermissions.all:
        return 'All (read, write, delete, share)';
      case ResourceSharePermissions.r:
        return 'Read';
      case ResourceSharePermissions.rw:
        return 'Read, Write';
      case ResourceSharePermissions.rwd:
        return 'Read, Write, Delete';
    }
  }
}
