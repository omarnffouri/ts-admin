import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/biometric_helper.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/values/app_settings_preferences_keys.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/system_rules_keys.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/views/bottom_sheets/biometric_bottom_sheet.dart';

class MenuPageController extends GetxController {
  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();

  final isChecked = false.obs;
  final biometricAvailable = false.obs;
  final biometricEnabled = false.obs;

  final RxInt currentActiveTabIndex = 0.obs;

  final storage = GetStorage();
  // secure storage for storing email and pass etc
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  bool get canViewInspections =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
        SystemRulesKeys.inspector,
      ]) ??
      false;

  bool get canViewHr =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
        SystemRulesKeys.hr,
      ]) ??
      false;

  bool get canViewUserManagement =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
      ]) ??
      false;

  bool get canViewInvoiceManagement =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
      ]) ??
      false;

  bool get canViewForms =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
        SystemRulesKeys.safety,
      ]) ??
      false;

  bool get canViewShop =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
        SystemRulesKeys.shop,
      ]) ??
      false;

  bool get canShowStorage =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
        SystemRulesKeys.storage,
      ]) ??
      false;

  bool get hasDispactherRules =>
      authController.userPermissionHelper.isDispatcher();

  bool get isOnlyYard =>
      authController.user.value?.hasSingleRole(
        SystemRulesKeys.yard,
      ) ??
      true;

  bool get canViewAssets =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
        SystemRulesKeys.safety,
      ]) ??
      false;

  /// Gates the Safety tab — true when any section inside it is visible.
  bool get canViewSafety => canViewAssets || canViewInspections;

  //
  //
  @override
  void onInit() {
    super.onInit();
    _checkBiometricAvailable();
  }

  Future<void> toggleThemeMode() async {
    themeController.toggleTheme();
    await storage.write(
      AppSettingsPrefKeys.isDarkMode,
      themeController.isDarkMode,
    );
  }

  onTabChanged(int index) {
    currentActiveTabIndex(index);
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

  _checkBiometricEnabled() async {
    try {
      final enabled = storage.read(AuthenticationPrefKeys.biometricEnabled);
      if (enabled != null) {
        biometricEnabled(enabled);
      }
    } catch (_) {}
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
}
