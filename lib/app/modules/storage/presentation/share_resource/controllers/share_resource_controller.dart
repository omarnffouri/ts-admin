import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/storage_users_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/get_storage_users_usecase.dart';
import 'package:ts_admin/app/modules/storage/presentation/share_resource/views/components/share_permissions_bottom_sheet.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ShareResourceController extends GetxController {
  late Rx<ResourceEntity> resource;

  final authController = Get.find<AuthController>();

  //
  // usecases
  final getStorageUsersUsecase = sl<GetStorageUsersUsecase>();

  //
  // input controller
  TextEditingController searchController = TextEditingController();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();

  //
  // data variables
  final RxList<EmployeeEntity> selectedUsers = RxList();
  final RxList<EmployeeEntity> users = RxList();
  final RxList<EmployeeEntity> filteredUsers = RxList();

  //search enabled/disabled state
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  // get storage users state
  final RxBool _isLoadingUsersList = false.obs;
  bool get isLoadingUsersList => _isLoadingUsersList.value;

  // already shared with all uers users state
  final RxBool _alreadySharedWithAllUsers = false.obs;
  bool get alreadySharedWithAllUsers => _alreadySharedWithAllUsers.value;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is ResourceEntity) {
      resource = args.obs;
    }

    // attach search change listener
    searchController.addListener(() {
      handleSearch();
    });

    getUsers();

    super.onInit();
  }

  //
  //
  /// get users list from api
  Future<void> getUsers() async {
    if (isLoadingUsersList) {
      return;
    }

    _isLoadingUsersList.value = true;
    _alreadySharedWithAllUsers.value = false;

    try {
      final response = await getStorageUsersUsecase.call(const NoParams());

      response.fold((BaseResponse<StorageUsersEntity?> data) {
        //
        // if have data then clear lists and add data to lists
        if ((data.data?.employees ?? []).isNotEmpty) {
          users.clear();
          filteredUsers.clear();

          final userIds =
              (resource.value.sharedWithUsers?.map((user) => user.userId) ?? [])
                  .where((id) => id != null)
                  .map((id) => id!)
                  .toList();

          for (var user in data.data!.employees!) {
            if (!userIds.contains(user.id)) {
              users.add(user);
            }
          }

          if (users.isNotEmpty) {
            filteredUsers.addAll(users);
          } else {
            _alreadySharedWithAllUsers.value = true;
          }
        }
      }, (Failure failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong, while loading employees.",
      );
    }

    _isLoadingUsersList.value = false;
  }

  onNextClicked() async {
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return SharePermissionsBottomSheet(
          resourceId: resource.value.id!,
          users: selectedUsers,
          onSuccess: () {
            Get.back(result: true);
            Get.back(result: true);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  // clear the search state
  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.clear();
  }

  //
  //
  /// will handle the search text and filter search result into seperate list
  handleSearch() {
    filteredUsers.clear();

    if (searchController.text.isEmpty) {
      filteredUsers.addAll(users);
    } else {
      final search = searchController.text.toLowerCase();
      filteredUsers.addAll(
        users.where(
          (user) {
            return user.name?.toLowerCase().contains(search) ?? false;
          },
        ),
      );
    }
  }

  void toggleSearch() {
    _isSearchEnabled.toggle();
    if (!isSearchEnabled) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      handleSearch();
    }
  }
}
