import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../domain/entities/purchase_order_entity.dart';
import '../../../purchased_orders/views/components/purchase_order_status_badge.dart';
import 'purchase_order_metric.dart';

class PurchaseOrderSummaryCard extends StatelessWidget {
  const PurchaseOrderSummaryCard({super.key, required this.purchaseOrder});

  final PurchaseOrderEntity purchaseOrder;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final String orderNumber =
        purchaseOrder.orderNumber?.capitalizeFirst ?? 'N/A';
    final String purchaseDate = purchaseOrder.purchaseDate.formatDateOrNA();
    final String createdBy = purchaseOrder.createdBy?.capitalizeFirst ?? 'N/A';

    final Widget date = PurchaseOrderMetric(
      icon: Icons.event_outlined,
      label: 'Purchase date',
      value: purchaseDate,
    );
    final Widget creator = PurchaseOrderMetric(
      icon: Icons.person_outline_rounded,
      label: 'Created by',
      value: createdBy,
    );

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _OrderGlyph(),
              Expanded(
                child: Semantics(
                  label: 'Purchase order $orderNumber',
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderNumber,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: context.primaryTextColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Purchase order',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.tertiaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 8),
              Flexible(
                child: PurchaseOrderStatusBadge(status: purchaseOrder.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: context.hairlineBorderColor),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              date,
              const Spacer(),
              creator,
            ],
          )
        ],
      ),
    );
  }
}

class _OrderGlyph extends StatelessWidget {
  const _OrderGlyph();

  @override
  Widget build(BuildContext context) {
    final Color accent = context.brandColor;

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.applyOpacity(context.isDark ? 0.18 : 0.10),
        border: Border.all(color: accent.applyOpacity(0.24)),
      ),
      child: Icon(
        Icons.receipt_long_outlined,
        size: 20,
        color: context.isDark ? Colors.white.applyOpacity(0.85) : accent,
      ),
    );
  }
}
