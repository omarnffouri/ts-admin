import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/enitities/shipment_details_entity.dart';
import '../../controllers/shipment_details_controller.dart';
import 'shipment_section_card.dart';

class AdditionalChargesSection extends GetView<ShipmentDetailsController> {
  const AdditionalChargesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<AdditionalCharge> charges =
          controller.shipmentDetails?.additionalCharges ?? [];

      return ShipmentSectionCard(
        title: 'Additional Charges',
        icon: Icons.add_card_rounded,
        child: charges.isEmpty
            ? const ShipmentSectionEmptyMessage(
                message: 'No additional charges for this shipment.')
            : Column(
                children: [
                  for (int i = 0; i < charges.length; i++) ...[
                    AdditionalChargeCard(charge: charges[i]),
                    if (i != charges.length - 1) const SizedBox(height: 10),
                  ],
                ],
              ),
      );
    });
  }
}

class AdditionalChargeCard extends StatelessWidget {
  const AdditionalChargeCard({super.key, required this.charge});

  final AdditionalCharge charge;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasDriverName = charge.driverName?.trim().isNotEmpty ?? false;
    final bool hasDriverPay = charge.driverPay?.trim().isNotEmpty ?? false;
    final bool hasNote = charge.note?.trim().isNotEmpty ?? false;
    final String? reason = charge.reason?.value;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  hasDriverName
                      ? charge.driverName!.trim()
                      : (charge.driverId != null
                          ? 'Driver #${charge.driverId}'
                          : 'N/A'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // No driver_pay on the record means the share was never set —
              // show nothing rather than the total, which is a different figure.
              Text(
                hasDriverPay
                    ? charge.driverPay!.trim().decimalPattern().dollar()
                    : '—',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasDriverPay
                      ? context.brandColor
                      : context.tertiaryTextColor,
                  fontWeight: hasDriverPay ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
          if (reason != null && reason.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 13, color: context.tertiaryTextColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    reason,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (hasNote) ...[
            const SizedBox(height: 6),
            Text(
              charge.note!.trim(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.tertiaryTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
