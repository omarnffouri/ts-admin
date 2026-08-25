import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/input_utils.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';

class SignupController extends GetxController {
  // inpout field controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // state variab;es
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  signUp() async {
    if (nameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter name to process further.',
      );
      return;
    }

    if (!isValidEmail(emailController.text)) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter a valid email address.',
      );
      return;
    }

    if (phoneController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please phone to process further.',
      );
      return;
    }

    if (phoneController.text.length < 11) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter a valid phone to process further.',
      );
      return;
    }

    _isLoading(true);
    Future.delayed(Duration(seconds: generateRandomNumber(2, 6)), () {
      _isLoading(false);
      emailController.clear();
      nameController.clear();
      phoneController.clear();
      CommonWidgets.showSnackBar(
          title: "Signup",
          message:
              "Thank you for submitting your request. We will review and get back to you within 24 to 48 business hours.",
          isError: false,
          duration: const Duration(seconds: 7));
    });
  }

  int generateRandomNumber(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }
}
