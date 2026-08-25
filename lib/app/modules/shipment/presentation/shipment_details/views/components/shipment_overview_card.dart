import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/enitities/shipment_details_entity.dart';
import '../../controllers/shipment_details_controller.dart';
import 'shipment_status_badge.dart';

/// Hero card for the shipment details page: shipment number, status,
/// dispatch type, and the assigned driver(s)/truck(s).
class ShipmentOverviewCard extends GetView<ShipmentDetailsController> {
  const ShipmentOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Driver> drivers = controller.shipmentDetails?.drivers ?? [];

    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.tileColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.hairlineBorderColor),
          boxShadow: context.isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.applyOpacity(0.045),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.brandColor
                        .applyOpacity(context.isDark ? 0.18 : 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    size: 20,
                    color: context.isDark
                        ? Colors.white.applyOpacity(0.85)
                        : context.brandColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.title.value.isEmpty
                        ? 'N/A'
                        : controller.title.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Status rides in with the route arguments and isn't in the
                // details payload, so entry points that don't carry it (the
                // additional-pay card) omit the badge rather than show
                // "Unknown".
                if (controller.shipmentStatus.value.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  ShipmentStatusBadge(status: controller.shipmentStatus.value),
                ],
              ],
            ),
            if (controller.dispatchType.value?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              _DispatchTypeChip(type: controller.dispatchType.value!),
            ],
            if (drivers.isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(height: 1, color: context.hairlineBorderColor),
              const SizedBox(height: 12),
              for (int i = 0; i < drivers.length; i++) ...[
                _DriverRow(driver: drivers[i]),
                if (i != drivers.length - 1) const SizedBox(height: 10),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _DispatchTypeChip extends StatelessWidget {
  const _DispatchTypeChip({required this.type});

  final String type;

  String get _code => getDriverType(type);

  String get _fullLabel {
    switch (type.toLowerCase()) {
      case 'pickup_delivery':
        return 'Pickup & Delivery';
      case 'pickup':
        return 'Pickup';
      case 'delivery':
        return 'Delivery';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String code = _code;
    if (code.isEmpty) return const SizedBox.shrink();

    return Semantics(
      label: 'Dispatch type: $_fullLabel',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: context.hairlineBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.alt_route_rounded,
                size: 14, color: context.secondaryTextColor),
            const SizedBox(width: 5),
            Text(
              code,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow({required this.driver});

  final Driver driver;

  @override
  Widget build(BuildContext context) {
    final String code = getDriverType(driver.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (code.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        const SizedBox(width: 8),
        Icon(Icons.person_outline_rounded,
            size: 15, color: context.tertiaryTextColor),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            driver.name?.trim().isNotEmpty ?? false
                ? driver.name!.trim()
                : 'N/A',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        if (driver.truck != null) ...[
          const SizedBox(width: 8),
          Icon(Icons.local_shipping_outlined,
              size: 14, color: context.tertiaryTextColor),
          const SizedBox(width: 3),
          Text(
            '${driver.truck}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
        if (driver.settlementStatus != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: getSettlementStatusColor(driver.settlementStatus),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              formatSettlementStatus(driver.settlementStatus),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
