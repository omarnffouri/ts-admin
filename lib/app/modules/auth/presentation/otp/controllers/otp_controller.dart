import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/biometric_helper.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/verify_otp_params.dart';
import 'package:ts_admin/app/modules/auth/domain/params/firebase_sign_in_params.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/firebase/sign_in_with_email_password_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/login_use_case.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:ts_admin/app/modules/auth/presentation/login/views/bottom_sheets/biometric_suggestion_bs.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class OtpController extends GetxController {
  final authController = Get.find<AuthController>();

  late VerifyOtpParams params;

  //
  //
  // usecases
  final verifyOtpUseCase = sl<VerifyOtpUsecase>();
  final loginUseCase = sl<LoginUseCase>();
  final signInToFirebaseUseCase = sl<SignInToFirebaseUseCase>();

  // secure storage for storing email and pass etc
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // generi cstorage for storing details
  final storage = GetStorage();
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
    try {
      params = Get.arguments as VerifyOtpParams;
    } catch (_) {
      Get.back();
    }
    startTimer();
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
    debugPrint("start verify otp");
    params.otp = pinController.text;

    try {
      isVerifing.value = true;
      final Either<BaseResponse<LoginPayloadEntity>, Failure> result =
          await verifyOtpUseCase.call(params);
      result.fold((BaseResponse<LoginPayloadEntity> data) async {
        handleLoginResponse(data);
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
      debugPrint("start send otp");
      final Either<BaseResponse<LoginPayloadEntity>, Failure> result =
          await loginUseCase.call(params.toJson());

      result.fold((BaseResponse<LoginPayloadEntity> data) async {
        handleLoginResponse(data);
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
    startTimer();
  }

  Future<void> handleLoginResponse(
      BaseResponse<LoginPayloadEntity> data) async {
    if (data.data?.user != null && data.data?.accessToken != null) {
      authController.user.value = data.data!.user!;
      authController.isAuthenticated = true;

      await Future.wait([
        storage.write(AuthenticationPrefKeys.isLoggedIn, true),
        storage.write(AuthenticationPrefKeys.token, data.data!.accessToken),
        storage.write(
            UserPrefKeys.userDetails, authController.user.value?.toEntity()),
        storage.write(UserPrefKeys.userId, authController.user.value?.id),
        saveUserData(),
      ]);

      // Only after the token is in storage. Fired before it, this request goes
      // out unauthenticated, and the 401 handler logs the user straight back
      // out — wiping user.value on the way to the main screen.
      await authController.userPermissionHelper.reloadUserPermissions();

      await authController.storeRealtimeConfiguration();

      if (!params.fromBiometric) {
        await _saveLoginForBiometric();
        await _showBiometricSuggestion();
      }

      await Future.wait([
        SharedPrefrencesHelper.storeMyDetails(
            authController.user.value!, data.data!.accessToken!),
        initPusherManager(),
      ]);

      // Firebase sign-in runs in background so it never blocks login
      unawaited(_signInToFirebase(
        email: data.data!.user!.email ?? '',
        phone: data.data!.user!.phone ?? '',
      ));

      Get.offAllNamed(Routes.MAIN_SCREEN);
    } else if (!(data.data?.otpSent ?? false)) {
      // Not a resend ack and no user+token: code rejected.
      pinController.clear();
      pinText.value = '';
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: data.message ?? 'That code was not accepted. Try again.',
        isError: true,
      );
    }
  }

  Future<void> _signInToFirebase({
    required String email,
    required String phone,
  }) async {
    try {
      await signInToFirebaseUseCase(FirebaseSignInParams(
        email: email,
        phone: phone,
      ));
    } catch (e) {
      debugPrint('Firebase Auth failed: $e');
    }
  }

  Future<void> saveUserData() async {
    if (params.rememberMe) {
      await secureStorage.write(
          key: AuthenticationPrefKeys.email, value: params.email);
      await secureStorage.write(
          key: AuthenticationPrefKeys.password, value: params.password);
      storage.write(AuthenticationPrefKeys.remmemberMe, params.rememberMe);
    } else {
      // If "Remember Me" checkbox is unchecked, clear saved login data from storag
      await secureStorage.delete(key: AuthenticationPrefKeys.email);
      await secureStorage.delete(key: AuthenticationPrefKeys.password);
      storage.remove(AuthenticationPrefKeys.remmemberMe);
    }
  }

  _showBiometricSuggestion() async {
    try {
      if (!(await BiometricHelper.isBiometricAvailable())) {
        return;
      }
    } catch (_) {
      return;
    }

    //
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Get.isDarkMode
          ? AppColorsDark.scaffoldBackroundColor
          : AppColorsLight.white,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const BiometricSugesstionBottomSheet();
      },
    );
  }

  disableBiometric() {
    storage.write(AuthenticationPrefKeys.biometricEnabled, false);
    Get.back();
  }

  _saveLoginForBiometric() async {
    try {
      // saving email
      await secureStorage.write(
        key: AuthenticationPrefKeys.biometricEmail,
        value: params.email,
      );

      // saving password
      await secureStorage.write(
        key: AuthenticationPrefKeys.biometricPassword,
        value: params.password,
      );

      await storage.write(AuthenticationPrefKeys.biometricEnabled, false);
    } catch (_) {}
  }

  enableBiometric() async {
    try {
      if (await BiometricHelper.isBiometricAvailable()) {
        if (!(await BiometricHelper.authenticate())) {
          return;
        }
      } else {
        return;
      }

      // saving email
      await secureStorage.write(
        key: AuthenticationPrefKeys.biometricEmail,
        value: params.email,
      );

      // saving password
      await secureStorage.write(
        key: AuthenticationPrefKeys.biometricPassword,
        value: params.password,
      );

      // saving state
      storage.write(AuthenticationPrefKeys.biometricEnabled, true);
    } catch (_) {}

    Get.back();
  }
}
