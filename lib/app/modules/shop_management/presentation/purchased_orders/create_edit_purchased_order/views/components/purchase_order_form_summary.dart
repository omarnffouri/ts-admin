import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../purchased_order_detail/views/components/purchase_order_metric.dart';
import '../../controllers/create_edit_purchased_order_controller.dart';

class PurchaseOrderFormSummary
    extends GetView<CreateEditPurchasedOrderController> {
  const PurchaseOrderFormSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Obx(
      () {
        final int partLines = controller.purchasedParts.length;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.tileColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.hairlineBorderColor),
            boxShadow: context.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.035),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.brandColor.applyOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.summarize_outlined,
                  size: 18,
                  color: context.brandColor,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Order summary',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PurchaseOrderMetric(
                label: 'Part lines',
                value: '$partLines',
                alignEnd: true,
                emphasize: true,
                semanticsLabel: 'Part lines in this order: $partLines',
              ),
            ],
          ),
        );
      },
    );
  }
}
