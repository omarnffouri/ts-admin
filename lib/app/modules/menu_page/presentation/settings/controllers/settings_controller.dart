import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/biometric_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/system_rules_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/app_configration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_app_configration_usecase.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/domain/usecases/update_otp_usecase.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/views/bottom_sheets/biometric_bottom_sheet.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class SettingsController extends GetxController {
  final authController = Get.find<AuthController>();

  final _getAppConfigrationUseCase = sl<GetAppConfigrationUseCase>();

  final isChecked = false.obs;
  final biometricAvailable = false.obs;
  final otpEnabled = false.obs;
  final isConfigrationLoading = false.obs;
  final isOtpUpdating = false.obs;
  PackageInfo? packageInfo;
  RxString version = ''.obs;

  final biometricEnabled = false.obs;

  bool get isLoggoingOut => authController.isLoggoingOut;

  bool get canUpdateOtp =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
      ]) ??
      false;

  final updateOtpValueUseCase = sl<UpdateOtpUsecase>();

  final storage = GetStorage();
  // secure storage for storing email and pass etc
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() async {
    super.onInit();
    _checkBiometricAvailable();
    _getAppConfigrations();
    packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo!.version;
  }

  _checkBiometricAvailable() async {
    try {
      final available = await BiometricHelper.isBiometricAvailable();

      if (!available) {
        return;
      }

      final biometricEmail =
          await secureStorage.read(key: AuthenticationPrefKeys.biometricEmail);

      //
      final biometricPassword = await secureStorage.read(
          key: AuthenticationPrefKeys.biometricPassword);

      if (biometricEmail != null && biometricPassword != null) {
        biometricAvailable(true);
        await _checkBiometricEnabled();
      }
    } catch (_) {}
  }

  Future<void> logout() => authController.logout();

  _checkBiometricEnabled() async {
    try {
      final enabled = storage.read(AuthenticationPrefKeys.biometricEnabled);
      if (enabled != null) {
        biometricEnabled(enabled);
      }
    } catch (_) {}
  }

  Future<void> _getAppConfigrations() async {
    await _handleApiCall(
      () => _getAppConfigrationUseCase.call(const NoParams()),
      onSuccess: (AppConfiguration data) {
        otpEnabled.value = data.isOtpEnabled ?? false;
      },
      isLoadingRx: isConfigrationLoading,
    );
  }

  Future<void> updateOtpValue(bool value) async {
    isOtpUpdating.value = true; // Start loading
    final previousValue = otpEnabled.value;
    otpEnabled.value = value; // Optimistically update

    final data = {'flag': value ? 1 : 0};
    final result = await updateOtpValueUseCase.call(data);

    result.fold((bool success) {
      // Success, you can optionally refresh config here
      // await _getAppConfigrations();
    }, (Failure r) {
      // On error, revert
      otpEnabled.value = previousValue;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: r.message,
      );
    });

    isOtpUpdating.value = false; // Stop loading
  }

  biometricClicked() async {
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
        return const BiometricBottomSheet();
      },
    );
  }

  toggleBiometric() async {
    try {
      if (await BiometricHelper.authenticate()) {
        biometricEnabled.toggle();
        await storage.write(
            AuthenticationPrefKeys.biometricEnabled, biometricEnabled.value);
        Get.back();
      }
    } catch (_) {}
  }

  // Generic API call handler
  Future<void> _handleApiCall<T>(
    Future<Either<T, Failure>> Function() apiCall, {
    required void Function(T result) onSuccess,
    void Function(Failure failure)? onFailure,
    RxBool? isLoadingRx,
  }) async {
    isLoadingRx?.value = true;
    try {
      final result = await apiCall();
      result.fold(
        (data) => onSuccess(data),
        (failure) {
          CommonWidgets.showSnackBar(title: 'Error', message: failure.message);
          onFailure?.call(failure);
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoadingRx?.value = false;
    }
  }
}
