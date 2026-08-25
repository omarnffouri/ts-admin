import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../controllers/shop_suppliers_controller.dart';
import 'supplier_item_card.dart';

class ShopSuppliersBody extends GetView<ShopSuppliersController> {
  const ShopSuppliersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final suppliers = controller.filterList;
        return SlidableAutoCloseBehavior(
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
            itemCount: suppliers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _CardEntrance(
              index: index,
              child: SupplierCard(supplier: suppliers[index]),
            ),
          ),
        );
      },
    );
  }
}

/// Subtle fade + slide-up reveal, lightly staggered for the first few cards.
class _CardEntrance extends StatelessWidget {
  const _CardEntrance({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + index.clamp(0, 6) * 50),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
