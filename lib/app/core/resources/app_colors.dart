import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/values/app_settings_preferences_keys.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

// 100% — FF  ##  50% — 80
// 99% — FC   ## 49% — 7D
// 98% — FA   ## 48% — 7A
// 97% — F7   ## 47% — 78
// 96% — F5   ## 46% — 75
// 95% — F2   ## 45% — 73
// 94% — F0   ## 44% — 70
// 93% — ED   ## 43% — 6E
// 92% — EB   ## 42% — 6B
// 91% — E8   ## 41% — 69
// 90% — E6   ## 40% — 66
// 89% — E3   ## 39% — 63
// 88% — E0   ## 38% — 61
// 87% — DE   ## 37% — 5E
// 86% — DB   ## 36% — 5C
// 85% — D9   ## 35% — 59
// 84% — D6   ## 34% — 57
// 83% — D4   ## 33% — 54
// 82% — D1   ## 32% — 52
// 81% — CF   ## 31% — 4F
// 80% — CC   ## 30% — 4D
// 79% — C9   ## 29% — 4A
// 78% — C7   ## 28% — 47
// 77% — C4   ## 27% — 45
// 76% — C2   ## 26% — 42
// 75% — BF   ## 25% — 40
// 74% — BD   ## 24% — 3D
// 73% — BA   ## 23% — 3B
// 72% — B8   ## 22% — 38
// 71% — B5   ## 21% — 36
// 70% — B3   ## 20% — 33
// 69% — B0   ## 19% — 30
// 68% — AD   ## 18% — 2E
// 67% — AB   ## 17% — 2B
// 66% — A8   ## 16% — 29
// 65% — A6   ## 15% — 26
// 64% — A3   ## 14% — 24
// 63% — A1   ## 13% — 21
// 62% — 9E   ## 12% — 1F
// 61% — 9C   ## 11% — 1C
// 60% — 99   ## 10% — 1A
// 59% — 96   ## 9% — 17
// 58% — 94   ## 8% — 14
// 57% — 91   ## 7% — 12
// 56% — 8F   ## 6% — 0F
// 55% — 8C   ## 5% — 0D
// 54% — 8A   ## 4% — 0A
// 53% — 87   ## 3% — 08
// 52% — 85   ## 2% — 05
// 51% — 82   ## 1% — 03

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  // Getter
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  // Setter
  init() {
    final darkMode = GetStorage().read(AppSettingsPrefKeys.isDarkMode);
    _isDarkMode(darkMode == true);
  }

  toggleTheme() {
    _isDarkMode((!isDarkMode));
  }
}

const Color chatReciptsColor = Colors.black;

const Color kMainColor = Color(0xFFE21F26);
const Color kMainColorDark = Color(0xFF9e151a);
const Color chatSenderTextColor = Colors.black;
const Color chatReciverTextColor = Colors.white;

class AppColors {
  AppColors._();

  static Color get mainColor => AppColorsLight.mainColor;

  static Color get shimmerBaseColor => Get.isDarkMode
      ? AppColorsDark.shimmerBaseColor
      : AppColorsLight.shimmerBaseColor;

  static Color get tabBarSelectedTabColor => Get.isDarkMode
      ? AppColorsDark.tabBarSelectedColor
      : AppColorsLight.tabBarSelectedColor;

  static Color get tabBarUnselectedTabColor => Get.isDarkMode
      ? AppColorsDark.tabBarUnselectedColor
      : AppColorsLight.tabBarUnselectedColor;

  static Color get tabBarIndicatorColor => AppColorsLight.mainColor;

  static Color get circularProgressIndicatorColor =>
      Get.isDarkMode ? Colors.white : AppColorsLight.mainColor;

  //
  //
  // tab bar bagde selected colors

  static Color get tabBarBadgeSelectedColor => Get.isDarkMode
      ? AppColorsDark.tabBarBadgeSelectedColor
      : AppColorsLight.tabBarBadgeSelectedColor;

  static Color get tabBarBadgeSelectedTextColor => Get.isDarkMode
      ? AppColorsDark.tabBarBadgeSelectedTextColor
      : AppColorsLight.tabBarBadgeSelectedTextColor;

  //
  //
  // tab bar bagde unselected colors

  static Color get tabBarBadgeUnselectedColor => Get.isDarkMode
      ? AppColorsDark.tabBarBadgeUnselectedColor
      : AppColorsLight.tabBarBadgeUnselectedColor;

  static Color get tabBarBadgeUnselectedTextColor => Get.isDarkMode
      ? AppColorsDark.tabBarBadgeUnselectedTextColor
      : AppColorsLight.tabBarBadgeUnselectedTextColor;

  static Color get archiveLableColor =>
      Get.isDarkMode ? Colors.white : mainColor;

  static Color get converstionsImageLetterBackgroundColor =>
      mainColor.applyOpacity(0.1);

  static Color get converstionsImageLetterColor =>
      Get.isDarkMode ? Colors.white : mainColor;

  //
  //
  // bottom navigation colors
  static Color bnIconsUnselectedColor = Get.isDarkMode
      ? AppColorsDark.bnIconsUnselectedColor
      : AppColorsLight.bnIconsUnselectedColor;
  static Color bnIconsSelectedColor = Get.isDarkMode
      ? AppColorsDark.bnIconsSelectedColor
      : AppColorsLight.bnIconsSelectedColor;
}
