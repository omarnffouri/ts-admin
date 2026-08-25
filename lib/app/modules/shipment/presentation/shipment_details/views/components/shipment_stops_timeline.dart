import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/enitities/shipment_details_entity.dart';
import '../../controllers/shipment_details_controller.dart';
import 'shipment_section_card.dart';

class ShipmentStopsTimeline extends GetView<ShipmentDetailsController> {
  const ShipmentStopsTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<ShipmentStop> stops =
          controller.shipmentDetails?.shipmentStops ?? [];

      return ShipmentSectionCard(
        title: 'Shipment Stops',
        icon: Icons.alt_route_rounded,
        child: stops.isEmpty
            ? const ShipmentSectionEmptyMessage(
                message: 'No stops have been added for this shipment.')
            : Column(
                children: [
                  for (int i = 0; i < stops.length; i++)
                    ShipmentStopCard(
                      stop: stops[i],
                      sequence: i + 1,
                      isLast: i == stops.length - 1,
                    ),
                ],
              ),
      );
    });
  }
}

class _StopTypeStyle {
  const _StopTypeStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_StopTypeStyle _styleFor(BuildContext context, String? stopType) {
  switch (stopType?.toLowerCase()) {
    case 'pickup':
      return _StopTypeStyle(
        label: 'Pickup',
        color: context.brandColor,
        icon: Icons.call_made_rounded,
      );
    case 'delivery':
      return _StopTypeStyle(
        label: 'Delivery',
        color: context.isDark ? Colors.green.shade300 : Colors.green.shade700,
        icon: Icons.call_received_rounded,
      );
    default:
      return _StopTypeStyle(
        label: (stopType?.trim().isNotEmpty ?? false)
            ? stopType!.trim().capitalizeFirst!
            : 'Stop',
        color: context.secondaryTextColor,
        icon: Icons.location_on_outlined,
      );
  }
}

class ShipmentStopCard extends StatelessWidget {
  const ShipmentStopCard({
    super.key,
    required this.stop,
    required this.sequence,
    required this.isLast,
  });

  final ShipmentStop stop;
  final int sequence;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _StopTypeStyle style = _styleFor(context, stop.stopType);
    final bool hasInfo = stop.info?.trim().isNotEmpty ?? false;
    final bool hasContact = stop.contactDetails?.trim().isNotEmpty ?? false;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: style.color.applyOpacity(context.isDark ? 0.20 : 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: style.color.applyOpacity(0.4)),
                ),
                child: Text(
                  '$sequence',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: style.color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: context.hairlineBorderColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: style.color
                              .applyOpacity(context.isDark ? 0.20 : 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(style.icon, size: 12, color: style.color),
                            const SizedBox(width: 4),
                            Text(
                              style.label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: style.color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        (stop.companyName?.trim().isNotEmpty ?? false)
                            ? stop.companyName!.trim()
                            : 'N/A',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: context.primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (stop.address?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place_outlined,
                            size: 14, color: context.tertiaryTextColor),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            stop.address!.trim(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (stop.dateTime != null)
                        _Chip(
                          icon: Icons.calendar_month_rounded,
                          label: stop.dateTime!.formatDateOrNA(),
                        ),
                      if (stop.dateTime != null)
                        _Chip(
                          icon: Icons.access_time_rounded,
                          label: stop.dateTime!.formatTime(),
                        ),
                      if (stop.weight?.trim().isNotEmpty ?? false)
                        _Chip(
                          icon: Icons.scale_outlined,
                          label: stop.weight!.trim(),
                        ),
                      if (stop.goods?.trim().isNotEmpty ?? false)
                        _Chip(
                          icon: Icons.local_shipping_outlined,
                          label: stop.goods!.trim(),
                        ),
                    ],
                  ),
                  if (hasInfo) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_rounded,
                            size: 14, color: context.tertiaryTextColor),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            stop.info!.trim(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (hasContact) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.contact_phone_outlined,
                            size: 14, color: context.tertiaryTextColor),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            stop.contactDetails!.trim(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: context.tertiaryTextColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
