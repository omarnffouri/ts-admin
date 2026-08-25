import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/widgets/dialogs/confirmation_dialog.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/user_entity.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/update_user_status_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class UserDetailViewController extends GetxController {
  final Rxn<UserEntity> userDetails = Rxn<UserEntity>();
  final authController = Get.find<AuthController>();

  final Rx<ProfileTabs> currentTab = ProfileTabs.personal.obs;

  final updateUserStatusUsecase = sl<UpdateUserStatusUsecase>();

  final isUpdatingUserStatus = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null) {
      userDetails.value = args as UserEntity;
    }
  }

  Future<void> suspendUser() async {
    bool confirmed = false;

    //
    //
    // confirmation dialog before suspention
    await Get.defaultDialog(
      title: 'Suspend ${userDetails.value?.firstName ?? "User"}',
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
        message: 'Are you sure?',
        onConfirmation: () async {
          confirmed = true;
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );

    //
    //
    // if confirmed by user then suspend this user
    if (confirmed) {
      isUpdatingUserStatus.value = true;

      //
      //
      // api call for suspending user
      await _updateUserStatus("suspended");

      //
      //
      // resting states
      isUpdatingUserStatus.value = false;
    }
  }

  Future<void> activateUser() async {
    bool confirmed = false;

    //
    //
    // confirmation dialog before suspention
    await Get.defaultDialog(
      title: 'Active ${userDetails.value?.firstName ?? "User"}',
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
        message: 'Are you sure?',
        onConfirmation: () async {
          confirmed = true;
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );

    //
    //
    // if confirmed by user then active this user
    if (confirmed) {
      isUpdatingUserStatus.value = true;

      //
      //
      // api call for suspending user
      await _updateUserStatus("active");

      //
      //
      // resting states
      isUpdatingUserStatus.value = false;
    }
  }

  Future<void> _updateUserStatus(
    String action,
  ) async {
    //
    //
    // api call for suspending user
    try {
      final body = {
        'user_id': userDetails.value?.id,
        'action': action,
      };

      final response = await updateUserStatusUsecase.call(body);

      response.fold((bool successful) {
        if (successful) {
          userDetails.value?.status = action;
        }
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
      Get.snackbar('Error', "Something went wrong while updating user status.");
    }
    userDetails.refresh();
  }
}

enum ProfileTabs { personal, work }
