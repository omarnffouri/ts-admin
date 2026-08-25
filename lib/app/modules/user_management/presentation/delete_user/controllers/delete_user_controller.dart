import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/user_entity.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/delete_admin_request_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class DeleteUserController extends GetxController {
  final Rxn<UserEntity> userDetails = Rxn<UserEntity>();

  // usecases
  final deleteUserUsecase = sl<DeleteAdminUsecase>();

  final TextEditingController deleteController = TextEditingController();

  final RxBool isValidPhrase = false.obs;
  final RxBool _isDeletingUser = false.obs;
  bool get isDeletingUser => _isDeletingUser.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      userDetails.value = args as UserEntity;
    }

    deleteController.addListener(() {
      //
      if (deleteController.text ==
          "${userDetails.value?.firstName?.toUpperCase()} DELETE") {
        isValidPhrase.value = true;
      } else {
        isValidPhrase.value = false;
      }
    });
  }

  Future<void> deleteUser() async {
    if (!isValidPhrase.value) {
      return;
    }
    if (userDetails.value?.id?.isEmpty ?? true) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: "Unable to process user details.",
      );
      return;
    }

    // api call
    try {
      _isDeletingUser(true);
      final Either<bool, Failure> result =
          await deleteUserUsecase.call(userDetails.value!.id!);

      result.fold((bool success) {
        if (success) {
          Get.back(result: true);
          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: "User deleted Successfully.",
            isError: false,
          );
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: "Something went wrong. Unable to delete user.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
      _isDeletingUser(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isDeletingUser(false);
    }
  }
}
