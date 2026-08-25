import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/shipment_details_controller.dart';
import 'shipment_section_card.dart';

/// Customer and equipment information: customer, customer reference,
/// trailer number, and BOL number.
class ShipmentInformationSection extends GetView<ShipmentDetailsController> {
  const ShipmentInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final details = controller.shipmentDetails;
      return ShipmentSectionCard(
        title: 'Shipment Information',
        icon: Icons.info_outline_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShipmentInfoRow(
              icon: Icons.business_outlined,
              label: 'Customer',
              value: details?.customer,
            ),
            const SizedBox(height: 14),
            ShipmentInfoRow(
              icon: Icons.tag_rounded,
              label: 'Customer Reference',
              value: details?.customerReference,
            ),
            const SizedBox(height: 14),
            ShipmentInfoRow(
              icon: Icons.rv_hookup_outlined,
              label: 'Trailer',
              value: controller.trailerId.value.isEmpty
                  ? null
                  : controller.trailerId.value,
            ),
            const SizedBox(height: 14),
            ShipmentInfoRow(
              icon: Icons.receipt_long_outlined,
              label: 'BOL Number',
              value: details?.bolNumber,
            ),
          ],
        ),
      );
    });
  }
}

/// Label/value field block that stacks vertically so long values wrap
/// instead of overflowing, regardless of text-scale factor.
class ShipmentInfoRow extends StatelessWidget {
  const ShipmentInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasValue = value?.trim().isNotEmpty ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.tertiaryTextColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                hasValue ? value!.trim() : 'N/A'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasValue
                      ? context.primaryTextColor
                      : context.tertiaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
