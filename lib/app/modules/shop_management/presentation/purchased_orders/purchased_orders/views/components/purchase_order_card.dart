import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../../domain/entities/purchase_order_entity.dart';
import '../../controllers/purchased_orders_controller.dart';
import 'purchase_order_status_badge.dart';

class PurchaseOrderCard extends GetView<PurchasedOrdersController> {
  const PurchaseOrderCard({super.key, required this.purchaseOrder});

  final PurchaseOrderEntity purchaseOrder;

  static const double _radius = 18;

  @override
  Widget build(BuildContext context) {
    if (purchaseOrder.vehicleParts.isEmpty) {
      return const SizedBox();
    }

    final ThemeData theme = Theme.of(context);
    final bool enableActions = purchaseOrder.status != 'completed' &&
        purchaseOrder.status != 'cancelled';

    final String orderNumber = purchaseOrder.orderNumber?.capitalizeFirst ?? '';
    final String clientName =
        purchaseOrder.client?.companyName?.capitalizeFirst ?? 'N/A';
    final String description =
        controller.purchaseOrderDescriptionPreview(purchaseOrder.description);
    final String createdBy = purchaseOrder.createdBy?.capitalizeFirst ?? 'N/A';

    return Slidable(
      key: ValueKey(purchaseOrder.id),
      closeOnScroll: true,
      enabled: enableActions,
      groupTag: "orders_listing_slide_group",
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: _buildSlideActions(context),
      ),
      child: Semantics(
        button: true,
        label: orderNumber.isEmpty
            ? 'Open purchase order for $clientName'
            : 'Open purchase order $orderNumber for $clientName',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_radius),
            onTap: () {
              Get.toNamed(
                Routes.PURCHASED_ORDER_DETAIL,
                arguments: purchaseOrder,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.tileColor,
                borderRadius: BorderRadius.circular(_radius),
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
                  //
                  // identifier + status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (orderNumber.isNotEmpty)
                        Flexible(
                          child:
                              _OrderIdentifierBadge(orderNumber: orderNumber),
                        ),
                      if (orderNumber.isNotEmpty) const SizedBox(width: 8),
                      Flexible(
                        child: PurchaseOrderStatusBadge(
                          status: purchaseOrder.status,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //
                  // client
                  Text(
                    clientName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.1,
                    ),
                  ),

                  //
                  // description preview (plain text, HTML stripped)
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      description.capitalizeFirst ?? description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.secondaryTextColor,
                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),
                  Divider(height: 1, color: context.hairlineBorderColor),
                  const SizedBox(height: 10),

                  //
                  // purchase date + created by, with the navigation indicator
                  Row(
                    children: [
                      Expanded(
                        child: _OrderMetadata(
                          purchaseDate:
                              purchaseOrder.purchaseDate.formatDateOrNA(),
                          createdBy: createdBy,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: context.tertiaryTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlideActions(BuildContext context) {
    final List<Widget> actions = [
      _buildSlidableAction(
        onPressed: () => controller.onCancelPurchaseClicked(purchaseOrder),
        label: 'Cancel'.tr,
        icon: Icons.highlight_remove_outlined,
        backgroundColor: context.brandColor,
        foregroundColor: Colors.white,
        isFirst: true,
        isLast: purchaseOrder.status == 'approved',
      ),
    ];

    if (purchaseOrder.status == 'pending') {
      actions.add(
        _buildSlidableAction(
          onPressed: () {
            debugPrint('Edit service order ${purchaseOrder.id}');
            Get.toNamed(
              Routes.CREATE_EDIT_PURCHASED_ORDER,
              arguments: purchaseOrder,
            );
          },
          label: 'Edit'.tr,
          icon: Icons.edit_outlined,
          backgroundColor: context.primaryTextColor,
          foregroundColor: context.backgroundColor,
          isLast: true,
        ),
      );
    }

    return actions;
  }

  Widget _buildSlidableAction({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return SlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: icon,
      label: label,
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(_radius) : Radius.zero,
        bottomLeft: isFirst ? const Radius.circular(_radius) : Radius.zero,
        topRight: isLast ? const Radius.circular(_radius) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(_radius) : Radius.zero,
      ),
      padding: const EdgeInsets.all(2),
    );
  }
}

/// Compact `PO-11` identifier chip.
class _OrderIdentifierBadge extends StatelessWidget {
  const _OrderIdentifierBadge({required this.orderNumber});

  final String orderNumber;

  @override
  Widget build(BuildContext context) {
    final Color accent = context.brandColor;

    return Semantics(
      label: 'Purchase order $orderNumber',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: accent.applyOpacity(context.isDark ? 0.18 : 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accent.applyOpacity(0.28)),
        ),
        child: Text(
          orderNumber,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color:
                    context.isDark ? Colors.white.applyOpacity(0.92) : accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
        ),
      ),
    );
  }
}

class _OrderMetadata extends StatelessWidget {
  const _OrderMetadata({required this.purchaseDate, required this.createdBy});

  final String purchaseDate;
  final String createdBy;

  static const double _minRowWidth = 260;
  static const double _maxRowTextScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final Widget date = PurchaseOrderMetadataRow(
      icon: Icons.event_outlined,
      label: 'Purchase date',
      value: purchaseDate,
    );
    final Widget creator = PurchaseOrderMetadataRow(
      icon: Icons.person_outline_rounded,
      label: 'Created by',
      value: createdBy,
    );

    final double textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool canSplit = constraints.maxWidth >= _minRowWidth &&
            textScale <= _maxRowTextScale;

        if (!canSplit) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [date, const SizedBox(height: 6), creator],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: date),
            const SizedBox(width: 12),
            Expanded(child: creator),
          ],
        );
      },
    );
  }
}

class PurchaseOrderMetadataRow extends StatelessWidget {
  const PurchaseOrderMetadataRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 15, color: context.tertiaryTextColor),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
