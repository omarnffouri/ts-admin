import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/storage_files_manager.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/dialogs/confirmation_dialog.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/params/get_resources_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/revoke_resource_permission_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/get_resources_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/revoke_all_resource_permission_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/revoke_resource_permission_usecase.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/delete_resource_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/download_resource_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/rename_resource_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/resource_details/controllers/resource_details_result.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ResourceDetailsController extends GetxController {
  late Rx<ResourceEntity> resource;

  final authController = Get.find<AuthController>();

  final storageFilesManager = Get.find<StorageFilesManager>();

  //
  //
  // usecase
  final getResourcesUsecase = sl<GetResourcesUsecase>();
  final revokeResourcePermissionUsecase = sl<RevokeResourcePermissionUsecase>();
  final revokeAllResourcePermissionUsecase =
      sl<RevokeAllResourcePermissionUsecase>();

  //
  //
  // states
  final RxBool _isRefreshingResource = false.obs;
  bool get isRefreshingResource => _isRefreshingResource.value;

  final RxBool _isRevokingPermission = false.obs;
  bool get isRevokingPermission => _isRevokingPermission.value;
  final RxBool isRevokingAllPermission = false.obs;

  final RxInt revokingAtIndex = (-1).obs;

  bool needRefresh = false;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is ResourceEntity) {
      resource = args.obs;
    }
    super.onInit();
  }

  //
  //
  /// get root resources from api
  Future<void> refreshResource() async {
    if (isRefreshingResource) {
      return;
    }

    _isRefreshingResource.value = true;

    try {
      final response = await getResourcesUsecase.call(
        GetResourcesParams(
          parentId: resource.value.parentId,
        ),
      );

      response.fold((BaseResponse<List<ResourceEntity>?> data) {
        if (data.data != null) {
          final newResource = data.data!.firstWhereOrNull(
              (item) => (item.id != null) && (item.id == resource.value.id));
          if (newResource != null) {
            resource.value = newResource;
            resource.refresh();
          }
        }
      }, (Failure _) {});

      needRefresh = true;
    } catch (e) {
      debugPrint(e.toString());
    }

    _isRefreshingResource.value = false;
  }

  //
  //
  /// revoke user permission api call
  Future<bool> _revokeResourcePermission(
      RevokeResourcePermissionParams params) async {
    if (isRevokingPermission) {
      return false;
    }

    _isRevokingPermission.value = true;

    bool revoked = false;

    try {
      final response = await revokeResourcePermissionUsecase.call(params);

      response.fold((bool success) {
        revoked = success;
      }, (Failure failure) {
        CommonWidgets.showSnackBar(title: "Error", message: failure.message);
      });
    } catch (_) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong, while revoking permissions.",
      );
    }

    _isRevokingPermission.value = false;
    return revoked;
  }

  //
  //
  /// function to handle resource share click
  onShareResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }

    try {
      final result =
          await Get.toNamed(Routes.SHARE_RESOURCE, arguments: resource);

      if (result == true) {
        refreshResource();
      }
    } catch (_) {}
  }

  //
  //
  /// function to handle resource download click
  onDownloadResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return DownloadResourceBottomSheet(
          resourceId: resource.id!,
          resourceType: resource.resourceType ?? "folder",
          onSuccess: () {
            Get.back();
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function to handle resource delete click
  onDeleteResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return DeleteResourceBottomSheet(
          resourceName: resource.resourceName ?? "",
          resourceId: resource.id!,
          onSuccess: () {
            needRefresh = true;
            Get.back(result: getResults());
            Get.back(result: getResults());
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function to handle resource rename click
  onRenameResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return RenameResourceBottomSheet(
          resourceId: resource.id!,
          parentId: resource.parentId,
          resourceName: resource.resourceName ?? "",
          resourceType: resource.resourceType ?? "folder",
          onSuccess: (newName) {
            needRefresh = true;
            this.resource.value.resourceName = newName;
            Get.back();
            refreshResource();
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function that will handle the revoke permission click
  Future<void> onRevokeResourcePermissionClicked(
      SharedWithUserEntity user, int index) async {
    try {
      // Return if already calling API or user data is invalid
      if (isRevokingPermission || user.id == null || user.userId == null) {
        return;
      }

      if (!(await _confirmPermissionRevoke())) {
        return;
      }

      revokingAtIndex.value = index;

      // calling api for revoke permission
      final revoked = await _revokeResourcePermission(
        RevokeResourcePermissionParams(id: user.id!, userId: user.userId!),
      );

      revokingAtIndex.value = -1;

      // if revoked successfully the set needRefresh falg true
      // and reemove the user from shared with users list
      if (revoked) {
        needRefresh = true;
        resource.value.sharedWithUsers?.remove(user);
        resource.refresh();
      }
    } catch (_) {}
  }

  Future<void> onRevokeAllResourcePermissionsClicked() async {
    final sharedWithUsers = resource.value.sharedWithUsers;
    if (sharedWithUsers == null || sharedWithUsers.isEmpty) {
      return;
    }

    // if already calling api then return
    if (isRevokingAllPermission.value) {
      return;
    }

    if (!(await _confirmPermissionRevoke())) {
      return;
    }

    try {
      debugPrint("Revoke all permissions");
      debugPrint("users length: ${sharedWithUsers.length}");

      isRevokingAllPermission.value = true;
      final id = resource.value.id.toString();
      final response = await revokeAllResourcePermissionUsecase.call(id);

      response.fold((bool success) {
        if (success) {
          needRefresh = true;
          resource.value.sharedWithUsers = [];
          resource.refresh();
        }
      }, (Failure failure) {
        CommonWidgets.showSnackBar(title: "Error", message: failure.message);
      });
    } catch (_) {
    } finally {
      isRevokingAllPermission.value = false;
      debugPrint("revoke users completed");
    }
  }

  //
  //
  /// function for confirmation permission revoke
  Future<bool> _confirmPermissionRevoke() async {
    bool confirm = false;
    await Get.defaultDialog(
      title: 'Revoke Permission',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      onWillPop: () async {
        return false;
      },
      titlePadding: EdgeInsets.only(top: 10.h),
      content: ConfirmationDialog(
        onConfirmation: () async {
          confirm = true;
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );
    return confirm;
  }

  ResourceDetailsResult getResults() {
    return ResourceDetailsResult(
      needRefresh: needRefresh,
      resource: resource.value,
    );
  }
}
