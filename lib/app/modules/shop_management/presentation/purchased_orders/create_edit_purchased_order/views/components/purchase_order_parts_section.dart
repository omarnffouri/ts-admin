import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../purchased_order_detail/views/components/purchase_order_details_empty_state.dart';
import '../../controllers/create_edit_purchased_order_controller.dart';
import 'purchase_order_form_section.dart';
import 'purchase_order_part_form_card.dart';

class PurchaseOrderPartsSection
    extends GetView<CreateEditPurchasedOrderController> {
  const PurchaseOrderPartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PurchaseOrderFormSection(
        icon: Icons.inventory_2_outlined,
        title: 'Vehicle Parts',
        action: controller.isEditEnabled.value
            ? PurchaseOrderSectionAction(
                icon: Icons.add_rounded,
                label: 'Add Part',
                semanticsLabel: 'Add part',
                tooltip: 'Add another vehicle part',
                onTap: () {
                  controller.addVehiclePartsField();
                  controller.purchasedPartKey.currentState?.insertItem(0);
                },
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The list keeps the first slot so its `GlobalKey` state is never
            // moved when the empty placeholder appears or disappears.
            AnimatedList(
              key: controller.purchasedPartKey,
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              initialItemCount: controller.purchasedParts.length,
              itemBuilder: (context, index, animation) {
                final CurvedAnimation curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                );

                return FadeTransition(
                  opacity: curved,
                  child: SizeTransition(
                    axis: Axis.vertical,
                    sizeFactor: curved,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PurchaseOrderPartFormCard(
                        key: ValueKey(controller.purchasedParts[index]),
                        index: index,
                        vehiclePart: controller.purchasedParts[index],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (controller.purchasedParts.isEmpty)
              const PurchaseOrderDetailsEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No parts added',
                message: 'Use "Add Part" to add a vehicle part to this order.',
              ),
          ],
        ),
      ),
    );
  }
}
