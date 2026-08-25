import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/service_order_entity.dart';

class VehicleInfoWidget extends StatelessWidget {
  const VehicleInfoWidget({
    super.key,
    required this.customerDetails,
    this.embedded = false,
  });

  final CustomerEntity? customerDetails;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: embedded
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: embedded
          ? null
          : BoxDecoration(
              color: context.tileColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.hairlineBorderColor),
              boxShadow: context.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.applyOpacity(0.045),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.brandColor.applyOpacity(0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: 19,
                  color: context.brandColor,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Vehicle Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: embedded
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: embedded
                ? null
                : BoxDecoration(
                    color: context.surfaceVariantColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
            child: Column(
              children: [
                _VehicleInfoRow(label: 'Make', value: customerDetails?.make),
                const _VehicleInfoDivider(),
                _VehicleInfoRow(label: 'VIN', value: customerDetails?.vin),
                const _VehicleInfoDivider(),
                _VehicleInfoRow(label: 'Year', value: customerDetails?.year),
                const _VehicleInfoDivider(),
                _VehicleInfoRow(
                  label: 'Identifier',
                  value: customerDetails?.identifier,
                ),
                const _VehicleInfoDivider(),
                _VehicleInfoRow(
                  label: 'License Plate',
                  value: customerDetails?.licensePlate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleInfoRow extends StatelessWidget {
  const _VehicleInfoRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String displayValue =
        value?.trim().isNotEmpty == true ? value!.trim() : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
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
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleInfoDivider extends StatelessWidget {
  const _VehicleInfoDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: context.hairlineBorderColor);
  }
}
