import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/mixins/order_update_mixin.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../domain/entities/service_order_entity.dart';
import '../../../../domain/usecases/change_service_order_status.dart';
import '../../../../domain/usecases/get_all_service_orders.dart';
import '../../../../domain/usecases/resubmit_service_order.dart';
import '../../../components/cancel_bottom_sheet.dart';
import '../../../components/confirmation_bottom_sheet.dart';
import '../../service_order_details/controllers/service_order_details_controller.dart';
import '../views/components/service_order_filters_bottom_sheet.dart';

class ServiceOrdersController extends GetxController
    with GetTickerProviderStateMixin, OrderUpdateMixin {
  // body refresh controllers
  final RefreshController refreshController = RefreshController();
  late final AnimationController searchExpandedController;

  // usecases
  final getAllServiceOrdersUsecase = sl<GetAllServiceOrdersUsecase>();
  final changeServiceOrderStatusUsecase = sl<ChangeServiceOrderStatusUsecase>();
  final resubmitServiceOrderUsecase = sl<ResubmitServiceOrderUsecase>();

// loading state and variables
  final serviceOrders = <ServiceOrderEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;
  final RxBool isResubmitting = false.obs;
  final RxBool isSearchEnabled = false.obs;
  final RxnString errorMessage = RxnString();
  final txtSearch = ''.obs;

  // filter variables and search
  final TextEditingController txtSearchController = TextEditingController();
  final TextEditingController reasonTxtController = TextEditingController();
  final selectedStatus = 'All'.obs;
  final statusOption = <String>{
    'All',
    'pending_confirmation',
    'shop_pending',
    'shop_in_process',
    'shop_done',
    'approved',
    'rejected',
    'cancelled',
  }.obs;
  final selectedCategory = 'All'.obs;
  final categoryOption = <String>{}.obs;
  final selectedServiceType = 'All'.obs;
  final serviceTypeOption = <String>{}.obs;
  final selectedMaintenanceType = 'All'.obs;
  final maintenanceTypeOption = <String>{}.obs;

  RxBool get isAnyFilterSelected => (selectedMaintenanceType.value != 'All' ||
          selectedServiceType.value != 'All' ||
          selectedCategory.value != 'All' ||
          selectedStatus.value != 'All')
      .obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('ShopOrdersController onInit');
    getAllServiceOrders();
    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    txtSearchController.addListener(() {
      txtSearch.value = txtSearchController.text;
      debugPrint('Search: ${txtSearchController.text}');
    });
  }

  Future<void> getAllServiceOrders() async {
    txtSearchController.clear();
    try {
      isLoading(true);
      errorMessage.value = null;
      final response = await getAllServiceOrdersUsecase.call(const NoParams());
      response.fold((response) {
        debugPrint('ServiceOrders: ${response.length}');
        serviceOrders.value = response;

        // add category options
        categoryOption.add('All');
        categoryOption.addAll(response.map((e) => e.category!));
        categoryOption.refresh();

        // add service type options
        serviceTypeOption.add('All');
        serviceTypeOption.addAll(
          response
              .expand((e) => (e.serviceDetails as List<dynamic>? ?? [])
                  .cast<ServiceDetailEntity>())
              .map((detail) => detail.serviceTypeTitle)
              .whereType<String>(),
        );
        serviceTypeOption.refresh();

        // add maintenance type options
        maintenanceTypeOption.add('All');
        maintenanceTypeOption.addAll(
          response
              .expand((e) => (e.serviceDetails as List<dynamic>? ?? [])
                  .cast<ServiceDetailEntity>())
              .map((detail) => detail.maintenanceTypeTitle)
              .whereType<String>(),
        );
        maintenanceTypeOption.refresh();
      }, (failure) {
        errorMessage.value = failure.message.isNotEmpty
            ? failure.message
            : 'Unable to load service orders.';
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
      errorMessage.value = 'Unable to load service orders.';
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleRefresh() async {
    await getAllServiceOrders();
    refreshController.refreshCompleted();
  }

  Future<void> onResubmitServiceClicked(ServiceOrderEntity service) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          name: "Service Order (${service.serviceOrderNumber})",
          title: 'Resubmit Service Order ?',
          confirmText: 'Resubmit',
          confirmTextBtn: 'Resubmit',
          isLoading: isResubmitting,
          onConfirm: () {
            resubmitServiceOrder(service);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> resubmitServiceOrder(ServiceOrderEntity order) async {
    if (isResubmitting.value) {
      return;
    }

    final body = {
      'id': order.id,
    };

    isResubmitting.value = true;

    try {
      final result = await resubmitServiceOrderUsecase.call(body);
      result.fold(
        (success) async {
          if (success) {
            reasonTxtController.clear();
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: 'Service Order Resubmitted successfully'.tr,
              isError: false,
            );
            await updateOrderDetails(order.id.toString());
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to resubmit the Service Order'.tr,
            );
          }
        },
        (e) {
          CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    } finally {
      isResubmitting.value = false;
      Navigator.pop(Get.context!);
    }
  }

  Future<void> onCancelServiceClicked(ServiceOrderEntity service) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return CancelBottomSheet(
          name: "Service Order (${service.serviceOrderNumber})",
          title: 'Cancel Service Order ?',
          isLoading: isCancelling,
          reasonController: reasonTxtController,
          onCancel: () {
            cancellServiceOrder(service);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> cancellServiceOrder(ServiceOrderEntity order) async {
    if (isCancelling.value) {
      return;
    }

    final body = {
      'id': order.id,
      'status': 'cancelled',
      'reason': reasonTxtController.text,
    };

    isCancelling.value = true;

    try {
      final result = await changeServiceOrderStatusUsecase.call(body);
      result.fold(
        (success) async {
          if (success) {
            reasonTxtController.clear();
            await updateOrderDetails(order.id.toString());
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: 'Service Order Cancelled successfully'.tr,
              isError: false,
            );
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to cancel the Service Order'.tr,
            );
          }
        },
        (e) {
          CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    } finally {
      isCancelling.value = false;
      Navigator.pop(Get.context!);
    }
  }

  Future<void> updateOrderDetails(String id) async {
    final detailsController =
        Get.isRegistered<ServiceOrderDetailsController>(tag: id)
            ? Get.find<ServiceOrderDetailsController>(tag: id)
            : Get.put(ServiceOrderDetailsController(), tag: id);

    final updatedOrder = await detailsController.getServiceOrderDetails(id: id);

    if (updatedOrder != null) {
      syncServiceOrder(id: id, updatedOrder: updatedOrder);
    }

    Get.delete<ServiceOrderDetailsController>(tag: id);
  }

  RxList<ServiceOrderEntity> get filterList {
    return serviceOrders
        .where((element) {
          final matchesMaintenanceType =
              selectedMaintenanceType.value == 'All' ||
                  (element.serviceDetails?.any((detail) =>
                          detail.maintenanceTypeTitle?.toLowerCase() ==
                          selectedMaintenanceType.value.toLowerCase()) ??
                      false);

          final matchesServiceType = selectedServiceType.value == 'All' ||
              (element.serviceDetails?.any((detail) =>
                      detail.serviceTypeTitle?.toLowerCase() ==
                      selectedServiceType.value.toLowerCase()) ??
                  false);

          final matchesCategory = selectedCategory.value == 'All' ||
              element.category?.toLowerCase() ==
                  selectedCategory.value.toLowerCase();

          final matchesStatus = selectedStatus.value == 'All' ||
              element.status?.toLowerCase() ==
                  selectedStatus.value.toLowerCase();

          final matchesSearch = txtSearch.isEmpty ||
              (element.serviceDetails?.any((detail) =>
                      detail.maintenanceTypeTitle
                          ?.toLowerCase()
                          .contains(txtSearch.value.toLowerCase()) ??
                      false) ??
                  false);

          // Check if all filter conditions match
          return matchesMaintenanceType &&
              matchesServiceType &&
              matchesCategory &&
              matchesStatus &&
              matchesSearch;
        })
        .toList()
        .obs;
  }

  void showFiltersBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColorsDark.scaffoldBackroundColor
              : AppColorsLight.scaffoldBackroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: const ServiceOrdersFiltersBottomSheet(),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  void clearFilters() {
    selectedStatus.value = 'All';
    selectedCategory.value = 'All';
    selectedServiceType.value = 'All';
    selectedMaintenanceType.value = 'All';
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
