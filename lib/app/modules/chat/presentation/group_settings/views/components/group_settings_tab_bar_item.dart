import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/controllers/group_settings_controller.dart';

class GroupSettingsTabBarItem extends GetView<GroupSettingsController> {
  final GroupSettingsTabs tab;
  const GroupSettingsTabBarItem({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tab.name.capitalizeFirst ?? '',
        ),
        if (tab == GroupSettingsTabs.admins) _buildAdminMembersCount(),
        if (tab == GroupSettingsTabs.drivers) _buildDriverMembersCount(),
      ],
    ).marginSymmetric(vertical: 10);
  }

  _buildAdminMembersCount() {
    return Obx(
      () => Visibility(
        visible: controller.admins.isNotEmpty,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: controller.currentTab.value == tab
                ? AppColors.tabBarBadgeSelectedColor
                : AppColors.tabBarBadgeUnselectedColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            controller.admins.length.toString(),
            style: TextStyle(
              color: controller.currentTab.value == tab
                  ? AppColors.tabBarBadgeSelectedTextColor
                  : AppColors.tabBarBadgeUnselectedTextColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).marginOnly(left: 8);
  }

  _buildDriverMembersCount() {
    return Obx(
      () => Visibility(
        visible: controller.drivers.isNotEmpty,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: controller.currentTab.value == tab
                ? AppColors.tabBarBadgeSelectedColor
                : AppColors.tabBarBadgeUnselectedColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            controller.drivers.length.toString(),
            style: TextStyle(
              color: controller.currentTab.value == tab
                  ? AppColors.tabBarBadgeSelectedTextColor
                  : AppColors.tabBarBadgeUnselectedTextColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).marginOnly(left: 8);
  }
}
