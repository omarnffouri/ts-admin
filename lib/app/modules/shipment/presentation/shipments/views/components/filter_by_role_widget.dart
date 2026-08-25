import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../controllers/shipments_controller.dart';

class FilterByRoleWidget extends GetView<ShipmentsController> {
  const FilterByRoleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const LeadingView().marginSymmetric(horizontal: 5)
          : DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Get.isDarkMode
                          ? Colors.white
                          : Colors.black.applyOpacity(0.5),
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black.applyOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black.applyOpacity(0.5),
                  ),
                ),
              ),
              style: Get.textTheme.bodyMedium!.copyWith(fontSize: 14),
              selectedItemBuilder: (BuildContext context) {
                return controller.roleOptions
                    .map(
                      (item) => Text(
                        item.formatStatus(),
                        style: Get.textTheme.bodyMedium!.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    )
                    .toList();
              },
              hint: Text(
                controller.selectedRole.value.formatStatus(),
                style: Get.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                ),
              ),
              items: controller.roleOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item.formatStatus(),
                      ),
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select role';
                }
                return null;
              },
              onChanged: controller.handleStatusChange,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:
                      Get.isDarkMode ? AppColorsDark.mainColor : Colors.white,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ).marginSymmetric(horizontal: 5),
    );
  }
}

class LeadingView extends GetView<ShipmentsController> {
  const LeadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        hint: Text(
          controller.selectedRole.value.formatStatus(),
          style: const TextStyle(fontSize: 14),
        ),
        items: const [],
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white70,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
