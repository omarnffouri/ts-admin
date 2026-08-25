import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/send_drive_otp_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/verify_drive_otp_usecase.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class VerifyDriveOtpController extends GetxController {
  final authController = Get.find<AuthController>();

  //
  //
  // usecases
  final sendOtpUsecase = sl<SendDriveOtpUsecase>();
  final verifyOtpUseCase = sl<VerifyDriveOtpUsecase>();

  //
  //
  //variables
  final pinController = TextEditingController();
  final pinPutFocusNode = FocusNode();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final isVerifing = false.obs;

  final pinText = ''.obs;

  final _start = 60.obs;
  int get start => _start.value;
  set start(int value) => _start.value = value;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    sendOtp();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
        } else {
          _start.value--;
        }
      },
    );
  }

  Future<void> verifyOtp() async {
    final otp = int.parse(pinController.text);
    try {
      isVerifing.value = true;
      final Either<bool, Failure> result = await verifyOtpUseCase.call(otp);
      result.fold((bool data) async {
        if (data) {
          authController.stoargeOtpVerified.value = true;
          Get.offNamed(Routes.STORAGE_DRIVE);
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error', message: "Unable to verify otp.");
        }
      }, (Failure e) {
        CommonWidgets.showSnackBar(title: 'Error', message: e.message);
      });

      isVerifing.value = false;
    } catch (e) {
      isVerifing.value = false;
      CommonWidgets.showSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> sendOtp() async {
    try {
      start = 60;
      final Either<bool, Failure> result =
          await sendOtpUsecase.call(const NoParams());

      result.fold((bool data) async {
        if (data) {
          startTimer();
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error', message: "Unable to send otp email.");
        }
      }, (Failure e) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    }
  }
}
