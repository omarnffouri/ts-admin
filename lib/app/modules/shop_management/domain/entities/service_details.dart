import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'service_dropdown_entity.dart';
import 'service_order_file.dart';
import 'shop_inventory_entity.dart';

class ServiceDetails {
  ServiceDetails({
    this.id,
    this.selectedMaintenanceType,
    this.selectedServiceType,
    this.selectedChargesType,
  });

  final Rxn<String> isPartRequired = Rxn<String>(null);
  final vehiclePartsKey = GlobalKey<AnimatedListState>();
  final vehiclePartFields = <VehiclePart>[].obs;
  Rxn<String>? id;
  final isEnabled = true.obs;
  Rxn<ServiceTypeEntity>? selectedMaintenanceType;
  Rxn<DataEntity>? selectedServiceType;
  Rxn<String>? selectedChargesType;

  final TextEditingController hoursController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController taxController = TextEditingController(text: "6");

  // file before service
  final RxList<ServiceOrderFile> filesBeforService = RxList(
    [ServiceOrderFile(isAdd: true)],
  );

  // file after service
  final RxList<ServiceOrderFile> filesAfterService = RxList(
    [ServiceOrderFile(isAdd: true)],
  );

  // service order files to be removed
  final RxList<int> filesBeforServiceToBeDeleted = RxList();
  final RxList<int> filesAfterServiceToBeDeleted = RxList();

  void addVehiclePartsField() {
    vehiclePartFields.insert(
      0,
      VehiclePart(
        id: Rxn<String>(null),
        selectedInventory: const ShopInventoryEntity(id: null),
        initialPartsRequired: 0,
        partsPrice: null,
      ),
    );

    debugPrint('vehiclePartFields length: ${vehiclePartFields.length}');
  }

  void removeVehiclePartsField(int index) {
    vehiclePartFields.removeAt(index);
    vehiclePartFields.refresh();
  }

  void clearTextControllers() {
    hoursController.clear();
    rateController.clear();
    mileageController.clear();
    taxController.clear();
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
