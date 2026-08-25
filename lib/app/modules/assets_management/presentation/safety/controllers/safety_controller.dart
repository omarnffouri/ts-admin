import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../menu_page/presentation/menu/controllers/menu_page_controller.dart';

class SafetyController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Drives the one-shot entrance reveal (fade + slide) when the page loads.
  late final AnimationController entrance;

  /// Exposes view-permission flags for the safety sections.
  late final MenuPageController menu;

  @override
  void onInit() {
    super.onInit();
    menu = Get.put(MenuPageController());
    entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    // Slight delay so the first frame paints before the reveal begins.
    WidgetsBinding.instance.addPostFrameCallback((_) => entrance.forward());
  }

  /// Returns an interval-based animation slice for staggered reveals.
  Animation<double> slice(double start, double end) {
    return CurvedAnimation(
      parent: entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  void onClose() {
    entrance.dispose();
    super.onClose();
  }
}
