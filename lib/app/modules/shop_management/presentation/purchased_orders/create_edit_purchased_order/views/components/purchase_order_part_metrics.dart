import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../../../core/utils/extensions.dart';
import '../../../purchased_order_detail/views/components/purchase_order_metric.dart';
import '../../controllers/create_edit_purchased_order_controller.dart';

class PurchaseOrderPartMetrics extends StatelessWidget {
  const PurchaseOrderPartMetrics({super.key, required this.part});

  final VehiclePart part;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Obx(
        () {
          final String available = '${part.quantity.value}';
          final String toPurchase = '${part.partsToBePurchased.value}';
          final String unitPrice = purchaseOrderPriceOrNA(part.price.value);
          final String total = purchaseOrderPriceOrNA(part.totalPrice.value);

          return Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              PurchaseOrderMetric(
                label: 'Available',
                value: available,
                semanticsLabel: 'Available quantity: $available',
              ),
              PurchaseOrderMetric(
                label: 'To purchase',
                value: toPurchase,
                semanticsLabel: 'Parts to be purchased: $toPurchase',
              ),
              PurchaseOrderMetric(
                label: 'Unit price',
                value: unitPrice,
                semanticsLabel: 'Unit price: $unitPrice',
              ),
              PurchaseOrderMetric(
                label: 'Total',
                value: total,
                emphasize: true,
                semanticsLabel: 'Total price: $total',
              ),
            ],
          );
        },
      ),
    );
  }
}

String purchaseOrderValueOrNA(String? value) {
  final String normalized = value?.trim() ?? '';
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
    return 'N/A';
  }
  return normalized;
}

String purchaseOrderNumberOrNA(int? value) => value?.toString() ?? 'N/A';

String purchaseOrderPriceOrNA(String? value) {
  final String normalized = value?.trim() ?? '';
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
    return 'N/A';
  }
  return normalized.dollar();
}
