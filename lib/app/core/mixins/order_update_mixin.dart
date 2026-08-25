import 'package:get/get.dart';

import '../../modules/shop_management/domain/entities/purchase_order_entity.dart';
import '../../modules/shop_management/domain/entities/service_order_entity.dart';
import '../../modules/shop_management/presentation/purchased_orders/purchased_orders/controllers/purchased_orders_controller.dart';
import '../../modules/shop_management/presentation/service_orders/service_orders/controllers/service_orders_controller.dart';

// Mixin that can be used by multiple controllers
mixin OrderUpdateMixin {
  void syncServiceOrder({
    required String id,
    required ServiceOrderEntity updatedOrder,
  }) {
    final controller = Get.find<ServiceOrdersController>();
    final index = controller.serviceOrders.indexWhere(
      (element) => element.id.toString() == id,
    );

    if (index != -1) {
      controller.serviceOrders[index] = updatedOrder;
      controller.serviceOrders.refresh();
    }
  }

  void syncPurchaseOrder({
    required String id,
    required PurchaseOrderEntity updatedOrder,
  }) {
    final controller = Get.find<PurchasedOrdersController>();
    final index = controller.purchaseOrders.indexWhere(
      (element) => element.id.toString() == id,
    );

    if (index != -1) {
      controller.purchaseOrders[index] = updatedOrder;
      controller.purchaseOrders.refresh();
    }
  }
}
