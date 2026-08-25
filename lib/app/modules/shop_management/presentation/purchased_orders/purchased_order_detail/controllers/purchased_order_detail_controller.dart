import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/mixins/order_update_mixin.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../domain/entities/purchase_order_entity.dart';
import '../../../../domain/usecases/used_part/change_purchase_order_status_usecase.dart';
import '../../../../domain/usecases/used_part/get_purchase_details_usecase.dart';

class PurchasedOrderDetailController extends GetxController
    with OrderUpdateMixin {
  //usecases
  final getPurchaseDetailsUsecase = sl<GetPurchaseDetailsUsecase>();
  final changePurchaseStatusUsecase = sl<ChangePurchaseOrderStatusUsecase>();

  // variables and State Management
  final RefreshController refreshController = RefreshController();
  final Rxn<PurchaseOrderEntity> purchasedOrder = Rxn<PurchaseOrderEntity>();

  final orderId = ''.obs;
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final statusToChange = ''.obs;
  final showUpdateButton = false.obs;

  @override
  void onInit() {
    super.onInit();

    final order = Get.arguments;
    if (order != null && order is PurchaseOrderEntity) {
      orderId.value = order.id.toString();
      init();
    }
  }

  Future<void> init() async {
    purchasedOrder.value = await getPurchaseOrderDetails(
      id: orderId.value.toString(),
    );
    final status = purchasedOrder.value?.status;
    showUpdateButton.value = status == 'pending' || status == 'approved';
    statusToChange.value = _getNextStatus(status);

    syncPurchaseOrder(
      id: purchasedOrder.value!.id.toString(),
      updatedOrder: purchasedOrder.value!,
    );
  }

  Future<PurchaseOrderEntity?> getPurchaseOrderDetails({
    required String id,
  }) async {
    try {
      final body = {'id': id};
      isLoading.value = true;
      final response = await getPurchaseDetailsUsecase(body);
      return response.fold(
        (success) => success,
        (failure) {
          Get.snackbar('Error', failure.message);
          return null;
        },
      );
    } catch (e) {
      debugPrint('Error $e');
      Get.snackbar('Error', 'An unexpected error occurred.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  String purchaseOrderValueOrNA(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return 'N/A';
    }
    return normalized;
  }

  String purchaseOrderNumberOrNA(int? value) => value?.toString() ?? 'N/A';

  String purchaseOrderPriceOrNA(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return 'N/A';
    }
    return normalized.dollar();
  }

  Future<void> changePurchaseOrderStatus() async {
    if (purchasedOrder.value == null) return;

    try {
      final body = {
        'id': purchasedOrder.value?.id.toString(),
        'status': statusToChange.value,
      };
      isUpdating.value = true;
      final response = await changePurchaseStatusUsecase.call(body);
      response.fold((result) async {
        // refresh the order details and update the order in the list
        await init();
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: 'Service Order Updated Successfully'.tr,
          isError: false,
        );
      }, (failure) {
        CommonWidgets.showSnackBar(title: ''.tr, message: failure.message);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> handleRefresh() async {
    await init();
    refreshController.refreshCompleted();
  }

  String _getNextStatus(String? status) {
    if (status == null) return '';
    return switch (status) {
      'pending' => 'approved',
      'approved' => 'completed',
      _ => '',
    };
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
