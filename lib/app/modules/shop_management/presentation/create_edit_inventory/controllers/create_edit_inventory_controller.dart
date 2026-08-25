import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/shop_inventory_entity.dart';
import '../../../domain/entities/supplier_entity.dart';
import '../../../domain/usecases/create_inventory.dart';
import '../../../domain/usecases/edit_inventory.dart';
import '../../../domain/usecases/get_all_suppliers.dart';
import '../../../domain/usecases/used_part/create_used_inventory_usecase.dart';
import '../../../domain/usecases/used_part/edit_used_inventory_usecase.dart';
import '../../../domain/usecases/used_part/get_all_used_suppliers_usecase.dart';
import '../../shop_inventories/controllers/shop_inventories_controller.dart';

class CreateEditInventoryController extends GetxController {
  // usecase
  final getAllSuppliersUsecase = sl<GetAllSuppliersUsecase>();
  final createInventoryUsecase = sl<CreateInventoryUsecase>();
  final editInventoryUsecase = sl<EditInventoryUsecase>();
  //- used part
  final getAllUsedSuppliersUsecase = sl<GetAllUsedSuppliersUsecase>();
  final createUsedInventoryUsecase = sl<CreateUsedInventoryUsecase>();
  final editUsedInventoryUsecase = sl<EditUsedInventoryUsecase>();

  // form key and text controller
  final formKey = GlobalKey<FormState>();
  TextEditingController itemNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController markupPriceController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  // variables
  RxList<SupplierEntity> supplierList = RxList();
  final Rxn<SupplierEntity> selectedSupplier = Rxn();

  final RxBool _isLoading = false.obs;
  bool get isLoadingDropdownValues => _isLoading.value;
  final RxBool isSubmitting = false.obs;

  final total = '0.0'.obs;

  // inventory entity
  final inventoryEntity = Rxn<ShopInventoryEntity>();
  final isUpdating = false.obs;
  final isUsedPart = false.obs;

  RxString get getTotal =>
      quantityController.text == '' || buyPriceController.text == ''
          ? '0.0'.obs
          : (double.parse(quantityController.text) *
                  double.parse(buyPriceController.text))
              .toString()
              .obs;

  // Helper function to calculate the total with tax
  String _calculateTotal() {
    if (quantityController.text.isEmpty || buyPriceController.text.isEmpty) {
      return '0.0';
    }
    double quantity = double.tryParse(quantityController.text) ?? 0.0;
    double price = double.tryParse(buyPriceController.text) ?? 0.0;
    double subTotal = quantity * price;

    // Calculate total with tax
    double tax = double.tryParse(taxController.text) ?? 0.0;
    double totalWithTax = subTotal + (subTotal * (tax / 100));
    return totalWithTax.toStringAsFixed(2);
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('CreateInventoryController onInit');
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      isUsedPart.value = arguments['isUsedPart'] ?? false;
      // if get arguments is not null, then set the supplier entity
      final inventory = Get.arguments['inventory'];
      if (inventory != null && inventory is ShopInventoryEntity) {
        inventoryEntity.value = inventory;
        isUpdating.value = true;
        // set the text controllers from the supplier entity
        _setTextControllers(inventory);
        total.value = _calculateTotal();
      }
    }

    getAllSuppliers(isUsedPart: isUsedPart.value);

    quantityController.addListener(() {
      total.value = _calculateTotal();
    });

    buyPriceController.addListener(() {
      total.value = _calculateTotal();
      sellPriceController.text = _calculateSellingPrice();
    });

    taxController.addListener(() {
      total.value = _calculateTotal();
      sellPriceController.text = _calculateSellingPrice();
    });

    markupPriceController.addListener(() {
      sellPriceController.text = _calculateSellingPrice();
    });
  }

  void _setTextControllers(ShopInventoryEntity inventory) {
    itemNumberController.text = inventory.itemNumber ?? '';
    itemNameController.text = inventory.itemName ?? '';
    quantityController.text = inventory.quantity.toString();
    buyPriceController.text = inventory.buyingPrice ?? '';
    markupPriceController.text = inventory.markupPrice ?? '';
    sellPriceController.text = inventory.sellingPrice ?? '';
    taxController.text = inventory.purchaseTax ?? '';
    totalController.text = inventory.total ?? '';
    selectedSupplier.value = inventory.supplier;
  }

  Future<void> getAllSuppliers({bool isUsedPart = false}) async {
    try {
      _isLoading.value = true;
      final result = isUsedPart
          ? await getAllUsedSuppliersUsecase.call(const NoParams())
          : await getAllSuppliersUsecase.call({});
      result.fold(
        (list) {
          debugPrint('supplierList: ${list.length}');
          supplierList.value = list;
        },
        (e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
        },
      );
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  Future<void> createOrEditInventory() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    isSubmitting.value = true;
    try {
      final body = {
        "supplier_id": selectedSupplier.value?.id,
        "item_number": itemNumberController.text,
        "item_name": itemNameController.text,
        "buying_price": buyPriceController.text,
        "selling_price": _calculateSellingPrice(),
        "purchase_tax": taxController.text,
        "markup_price": markupPriceController.text,
        "quantity": quantityController.text,
      };

      // If updating, include the inventory ID
      if (isUpdating.value && inventoryEntity.value?.id != null) {
        body["id"] = inventoryEntity.value!.id.toString();
      }

      final result = isUpdating.value
          ? (isUsedPart.value
              ? await editUsedInventoryUsecase.call(body)
              : await editInventoryUsecase.call(body))
          : (isUsedPart.value
              ? await createUsedInventoryUsecase.call(body)
              : await createInventoryUsecase.call(body));

      result.fold(
        (bool success) {
          if (success) {
            CommonWidgets.showSnackBar(
              title: 'Success',
              message: isUpdating.value
                  ? 'Inventory updated successfully'.tr
                  : 'Inventory created successfully'.tr,
              isError: false,
            );
            Navigator.of(Get.context!).pop();
            Get.put(ShopInventoriesController()).getAllShopInventories(
              isUsedPart: isUsedPart.value,
            );
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error',
              message: isUpdating.value
                  ? 'Failed to update Inventory'.tr
                  : 'Failed to create Inventory'.tr,
            );
          }
        },
        (Failure e) {
          CommonWidgets.showSnackBar(
            title: 'Error',
            message: e.toString(),
          );
        },
      );
      isSubmitting.value = false;
    } catch (e) {
      isSubmitting.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  // Helper function to calculate the selling price with tax
  String _calculateSellingPrice() {
    if (buyPriceController.text.isEmpty ||
        taxController.text.isEmpty ||
        markupPriceController.text.isEmpty) {
      return '0.0';
    }

    double buyingPrice = double.tryParse(buyPriceController.text) ?? 0.0;
    double taxPercentage = double.tryParse(taxController.text) ?? 0.0;
    double markupPrice = double.tryParse(markupPriceController.text) ?? 0.0;

    //
    // caluculate taxed buying price
    double buyingTax = 0.0;
    if (taxPercentage > 0) {
      buyingTax = (buyingPrice * taxPercentage / 100);
    }

    final taxedBuyingPrice = buyingPrice + buyingTax;

    final sellingTax = taxedBuyingPrice * markupPrice / 100;

    return (taxedBuyingPrice + sellingTax).toStringAsFixed(2);
  }

  @override
  void onClose() {
    itemNumberController.dispose();
    itemNameController.dispose();
    quantityController.dispose();
    buyPriceController.dispose();
    sellPriceController.dispose();
    taxController.dispose();
    totalController.dispose();
    super.onClose();
  }
}
