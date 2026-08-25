import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../domain/entities/shop_inventory_entity.dart';
import '../../controllers/shop_inventories_controller.dart';

class InventoryItemCard extends GetView<ShopInventoriesController> {
  const InventoryItemCard({super.key, required this.shopInventory});

  final ShopInventoryEntity shopInventory;

  static const double _radius = 18;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isActive = shopInventory.isActive == true;

    return Slidable(
      key: ValueKey(shopInventory.id),
      closeOnScroll: true,
      groupTag: 'inventory_listing_slide_group',
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                controller.onDisableInventoryCicked(shopInventory),
            backgroundColor: context.brandColor,
            foregroundColor: Colors.white,
            icon: isActive
                ? Icons.remove_shopping_cart_outlined
                : Icons.add_shopping_cart_outlined,
            label: isActive ? 'Disable'.tr : 'Enable'.tr,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            padding: const EdgeInsets.all(2),
          ),
          SlidableAction(
            onPressed: (_) {
              final arg = {
                'inventory': shopInventory,
                'isUsedPart': controller.isUsedPart.value,
              };
              Get.toNamed(Routes.CREATE_EDIT_INVENTORY, arguments: arg);
            },
            backgroundColor: context.primaryTextColor,
            foregroundColor: context.backgroundColor,
            icon: Icons.edit_outlined,
            label: 'Update'.tr,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
            ),
            padding: const EdgeInsets.all(2),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.tileColor,
          borderRadius: BorderRadius.circular(_radius),
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
                Expanded(
                  child: _ItemNumberBadge(number: shopInventory.itemNumber),
                ),
                const SizedBox(width: 10),
                _StatusChip(isActive: isActive),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              shopInventory.itemName ?? 'N/A',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatChip(
                  label: 'Req'.tr,
                  value: shopInventory.requestedCount ?? '0',
                  color: _warningColor(context),
                ),
                _StatChip(
                  label: 'Sold'.tr,
                  value: shopInventory.soldCount ?? '0',
                  color: _successColor(context),
                ),
                _StatChip(
                  label: 'Qty'.tr,
                  value: '${shopInventory.quantity}',
                  color: context.secondaryTextColor,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _PriceGrid(shopInventory: shopInventory),
            const SizedBox(height: 12),
            Divider(height: 1, color: context.hairlineBorderColor),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _FooterInfo(
                    icon: Icons.storefront_outlined,
                    text: shopInventory.supplier?.name ?? 'N/A',
                  ),
                ),
                const SizedBox(width: 12),
                _FooterInfo(
                  icon: Icons.event_outlined,
                  text: shopInventory.createdAt?.formatDateOrNA() ?? 'N/A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color _successColor(BuildContext context) =>
    context.isDark ? Colors.green.shade300 : Colors.green.shade700;

Color _warningColor(BuildContext context) =>
    context.isDark ? Colors.orange.shade300 : Colors.orange.shade800;

class _ItemNumberBadge extends StatelessWidget {
  const _ItemNumberBadge({required this.number});

  final String? number;

  @override
  Widget build(BuildContext context) {
    final String value = number?.trim() ?? '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color:
                context.brandColor.applyOpacity(context.isDark ? 0.18 : 0.09),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            Icons.qr_code_2_rounded,
            size: 16,
            color: context.isDark
                ? Colors.white.applyOpacity(0.85)
                : context.brandColor,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value.isEmpty ? 'N/A' : '#$value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        isActive ? _successColor(context) : Theme.of(context).colorScheme.error;
    final String label = isActive ? 'Active'.tr : 'Inactive'.tr;

    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: foreground.applyOpacity(context.isDark ? 0.18 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: foreground.applyOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.applyOpacity(context.isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.applyOpacity(0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceGrid extends StatelessWidget {
  const _PriceGrid({required this.shopInventory});

  final ShopInventoryEntity shopInventory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PriceCell(
            label: 'Buying'.tr,
            value: shopInventory.buyingPrice?.twoDigits().dollar() ?? 'N/A',
          ),
          _PriceCell(
            label: 'Selling'.tr,
            value: shopInventory.sellingPrice?.twoDigits().dollar() ?? 'N/A',
          ),
          _PriceCell(
            label: 'Tax (%)'.tr,
            value: shopInventory.purchaseTax ?? 'N/A',
          ),
          _PriceCell(
            label: 'Total'.tr,
            value: shopInventory.total?.dollar() ?? 'N/A',
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _PriceCell extends StatelessWidget {
  const _PriceCell({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: context.tertiaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: emphasized
                  ? textTheme.bodyMedium?.copyWith(
                      color: context.brandColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    )
                  : textTheme.bodySmall?.copyWith(
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  const _FooterInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.tertiaryTextColor),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
