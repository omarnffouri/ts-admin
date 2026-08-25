import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/biometric_helper.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/verify_otp_params.dart';
import 'package:ts_admin/app/modules/auth/presentation/login/views/bottom_sheets/biometric_suggestion_bs.dart';
import '../../../../../services/injection_service.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../routes/app_pages.dart';
import 'package:ts_admin/app/modules/auth/domain/params/firebase_sign_in_params.dart';
import '../../../domain/usecases/firebase/sign_in_with_email_password_usecase.dart';
import '../../../domain/usecases/login_use_case.dart';

class LoginController extends GetxController {
  final loginUseCase = sl<LoginUseCase>();
  final signInToFirebaseUseCase = sl<SignInToFirebaseUseCase>();

  final authController = Get.find<AuthController>();

  // secure storage for storing email and pass etc
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // input field controllers.
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // generi cstorage for storing details
  final storage = GetStorage();

  // state variab;es
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  RxBool rememberMe = false.obs;

  // biometric state
  RxBool isBiometricAvaibale = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved login data from storage (if any)
    initStorage();
  }

  Future<void> initStorage() async {
    final savedEmail =
        await secureStorage.read(key: AuthenticationPrefKeys.email);
    final savedPassword =
        await secureStorage.read(key: AuthenticationPrefKeys.password);
    final savedRememberMe = storage.read(AuthenticationPrefKeys.remmemberMe);
    if (savedEmail != null &&
        savedPassword != null &&
        savedRememberMe == true) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe.value = savedRememberMe;
    }

    final biometricEmail =
        await secureStorage.read(key: AuthenticationPrefKeys.biometricEmail);
    final biometricPassword =
        await secureStorage.read(key: AuthenticationPrefKeys.biometricPassword);
    final biometricEnabled =
        storage.read(AuthenticationPrefKeys.biometricEnabled);

    if (biometricEmail != null &&
        biometricPassword != null &&
        biometricEnabled == true) {
      isBiometricAvaibale(true);
    }
  }

  Future<void> login({
    String email = "",
    String password = "",
    bool isBiometricLogin = false,
  }) async {
    //
    final actualEmail = isBiometricLogin ? email : emailController.text;
    final actualPassword =
        isBiometricLogin ? password : passwordController.text;

    if (!isValidEmail(actualEmail)) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter a valid email address.',
      );
      return;
    }
    if (actualPassword.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter password to process further.',
      );
      return;
    }

    final String? token = await getFCMToken();
    debugPrint(token);

    var body = <String, dynamic>{
      "email": actualEmail.trim(),
      "password": actualPassword.trim(),
      "fcm": token,
      "platform": Platform.isAndroid ? 'Android' : 'iOS'
    };

    final DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        final info = await infoPlugin.iosInfo;
        body["device_name"] = info.name;
        body["device_id"] = info.identifierForVendor;
      } else {
        final info = await infoPlugin.androidInfo;
        body["device_name"] = info.device;
        body["device_id"] = info.id;
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
    }

    try {
      _isLoading(true);
      final result = await loginUseCase.call(body);

      await result.fold<Future<void>>(
          (BaseResponse<LoginPayloadEntity> data) async {
        if (data.data?.user != null && data.data?.accessToken != null) {
          authController.user.value = data.data!.user!;
          authController.isAuthenticated = true;

          await Future.wait([
            storage.write(AuthenticationPrefKeys.isLoggedIn, true),
            storage.write(AuthenticationPrefKeys.token, data.data!.accessToken),
            storage.write(UserPrefKeys.userDetails,
                authController.user.value?.toEntity()),
            storage.write(UserPrefKeys.userId, authController.user.value?.id),
            saveUserData(),
          ]);

          // Only after the token is in storage. Fired before it, this request
          // goes out unauthenticated, and the 401 handler logs the user
          // straight back out — wiping user.value on the way to the main
          // screen.
          await authController.userPermissionHelper.reloadUserPermissions();

          await authController.storeRealtimeConfiguration();

          if (!isBiometricLogin) {
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
          Get.toNamed(Routes.MAIN_SCREEN);
          // Get.offAllNamed(Routes.MAIN_SCREEN);
        } else if (data.data?.otpSent ?? false) {
          Get.toNamed(
            Routes.OTP,
            arguments: VerifyOtpParams(
              otp: "",
              email: actualEmail.trim(),
              password: actualPassword.trim(),
              fcm: token ?? "",
              platform: Platform.isAndroid ? 'Android' : 'iOS',
              deviceId: body["device_id"] ?? "",
              deviceName: body["device_name"] ?? "",
              rememberMe: rememberMe.value,
              fromBiometric: isBiometricLogin,
            ),
          );
        }
      }, (Failure e) async {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      });
    } catch (e) {
      debugPrint('Error occurred: $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      _isLoading(false);
    }
  }

  Future<void> saveUserData() async {
    if (rememberMe.value) {
      await secureStorage.write(
          key: AuthenticationPrefKeys.email, value: emailController.text);
      await secureStorage.write(
          key: AuthenticationPrefKeys.password, value: passwordController.text);
      storage.write(AuthenticationPrefKeys.remmemberMe, rememberMe.value);
    } else {
      // If "Remember Me" checkbox is unchecked, clear saved login data from storag
      await secureStorage.delete(key: AuthenticationPrefKeys.email);
      await secureStorage.delete(key: AuthenticationPrefKeys.password);
      storage.remove(AuthenticationPrefKeys.remmemberMe);
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
        value: emailController.text,
      );

      // saving password
      await secureStorage.write(
        key: AuthenticationPrefKeys.biometricPassword,
        value: passwordController.text,
      );

      await storage.write(AuthenticationPrefKeys.biometricEnabled, false);
    } catch (e) {
      debugPrint('Error saving biometric data: $e');
    }
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
        value: emailController.text,
      );

      // saving password
      await secureStorage.write(
        key: AuthenticationPrefKeys.biometricPassword,
        value: passwordController.text,
      );

      // saving state
      storage.write(AuthenticationPrefKeys.biometricEnabled, true);
    } catch (e) {
      debugPrint('Error saving biometric data: $e');
    }

    Get.back();
  }

  onBiometricLoginClicked() async {
    try {
      if (isLoading) {
        return;
      }

      //
      if (await BiometricHelper.isBiometricAvailable()) {
        if (await BiometricHelper.authenticate()) {
          //
          // fetchinh biometric email and password
          final biometricEmail = await secureStorage.read(
              key: AuthenticationPrefKeys.biometricEmail);
          final biometricPassword = await secureStorage.read(
              key: AuthenticationPrefKeys.biometricPassword);

          //
          // callin login api
          login(
              email: biometricEmail!,
              password: biometricPassword!,
              isBiometricLogin: true);
        }
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
    }
  }

  bool isValidEmail(String email) {
    // Null or empty string is invalid
    if (email.isEmpty) {
      return false;
    }
    // Pattern for valid email addresses
    // This regex pattern is a simple one and might not cover all valid cases
    // Depending on your use case, you might want to use a more comprehensive regex pattern
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if the email matches the pattern
    return regex.hasMatch(email);
  }

  Future<String?> getFCMToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      debugPrint('Cannot get token: $e');
      return null;
    }
  }
}
