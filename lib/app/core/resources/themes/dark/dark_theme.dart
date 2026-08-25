import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/dark/text_theme.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

final ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorsDark.mainColor,
    onPrimary: Colors.white,
    secondary: AppColorsDark.mainColor,
    onSecondary: Colors.white,
    error: AppColorsLight.mainColorDark,
    onError: Colors.white,
    surface: AppColorsDark.mainColor,
    onSurface: Colors.white,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  scaffoldBackgroundColor: AppColorsDark.scaffoldBackroundColor,
  secondaryHeaderColor: AppColorsDark.secondaryHeaderColor,
  primaryColor: AppColorsDark.mainColor,
  primaryColorDark: AppColorsDark.mainColorDark,
  primaryColorLight: AppColorsDark.mainColorLight,
  // bottomAppBarColor: AppColorsDark.white,
  disabledColor: AppColorsDark.disabledColor,

  // fontFamily: 'Roboto',
  // errorColor: const Color(0xFFb11116),
  cardColor: AppColorsDark.cardBackgroundColor,
  hintColor: AppColorsDark.hintTextColor,

  //
  // inkwell and ripple effect configs

  splashColor: AppColorsLight.mainColor.applyOpacity(0.2), // For ripple effect
  highlightColor:
      AppColorsLight.mainColor.applyOpacity(0.1), // When holding down
  hoverColor: AppColorsLight.mainColor.applyOpacity(0.05), // For mouse hover

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: AppColorsDark.mainColor),
  ),
  textTheme: DarkTextTheme.textTheme,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColorsDark.bnIconsSelectedColor,
    selectedIconTheme: IconThemeData(
      color: AppColorsDark.bnIconsSelectedColor,
    ),
    unselectedItemColor: AppColorsDark.bnIconsUnselectedColor,
    unselectedIconTheme: IconThemeData(
      color: AppColorsDark.bnIconsUnselectedColor,
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    radius: const Radius.circular(999),
    trackColor: WidgetStatePropertyAll(
      Colors.white.applyOpacity(0.2),
    ),
    thumbColor: const WidgetStatePropertyAll(
      Colors.white,
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
        color: AppColorsDark.mainColor,
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
      const BottomAppBarThemeData(color: AppColorsDark.mainColor),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFE9EBF0),
  ),
  tabBarTheme: const TabBarThemeData(
    indicatorColor: AppColorsDark.mainColor,
    labelColor: AppColorsDark.tabBarSelectedColor,
    unselectedLabelColor: AppColorsDark.tabBarUnselectedColor,
    unselectedLabelStyle: TextStyle(
      color: AppColorsDark.tabBarUnselectedColor,
      fontSize: 14,
    ),
    labelStyle: TextStyle(
      color: AppColorsDark.tabBarSelectedColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarTheme: const AppBarTheme(
    actionsIconTheme: IconThemeData(color: AppColorsDark.iconsColor),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColorsDark.mainColor,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
);
