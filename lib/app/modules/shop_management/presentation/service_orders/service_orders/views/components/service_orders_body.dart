import 'package:flutter/material.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/service_order_entity.dart';

import 'service_order_item_card.dart';

class ServiceOrdersBody extends StatelessWidget {
  const ServiceOrdersBody({super.key, required this.orders});

  final List<ServiceOrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
      sliver: SliverList.separated(
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => ServiceOrderCard(
          serviceOrder: orders[index],
        ),
      ),
    );
  }
}
