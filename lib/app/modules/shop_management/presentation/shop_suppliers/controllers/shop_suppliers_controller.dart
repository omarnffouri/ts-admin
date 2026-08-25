import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/supplier_entity.dart';
import '../../../domain/usecases/disable_supplier.dart';
import '../../../domain/usecases/get_all_suppliers.dart';
import '../../../domain/usecases/used_part/disable_used_supplier_usecase.dart';
import '../../../domain/usecases/used_part/get_all_used_suppliers_usecase.dart';
import '../../components/confirmation_bottom_sheet.dart';

class ShopSuppliersController extends GetxController
    with GetTickerProviderStateMixin {
  // usecase
  final getAllSuppliersUsecase = sl<GetAllSuppliersUsecase>();
  final disableSupplierUsecase = sl<DisableSupplierUsecase>();
  //- used part
  final getAllUsedSuppliersUsecase = sl<GetAllUsedSuppliersUsecase>();
  final disableUsedSupplierUsecase = sl<DisableUsedSupplierUsecase>();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();
  late final AnimationController searchExpandedController;
  final TextEditingController txtSearchController = TextEditingController();

  // loading state and variables
  final RxList<SupplierEntity> supplierList = RxList();
  final RxBool isLoading = false.obs;
  final RxBool deletingSupplier = false.obs;
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

    debugPrint('ShopSuppliersController onInit');
    getAllSuppliers(isUsedPart: isUsedPart.value);
    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    txtSearchController.addListener(() {
      txtSearch.value = txtSearchController.text;
      debugPrint('Search: ${txtSearchController.text}');
    });
  }

  // load all suppliers
  Future<void> getAllSuppliers({bool isUsedPart = false}) async {
    try {
      isLoading.value = true;
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
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  Future<void> onDisableSupplierCicked(SupplierEntity supplier) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          title: supplier.isActive == true
              ? 'Disable Supplier ?'
              : 'Enable Supplier ?',
          name: supplier.name ?? "",
          isLoading: deletingSupplier,
          confirmText: supplier.isActive == true ? 'Disable ' : 'Enable ',
          confirmTextBtn: supplier.isActive == true ? 'Disable' : 'Enable',
          onConfirm: () {
            disableSupplier(supplier);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> disableSupplier(SupplierEntity supplier) async {
    if (deletingSupplier.value) {
      return;
    }

    deletingSupplier.value = true;
    final isActive = supplier.isActive;
    final body = {
      'id': supplier.id,
      'status': isActive == true ? 'inactive' : 'active',
    };

    try {
      final result = isUsedPart.value
          ? await disableUsedSupplierUsecase.call(body)
          : await disableSupplierUsecase.call(body);
      result.fold(
        (success) {
          if (success) {
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message:
                  'Supplier ${isActive == true ? 'Disabled' : 'Enabled'} successfully',
              isError: false,
            );
            // todo check if this is needed
            Navigator.pop(Get.context!);
            getAllSuppliers(isUsedPart: isUsedPart.value);
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to update the supplier'.tr,
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
      deletingSupplier.value = false;
    } catch (e) {
      deletingSupplier.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  // handle refresh
  Future<void> handleRefresh() async {
    await getAllSuppliers(isUsedPart: isUsedPart.value);
    refreshController.refreshCompleted();
  }

  RxList<SupplierEntity> get filterList {
    //no search
    if (txtSearch.isEmpty) {
      return supplierList;
      // search applied
    } else {
      return supplierList
          .where((element) =>
              element.name
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
