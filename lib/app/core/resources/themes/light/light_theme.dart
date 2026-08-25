import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/text_theme.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColorsLight.mainColor,
    onPrimary: Colors.white,
    secondary: AppColorsLight.mainColor,
    onSecondary: Colors.white,
    error: AppColorsLight.mainColor,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: AppColorsLight.scaffoldBackroundColor,
  secondaryHeaderColor: AppColorsLight.secondaryHeaderColor,
  primaryColor: AppColorsLight.mainColor,
  primaryColorDark: AppColorsLight.mainColorDark,
  primaryColorLight: AppColorsLight.mainColorLight,
  // bottomAppBarColor: AppColorsLight.white,
  disabledColor: AppColorsLight.disabledColor,
  fontFamily: 'Roboto',
  textTheme: LightTextTheme.textTheme,
  // errorColor: const Color(0xFFb11116),
  cardColor: AppColorsLight.cardBackgroundColor,
  hintColor: AppColorsLight.hintTextColor,

  //
  // inkwell and ripple effect configs

  splashColor: AppColorsLight.mainColor.applyOpacity(0.2), // For ripple effect
  highlightColor:
      AppColorsLight.mainColor.applyOpacity(0.1), // When holding down
  hoverColor: AppColorsLight.mainColor.applyOpacity(0.05), // For mouse hover

  //
  //
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: AppColorsLight.mainColor),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColorsLight.bnIconsSelectedColor,
    selectedIconTheme: IconThemeData(
      color: AppColorsLight.bnIconsSelectedColor,
    ),
    unselectedItemColor: AppColorsLight.bnIconsUnselectedColor,
    unselectedIconTheme: IconThemeData(
      color: AppColorsLight.bnIconsUnselectedColor,
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    radius: const Radius.circular(999),
    trackColor: WidgetStatePropertyAll(
      AppColorsLight.mainColor.applyOpacity(0.2),
    ),
    thumbColor: const WidgetStatePropertyAll(
      AppColorsLight.mainColor,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 13,
      color: Color(0xffa0a0a0),
    ),
    labelStyle: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 13,
      color: Color(0xffa0a0a0),
    ),
    alignLabelWithHint: true,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColorsLight.mainColor,
      ),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffa0a0a0),
      ),
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: const WidgetStatePropertyAll(AppColorsLight.mainColor),
    overlayColor: WidgetStatePropertyAll(
      AppColorsLight.mainColor.applyOpacity(0.3),
    ),
  ),
  bottomAppBarTheme:
      const BottomAppBarThemeData(color: AppColorsLight.mainColor),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFE9EBF0),
  ),
  tabBarTheme: const TabBarThemeData(
    indicatorColor: AppColorsLight.mainColor,
    labelColor: AppColorsLight.tabBarSelectedColor,
    unselectedLabelColor: AppColorsLight.tabBarUnselectedColor,
    unselectedLabelStyle: TextStyle(
      color: AppColorsLight.tabBarUnselectedColor,
      fontSize: 14,
    ),
    labelStyle: TextStyle(
      color: AppColorsLight.tabBarSelectedColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarTheme: const AppBarTheme(
    actionsIconTheme: IconThemeData(color: Colors.green),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColorsLight.mainColor, // Set your desired color here
      statusBarIconBrightness: Brightness.light,
    ),
  ),
);

///
///
///
///
