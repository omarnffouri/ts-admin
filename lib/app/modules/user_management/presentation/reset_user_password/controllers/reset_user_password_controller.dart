import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/user_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/usecases/update_admin_password_request_usecase.dart';

class ResetUserPasswordController extends GetxController {
  // usecases
  final updatePasswordUsecase = sl<UpdateAdminPasswordUsecase>();

  // variables
  final Rxn<UserEntity> userDetails = Rxn<UserEntity>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool _isUpdatingPassword = false.obs;
  bool get isUpdatingPassword => _isUpdatingPassword.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      userDetails.value = args as UserEntity;
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Please enter a new password.",
      );
      return;
    }
    if (newPasswordController.text.length < 8) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "New Password length must be greater or equal to 8.",
      );
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Please enter a confirm password.",
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Confirm Password not matched.",
      );
      return;
    }

    final body = {
      "user_id": userDetails.value!.id,
      "password": newPasswordController.text.trim(),
      "confirm_password": confirmPasswordController.text.trim()
    };

    // api call
    try {
      _isUpdatingPassword(true);
      final Either<bool, Failure> result =
          await updatePasswordUsecase.call(body);

      result.fold((bool success) {
        if (success) {
          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: "Password updated Successfully.",
            isError: false,
          );
          newPasswordController.clear();
          confirmPasswordController.clear();
          Navigator.pop(Get.context!);
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: "Something went wrong. Unable to update password.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
      _isUpdatingPassword(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isUpdatingPassword(false);
    }
  }
}
