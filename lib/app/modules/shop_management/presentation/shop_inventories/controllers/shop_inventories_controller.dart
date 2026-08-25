import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/shop_inventory_entity.dart';
import '../../../domain/usecases/disable_inventory.dart';
import '../../../domain/usecases/get_all_shop_inventories.dart';
import '../../../domain/usecases/used_part/disable_used_inventory_usecase.dart';
import '../../../domain/usecases/used_part/get_all_used_inventories_usecase.dart';
import '../../components/confirmation_bottom_sheet.dart';

class ShopInventoriesController extends GetxController
    with GetTickerProviderStateMixin {
  // usecases
  final getAllShopInvetoriesUsecase = sl<GetAllShopInvetoriesUsecase>();
  final disableInventoryUsecase = sl<DisableInventoryUsecase>();
  //- used part
  final getAllUsedInventoriesUsecase = sl<GetAllUsedInventoriesUsecase>();
  final disableUsedInventoryUsecase = sl<DisableUsedInventoryUsecase>();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();
  late final AnimationController searchExpandedController;
  final TextEditingController txtSearchController = TextEditingController();

// loading state and variables
  final shopInventoriees = <ShopInventoryEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool disablingInventory = false.obs;
  final RxBool isSearchEnabled = false.obs;
  final txtSearch = ''.obs;
  final isUsedPart = false.obs;

  @override
  void onInit() {
    super.onInit();

    final usedPart = Get.arguments;
    if (usedPart != null && usedPart is bool) {
      isUsedPart.value = usedPart;
    }
    debugPrint('ShopInventoriesController onInit');
    getAllShopInventories(isUsedPart: isUsedPart.value);
    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    txtSearchController.addListener(() {
      txtSearch.value = txtSearchController.text;
      debugPrint('Search: ${txtSearchController.text}');
    });
  }

  Future<List<ShopInventoryEntity>> getAllShopInventories({
    bool isUsedPart = false,
  }) async {
    filterList.clear();
    try {
      isLoading(true);
      final response = isUsedPart
          ? await getAllUsedInventoriesUsecase.call(const NoParams())
          : await getAllShopInvetoriesUsecase.call(const NoParams());
      return response.fold((response) {
        debugPrint('ShopInventories: ${response.length}');
        shopInventoriees.value = response;
        return response;
      }, (failure) {
        Get.snackbar('Error', failure.message);
        return [];
      });
    } catch (e) {
      debugPrint('Error $e');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleRefresh() async {
    await getAllShopInventories(isUsedPart: isUsedPart.value);
    refreshController.refreshCompleted();
  }

  Future<void> onDisableInventoryCicked(ShopInventoryEntity shop) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          name: shop.itemName ?? "",
          title: shop.isActive == true
              ? 'Disable Inventory ?'
              : 'Enable Inventory ?',
          isLoading: disablingInventory,
          confirmText: shop.isActive == true ? 'Disable ' : 'Enable ',
          confirmTextBtn: shop.isActive == true ? 'Disable' : 'Enable',
          onConfirm: () {
            disableInventory(shop);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> disableInventory(ShopInventoryEntity shop) async {
    if (disablingInventory.value) {
      return;
    }

    disablingInventory.value = true;

    try {
      final isActive = shop.isActive;
      final body = {
        'id': shop.id,
        'status': isActive == true ? 'inactive' : 'active',
      };
      final result = isUsedPart.value
          ? await disableUsedInventoryUsecase.call(body)
          : await disableInventoryUsecase.call(body);
      result.fold(
        (success) {
          if (success) {
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message:
                  'Inventory ${isActive == true ? 'Disabled' : 'Enabled'} successfully'
                      .tr,
              isError: false,
            );
            // todo check if this is needed
            Navigator.pop(Get.context!);
            getAllShopInventories(isUsedPart: isUsedPart.value);
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to update the Inventory'.tr,
            );
          }
        },
        (e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      disablingInventory.value = false;
    }
  }

  RxList<ShopInventoryEntity> get filterList {
    // no filter no search
    if (txtSearch.isEmpty) {
      return shopInventoriees;
      // filter no search
    } else {
      return shopInventoriees
          .where((element) =>
              element.itemName
                  ?.toLowerCase()
                  .contains(txtSearch.value.toLowerCase()) ??
              false)
          .toList()
          .obs;
    }
  }

  @override
  void onClose() {
    try {
      txtSearchController.dispose();
    } catch (e) {
      debugPrint("Controller already disposed: $e");
    }
    super.onClose();
  }
}
