import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/mixins/order_update_mixin.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../domain/entities/client_entity.dart';
import '../../../../domain/entities/purchase_order_entity.dart';
import '../../../../domain/entities/shop_inventory_entity.dart';
import '../../../../domain/usecases/used_part/create_purchase_order_usecase.dart';
import '../../../../domain/usecases/used_part/edit_purchase_order_usecase.dart';
import '../../../shop_clients/controllers/shop_clients_controller.dart';
import '../../../shop_inventories/controllers/shop_inventories_controller.dart';
import '../../purchased_order_detail/controllers/purchased_order_detail_controller.dart';
import '../../purchased_orders/controllers/purchased_orders_controller.dart';

class CreateEditPurchasedOrderController extends GetxController
    with OrderUpdateMixin {
  // usecase
  final createPurchaseOrderUsecase = sl<CreatePurchaseOrderUsecase>();
  final editPurchaseOrderUsecase = sl<EditPurchaseOrderUsecase>();

  // keys and controllers
  final formKey = GlobalKey<FormState>();
  final refreshController = RefreshController();
  final purchasedPartKey = GlobalKey<AnimatedListState>();

  // variables
  final usedPartClients = RxList<ClientEntity>();
  final inventories = RxList<ShopInventoryEntity>();
  final purchaseOrderEntity = Rxn<PurchaseOrderEntity>();
  final selectedClient = Rxn<ClientEntity>(null);

  // purchase details
  final purchasedParts = <VehiclePart>[].obs;

  // Text Controllers for input fields
  final dateController = TextEditingController();
  final completionDateController = TextEditingController();
  final orderNumberController = TextEditingController();
  final htmlController = QuillController.basic();

  // loading state
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isSubmitting = false.obs;
  final isEditEnabled = true.obs;

  bool _validateServiceDetail(VehiclePart detail, int index) {
    if (purchasedParts.any((part) => part.selectedInventory.value.id == null)) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select an inventory item for service ${index + 1}'.tr,
      );
      return false;
    }

    return true;
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    // Check if the date is selected
    if (dateController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a order date'.tr,
      );
      return false;
    }

    // Check if the client is selected
    if (selectedClient.value == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a Client'.tr,
      );
      return false;
    }

    // Check if the number of parts is valid
    for (var i = 0; i < purchasedParts.length; i++) {
      if (!_validateServiceDetail(purchasedParts[i], i)) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments == null) {
      addVehiclePartsField();
    }
    if (Get.arguments != null) {
      isUpdating.value = true;
    }
    await loadData();
    final purchaseOrder = Get.arguments;
    if (purchaseOrder != null && purchaseOrder is PurchaseOrderEntity) {
      purchaseOrderEntity.value = purchaseOrder;
      _setTextControllers(purchaseOrder);
    }
  }

  Future<void> _setTextControllers(PurchaseOrderEntity purchaseOrder) async {
    selectedClient.value = purchaseOrder.client;
    dateController.text = purchaseOrder.purchaseDate.toString().cleanDateOnly();
    orderNumberController.text = purchaseOrder.orderNumber.toString();
    try {
      final html = HtmlToDelta().convert(purchaseOrder.description ?? '');
      htmlController.document = Document.fromDelta(html);
      FocusScope.of(Get.overlayContext!).unfocus();
    } catch (_) {}

    purchasedParts.clear();
    if (purchaseOrder.vehicleParts.isNotEmpty) {
      for (var part in purchaseOrder.vehicleParts) {
        // final ShopInventoryEntity? inventory = inventories.firstWhereOrNull(
        //   (element) =>
        //       element.id.toString().trim() ==
        //       part.usedShopInventoryId.toString().trim(),
        // );
        // if (inventory == null) {
        //   debugPrint('Inventory not found for ID: ${part.usedShopInventoryId}');
        //   continue;
        // }
        final newVehiclePart = VehiclePart(
          selectedInventory: ShopInventoryEntity(
            id: part.usedShopInventoryId,
            itemName: part.itemName,
            itemNumber: part.itemNumber,
            quantity: part.numberOfPartsAvailable ?? 0,
            requestedCount: part.numberOfPartsAvailable.toString(),
            sellingPrice: part.partPrice.toString(),
            total: part.totalPrice.toString(),
          ),
          id: Rxn<String>(part.id.toString()),
          initialPartsRequired: part.numberOfPartsRequired ?? 0,
          partsPrice: num.tryParse(part.partPrice.toString()) ?? 0,
        );

        newVehiclePart.updatePartsToBePurchased();
        purchasedParts.add(newVehiclePart);
        purchasedPartKey.currentState?.insertItem(
          0,
          duration: const Duration(milliseconds: 500),
        );
        purchasedParts.refresh();
      }
    }

    // Assign is enabled
    isEditEnabled.value = purchaseOrder.isPending();
  }

  Future<void> submitServiceOrder() async {
    // Validate the form
    if (!_validateForm()) return;

    try {
      Map<String, dynamic> body = _getServiceFormData();

      debugPrint('Submitting data: ${body.toString()}');
      isSubmitting(true);
      final response = isUpdating.value
          ? await editPurchaseOrderUsecase.call(body)
          : await createPurchaseOrderUsecase.call(body);
      response.fold((result) async {
        // update the service order list
        if (isUpdating.value) {
          await updateOrderDetails();
        } else {
          await Get.find<PurchasedOrdersController>().getAllPurchaseOrders();
        }

        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: isUpdating.value
              ? 'Purchase Order Updated Successfully'.tr
              : 'Purchase Order Created Successfully'.tr,
          isError: false,
        );
        Navigator.pop(Get.context!);
      }, (failure) {
        //
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  Map<String, dynamic> _getServiceFormData() {
    final body = {
      "purchase_date": dateController.text,
      "used_part_shop_client_id": selectedClient.value?.id,
      'description': DeltaToHTML.encodeJson(
        htmlController.document.toDelta().toJson(),
      ),
    };
    if (isUpdating.value) {
      body['id'] = purchaseOrderEntity.value?.id;
    }
    // Add vehicle parts
    final vehicleParts = <Map<String, dynamic>>[];
    for (var part in purchasedParts) {
      final inventory = part.selectedInventory.value;
      if (inventory.id == null) continue;

      final partMap = {
        "used_shop_inventory_id": inventory.id,
        "number_of_parts_required": part.numPartsRequired.value,
        "number_of_parts_available": part.quantity.value,
        "parts_to_be_purchased": part.partsToBePurchased.value,
        "part_price": part.partsPrice,
        "total_price": part.totalPrice.value,
      };

      if (part.id != null &&
          part.id?.value != null &&
          part.id?.value != 'null') {
        partMap["id"] = part.id?.value.toString();
      }
      vehicleParts.add(partMap);
    }
    body['vehicleParts'] = vehicleParts;
    return body;
  }

  Future<void> updateOrderDetails() async {
    final detailsController = Get.isRegistered<PurchasedOrderDetailController>()
        ? Get.find<PurchasedOrderDetailController>()
        : Get.put(PurchasedOrderDetailController());

    final serviceOrderId = purchaseOrderEntity.value!.id.toString();
    final updatedOrder = await detailsController.getPurchaseOrderDetails(
      id: serviceOrderId,
    );

    if (updatedOrder != null) {
      syncPurchaseOrder(
        id: purchaseOrderEntity.value!.id.toString(),
        updatedOrder: updatedOrder,
      );

      detailsController.purchasedOrder.value = updatedOrder;
      detailsController.purchasedOrder.refresh();
    }
  }

  Future<void> handleRefresh() async {
    await loadData();
    refreshController.refreshCompleted();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await Future.wait([
      loadingUsedPartClients(),
      loadingShopInventories(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadingUsedPartClients() async {
    usedPartClients.clear();
    final controller = Get.put(ShopClientsController(), tag: 'purchase');
    usedPartClients.value = await controller.getAllClients(
      isUsedPart: true,
    );
    Get.delete<ShopClientsController>(tag: 'purchase');
  }

  Future<void> loadingShopInventories() async {
    inventories.clear();
    final controller = Get.put(ShopInventoriesController(), tag: 'purchase');
    inventories.value = await controller.getAllShopInventories(
      isUsedPart: true,
    );
    Get.delete<ShopInventoriesController>(tag: 'purchase');
  }

  void addVehiclePartsField() {
    purchasedParts.insert(
      0,
      VehiclePart(
        id: Rxn<String>(null),
        selectedInventory: const ShopInventoryEntity(id: null),
        initialPartsRequired: 0,
        partsPrice: null,
      ),
    );

    debugPrint('vehiclePartFields length: ${purchasedParts.length}');
  }

  void removeVehiclePartsField(int index) {
    purchasedParts.removeAt(index);
    purchasedParts.refresh();
  }

  @override
  void onClose() {
    disposeAll();
    super.onClose();
  }

  void disposeAll() {
    dateController.dispose();
    completionDateController.dispose();
    orderNumberController.dispose();
    htmlController.dispose();
  }
}

class VehiclePart {
  Rxn<String>? id;
  final Rx<ShopInventoryEntity> selectedInventory;
  final RxInt numPartsRequired;
  final RxInt partsToBePurchased;
  num? partsPrice;

  VehiclePart({
    this.id,
    required ShopInventoryEntity selectedInventory,
    int initialPartsRequired = 0,
    this.partsPrice,
  })  : selectedInventory = selectedInventory.obs,
        numPartsRequired = initialPartsRequired.obs,
        partsToBePurchased = 0.obs;

  // Get the available quantity from inventory
  RxInt get quantity => selectedInventory.value.quantity.obs;

  // Get the buying price from inventory
  RxString get price => selectedInventory.value.sellingPrice?.obs ?? "0".obs;

  // Calculate total price based on parts required and buying price
  RxString get totalPrice =>
      (numPartsRequired.value * num.parse(price.value)).toStringAsFixed(2).obs;

  // Update parts to be purchased based on required and available
  void updatePartsToBePurchased() {
    final requiredParts = numPartsRequired.value;
    final availableInventory = quantity;

    if (requiredParts > availableInventory.value) {
      partsToBePurchased.value = requiredParts - availableInventory.value;
    } else {
      partsToBePurchased.value = 0;
    }
  }
}
