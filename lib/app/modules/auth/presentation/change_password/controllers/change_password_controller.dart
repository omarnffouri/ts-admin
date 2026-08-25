import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/update_password_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/update_password_params.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/update_password_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../../core/network/error/failures.dart';

class ChangePasswordController extends GetxController {
  final authController = Get.find<AuthController>();

  final updatePasswordUsecase = sl<UpdatePasswordUsecase>();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool _isUpdatingPassword = false.obs;
  bool get isUpdatingPassword => _isUpdatingPassword.value;

  final storage = GetStorage();

  ///Textfield
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> currentPasswordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> newPasswordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> confirmPasswordKey =
      GlobalKey<FormFieldState<String>>();
  final FocusNode currentPasswordFocusNode =
      FocusNode(debugLabel: 'currentPassword');
  final FocusNode newPasswordFocusNode = FocusNode(debugLabel: 'newPassword');
  final FocusNode confirmPasswordFocusNode =
      FocusNode(debugLabel: 'confirmPassword');

  List<MapEntry<GlobalKey<FormFieldState<String>>, FocusNode>>
      get orderedFields => [
            MapEntry(currentPasswordKey, currentPasswordFocusNode),
            MapEntry(newPasswordKey, newPasswordFocusNode),
            MapEntry(confirmPasswordKey, confirmPasswordFocusNode),
          ];
  @override
  void onClose() {
    super.onClose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  Future<void> updateProfile() async {
    if (currentPasswordController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Please enter a current password.",
      );
      return;
    }
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

    if (confirmPasswordController.text.length < 8) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Confirm Password length must be greater or equal to 8.",
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

    // api call
    try {
      _isUpdatingPassword(true);
      final Either<UpdatePasswordEntity, Failure> result =
          await updatePasswordUsecase.call(UpdatePasswordParams(
              password: currentPasswordController.text.trim(),
              newPassword: newPasswordController.text.trim()));

      _isUpdatingPassword(false);

      result.fold((UpdatePasswordEntity profile) {
        if (profile.code == 200) {
          CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: "Password updated Successfully.",
              isError: false);
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
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
