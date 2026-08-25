import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class AppRedHeader extends StatelessWidget {
  const AppRedHeader(
      {super.key,
      this.height,
      this.padding,
      this.child,
      this.radius,
      this.width});

  final double? height, radius, width;

  final EdgeInsetsGeometry? padding;
  final Widget? child;

  // Bright brand-red gradient for light mode.
  static const List<Color> _lightColors = [
    AppColorsLight.mainColorDark,
    AppColorsLight.mainColorLight,
    Color.fromARGB(255, 183, 30, 35),
  ];

  // Muted near-black gradient with a dark-red accent for dark mode.
  static const List<Color> _darkColors = [
    Color.fromARGB(255, 18, 18, 18),
    Color.fromARGB(255, 90, 22, 24),
    Color.fromARGB(255, 129, 24, 24),
  ];

  static const LinearGradient _lightGradient = LinearGradient(
    colors: _lightColors,
    stops: _stops,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient _darkGradient = LinearGradient(
    colors: _darkColors,
    stops: _stops,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const List<double> _stops = [0.0, 0.5, 1.0];

  /// The active brand gradient. Exposed so screens that need the same sweep on
  /// a custom-shaped surface (e.g. a collapsing sliver header) stay in sync —
  /// sweep direction included, not just the colours. Const per brightness: the
  /// hero reads this every scroll frame.
  static LinearGradient get gradient =>
      Get.isDarkMode ? _darkGradient : _lightGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius ?? 32),
          bottomRight: Radius.circular(radius ?? 32),
        ),
      ),
      child: child,
    );
  }
}
