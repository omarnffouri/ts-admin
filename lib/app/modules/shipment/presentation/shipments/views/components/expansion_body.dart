import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_entity.dart';

import '../../controllers/shipments_controller.dart';

class ExpansionBody extends GetView<ShipmentsController> {
  const ExpansionBody({
    super.key,
    required this.shipment,
    required this.showArrow,
  });
  final ShipmentEntity shipment;
  final RxDouble showArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? Colors.grey.shade900
            : AppColorsLight.scaffoldBackroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRow('Customer', shipment.customer),
            const SizedBox(height: 8.0),
            _buildRow('Trailer:', shipment.trailerId.toString()),
            const SizedBox(height: 8.0),
            _buildRow('Revenue:', '\$${shipment.revenue}'),
            Obx(
              () => AnimatedOpacity(
                opacity: showArrow.value,
                duration: const Duration(milliseconds: 200),
                child: InkWell(
                  onTap: () {
                    controller.handleExpantionClicks(shipment);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.grey,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

Widget _buildRow(String label, String? value) {
  return Row(
    children: [
      Text(
        label,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: Get.isDarkMode ? Colors.grey : Colors.grey[700],
        ),
      ),
      Expanded(
        child: Text(
          value ?? 'N/A',
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Get.isDarkMode ? Colors.grey : Colors.grey[700],
          ),
          textAlign: TextAlign.end,
        ),
      ),
    ],
  );
}
