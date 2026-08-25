import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_botton.dart';
import 'package:ts_admin/app/core/widgets/app_botton_outline.dart';

import '../../controllers/shipments_controller.dart';
import 'filter_by_role_widget.dart';
import 'select_dates_widget.dart';

class ShipmentsFiltersBottomSheet extends GetView<ShipmentsController> {
  const ShipmentsFiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      constraints: BoxConstraints(
        minHeight: Get.height * 0.4,
        maxHeight: Get.height * 0.4,
      ),
      child: Column(
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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

          //
          //
          // filters body

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: FilterByRoleWidget(),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: SelectDateRangeWidget(),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: AppButtonOutline(
                  text: 'Clear',
                  onTap: () {
                    controller.selectedRole.value = 'All';
                    controller.pickupDateController.clear();
                    controller.deliveryDateController.clear();
                  },
                ).marginSymmetric(horizontal: 14, vertical: 10),
              ),
              Expanded(
                child: AppButton(
                  text: 'Apply',
                  onTap: () {
                    Get.back();
                    controller.getAllShipments();
                  },
                ).marginSymmetric(horizontal: 14, vertical: 10),
              ),
            ],
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
