import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';

import '../../controllers/service_orders_controller.dart';

class ServiceOrdersFiltersBottomSheet extends GetView<ServiceOrdersController> {
  const ServiceOrdersFiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      constraints: BoxConstraints(
        minHeight: Get.height * 0.8,
        maxHeight: Get.height * 0.8,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            //
            // top header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 50,
              decoration: const BoxDecoration(
                color: AppColorsLight.mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  //
                  //
                  // close button
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),
            //
            // filters body
            Obx(
              () => _buildFilterSelector(
                title: 'By Status',
                categories: controller.statusOption.toList(),
                selectedOption: controller.selectedStatus,
              ),
            ),

            Obx(
              () => _buildFilterSelector(
                title: 'By Category',
                categories: controller.categoryOption.toList(),
                selectedOption: controller.selectedCategory,
              ),
            ),

            Obx(
              () => _buildFilterSelector(
                title: 'By Service Type',
                categories: controller.serviceTypeOption.toList(),
                selectedOption: controller.selectedServiceType,
              ),
            ),

            Obx(
              () => _buildFilterSelector(
                title: 'By Maintenance Type',
                categories: controller.maintenanceTypeOption.toList(),
                selectedOption: controller.selectedMaintenanceType,
              ),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RoundedBorderButton(
                    label: 'Clear',
                    onPressed: () {
                      controller.clearFilters();
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: RoundedFillButton(
                    label: 'Apply',
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ).marginSymmetric(horizontal: 15),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSelector({
    required List<String> categories,
    required String title,
    required RxString selectedOption,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Get.isDarkMode ? Colors.grey[700]! : Colors.black26,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 10,
            children: categories.map((category) {
              return FilterChip(
                selectedColor: AppColorsLight.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                  side: BorderSide(
                    color: selectedOption.value == category
                        ? AppColorsLight.mainColor
                        : Colors.grey,
                  ),
                ),
                backgroundColor:
                    Get.isDarkMode ? null : Colors.grey.applyOpacity(0.15),
                padding: const EdgeInsets.all(5),
                label: Text(
                  category.toTitleCase(),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: selectedOption.value == category
                        ? FontWeight.bold
                        : null,
                    color: selectedOption.value == category
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
                selected: selectedOption.value == category,
                onSelected: (selected) {
                  selectedOption.value = category;
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
