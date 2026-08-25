import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../domain/entities/purchase_order_entity.dart';
import '../../controllers/purchased_order_detail_controller.dart';
import 'purchase_order_metric.dart';

class PurchaseOrderPartCard extends GetView<PurchasedOrderDetailController> {
  const PurchaseOrderPartCard({super.key, required this.part});

  final VehiclePart part;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final String name = controller.purchaseOrderValueOrNA(part.itemName);
    final String required =
        controller.purchaseOrderNumberOrNA(part.numberOfPartsRequired);
    final String available =
        controller.purchaseOrderNumberOrNA(part.numberOfPartsAvailable);
    final String purchased =
        controller.purchaseOrderNumberOrNA(part.partsToBePurchased);
    final String unitPrice = controller.purchaseOrderPriceOrNA(part.partPrice);
    final String totalPrice =
        controller.purchaseOrderPriceOrNA(part.totalPrice);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // part name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.settings_outlined,
                  size: 16,
                  color: context.secondaryTextColor,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  softWrap: true,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 22,
            runSpacing: 10,
            children: [
              PurchaseOrderMetric(
                label: 'Required',
                value: required,
                semanticsLabel: 'Required quantity: $required',
              ),
              PurchaseOrderMetric(
                label: 'Available',
                value: available,
                semanticsLabel: 'Available quantity: $available',
              ),
              PurchaseOrderMetric(
                label: 'Purchased',
                value: purchased,
                semanticsLabel: 'Purchased quantity: $purchased',
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: context.hairlineBorderColor),
          const SizedBox(height: 10),

          //
          // prices
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PurchaseOrderMetric(
                  label: 'Unit price',
                  value: unitPrice,
                  semanticsLabel: 'Unit price: $unitPrice',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PurchaseOrderMetric(
                  label: 'Total price',
                  value: totalPrice,
                  alignEnd: true,
                  emphasize: true,
                  semanticsLabel: 'Total price: $totalPrice',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
