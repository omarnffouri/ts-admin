import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../domain/entities/service_order_entity.dart';
import '../../../service_orders/views/components/service_order_item_card.dart';

class ServiceInfoWidget extends StatelessWidget {
  const ServiceInfoWidget({
    super.key,
    required this.serviceOrder,
    required this.orderDetails,
  });

  final ServiceOrderEntity serviceOrder;
  final ServiceDetailEntity? orderDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String title = _displayValue(orderDetails?.maintenanceTypeTitle);
    final String partsValue = _displayValue(orderDetails?.partsRequired);
    final bool partsRequired = partsValue.toLowerCase() == 'yes';
    final bool partsKnown = partsValue != 'N/A';
    final Color partsColor = partsRequired
        ? Colors.green
        : partsKnown
            ? Theme.of(context).colorScheme.error
            : context.secondaryTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ServiceOrderStatusBadge(status: orderDetails?.status),
          ],
        ),
        const SizedBox(height: 13),
        Divider(height: 1, color: context.hairlineBorderColor),
        const SizedBox(height: 13),
        _DetailRow(
          label: 'Maintenance Type',
          value: orderDetails?.maintenanceType?.toTitleCase(),
        ),
        const SizedBox(height: 9),
        _DetailRow(
          label: 'Category',
          value: serviceOrder.category?.toTitleCase(),
        ),
        const SizedBox(height: 9),
        _DetailRow(
          label: 'Service Type',
          value: orderDetails?.serviceType?.toTitleCase(),
        ),
        const SizedBox(height: 9),
        _DetailRow(
          label: 'Service Charges Type',
          value: orderDetails?.serviceChargesType?.toTitleCase(),
        ),
        const SizedBox(height: 9),
        _DetailRow(label: 'Rate', value: orderDetails?.rate),
        const SizedBox(height: 9),
        _DetailRow(label: 'Mileage', value: orderDetails?.mileage),
        const SizedBox(height: 9),
        _DetailRow(
          label: 'Maintenance Date',
          value: serviceOrder.maintenanceDate.formatDateOrNA(),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: partsColor.applyOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: partsColor.applyOpacity(0.25)),
          ),
          child: Row(
            children: [
              Icon(
                partsRequired
                    ? Icons.check_circle_outline_rounded
                    : partsKnown
                        ? Icons.cancel_outlined
                        : Icons.remove_circle_outline_rounded,
                size: 19,
                color: partsColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Parts Required',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                partsValue == 'N/A' ? partsValue : partsValue.toTitleCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: partsColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _displayValue(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? 'N/A' : normalized;
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue =
        value?.trim().isNotEmpty == true ? value!.trim() : 'N/A';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Text(
            displayValue,
            textAlign: TextAlign.end,
            softWrap: true,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
