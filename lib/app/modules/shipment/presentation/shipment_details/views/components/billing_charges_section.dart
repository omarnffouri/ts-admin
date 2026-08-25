import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/enitities/shipment_details_entity.dart';
import '../../controllers/shipment_details_controller.dart';
import 'shipment_section_card.dart';

class BillingChargesSection extends GetView<ShipmentDetailsController> {
  const BillingChargesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<ShipmentCharge> charges =
          controller.shipmentDetails?.billingCharges ?? [];

      return ShipmentSectionCard(
        title: 'Billing Charges',
        icon: Icons.receipt_rounded,
        child: charges.isEmpty
            ? const ShipmentSectionEmptyMessage(
                message: 'No billing charges for this shipment.')
            : Column(
                children: [
                  for (int i = 0; i < charges.length; i++) ...[
                    BillingChargeCard(charge: charges[i]),
                    if (i != charges.length - 1) const SizedBox(height: 10),
                  ],
                ],
              ),
      );
    });
  }
}

class BillingChargeCard extends StatelessWidget {
  const BillingChargeCard({super.key, required this.charge});

  final ShipmentCharge charge;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool usedForPay = charge.useForPay?.toLowerCase() == 'yes' ||
        charge.useForPay?.toLowerCase() == 'true';
    final String? revenue = charge.revenue;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  charge.type?.capitalizeFirst ?? 'N/A',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      usedForPay
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 14,
                      color: usedForPay
                          ? (context.isDark
                              ? Colors.green.shade300
                              : Colors.green.shade700)
                          : context.tertiaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Use for pay: ${charge.useForPay?.capitalizeFirst ?? 'N/A'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            revenue != null && revenue.isNotEmpty
                ? revenue.decimalPattern().dollar()
                : 'N/A',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.brandColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
