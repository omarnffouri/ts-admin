import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../domain/entities/purchase_order_entity.dart';
import '../../controllers/purchased_order_detail_controller.dart';
import 'purchase_order_detail_section.dart';

class ClientDetailsCard extends GetView<PurchasedOrderDetailController> {
  const ClientDetailsCard({super.key, required this.purchaseOrder});

  final PurchaseOrderEntity purchaseOrder;

  @override
  Widget build(BuildContext context) {
    final client = purchaseOrder.client;

    final Widget companyName = _ClientField(
      label: 'Company Name',
      value: controller.purchaseOrderValueOrNA(client?.companyName),
    );
    final Widget customerName = _ClientField(
      label: 'Customer Name',
      value: controller.purchaseOrderValueOrNA(client?.contactPerson),
    );
    final Widget email = _ClientField(
      label: 'Email',
      value: controller.purchaseOrderValueOrNA(client?.email),
    );

    return PurchaseOrderDetailSection(
      icon: Icons.person_outline_rounded,
      title: 'Client Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: companyName),
              const SizedBox(width: 14),
              customerName,
            ],
          ),
          const SizedBox(height: 14),
          email,
        ],
      ),
    );
  }
}

class _ClientField extends StatelessWidget {
  const _ClientField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.tertiaryTextColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            softWrap: true,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
