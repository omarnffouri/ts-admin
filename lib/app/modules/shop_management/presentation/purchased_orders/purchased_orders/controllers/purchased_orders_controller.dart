import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/mixins/order_update_mixin.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../domain/entities/purchase_order_entity.dart';
import '../../../../domain/usecases/used_part/change_purchase_order_status_usecase.dart';
import '../../../../domain/usecases/used_part/get_all_purchase_orders_usecase.dart';
import '../../../components/confirmation_bottom_sheet.dart';
import '../../purchased_order_detail/controllers/purchased_order_detail_controller.dart';
import '../views/components/purchase_order_filters_bottom_sheet.dart';

class PurchasedOrdersController extends GetxController with OrderUpdateMixin {
  // usecase
  final getAllPurchaseOrdersUsecase = sl<GetAllPurchaseOrdersUsecase>();
  final changePurchaseOrderStatusUsecase =
      sl<ChangePurchaseOrderStatusUsecase>();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();

  // loading state and variables
  final purchaseOrders = <PurchaseOrderEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;
  final txtSearch = ''.obs;

  final selectedStatus = 'All'.obs;
  final statusOption = <String>{
    'All',
    'pending',
    'approved',
    'completed',
    'cancelled',
    'rejected',
  }.obs;

  RxBool get isAnyFilterSelected => (selectedStatus.value != 'All').obs;

  @override
  void onInit() {
    debugPrint('PurchasedOrdersController onInit');
    super.onInit();
    getAllPurchaseOrders();
  }

  Future<void> getAllPurchaseOrders() async {
    try {
      isLoading(true);
      final response = await getAllPurchaseOrdersUsecase.call(const NoParams());
      response.fold((response) {
        debugPrint('purchaseOrders: ${response.length}');
        purchaseOrders.value = response;
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> onCancelPurchaseClicked(PurchaseOrderEntity service) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          name: "Purchase Order (${service.orderNumber})",
          title: 'Cancel Purchase Order ?',
          confirmText: 'Cancel',
          confirmTextBtn: 'Cancel',
          isLoading: isCancelling,
          onConfirm: () {
            cancellPurchaseOrder(service);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> cancellPurchaseOrder(PurchaseOrderEntity order) async {
    if (isCancelling.value) {
      return;
    }

    final body = {
      'id': order.id,
      'status': 'cancelled',
    };

    isCancelling.value = true;

    try {
      final result = await changePurchaseOrderStatusUsecase.call(body);
      result.fold(
        (success) async {
          if (success) {
            await updateOrderDetails(order.id.toString());
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: 'Purchase Order Cancelled successfully'.tr,
              isError: false,
            );
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to cancel the Purchase Order'.tr,
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
        Get.isRegistered<PurchasedOrderDetailController>(tag: id)
            ? Get.find<PurchasedOrderDetailController>(tag: id)
            : Get.put(PurchasedOrderDetailController(), tag: id);

    final updatedOrder =
        await detailsController.getPurchaseOrderDetails(id: id);

    if (updatedOrder != null) {
      syncPurchaseOrder(id: id, updatedOrder: updatedOrder);
    }

    Get.delete<PurchasedOrderDetailController>(tag: id);
  }

  Future<void> handleRefresh() async {
    await getAllPurchaseOrders();
    refreshController.refreshCompleted();
  }

  RxList<PurchaseOrderEntity> get filterList {
    return purchaseOrders
        .where((element) {
          final matchesStatus = selectedStatus.value == 'All' ||
              element.status?.toLowerCase() ==
                  selectedStatus.value.toLowerCase();

          // Check if all filter conditions match
          return matchesStatus;
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
        child: const PurchaseOrdersFiltersBottomSheet(),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  String purchaseOrderDescriptionPreview(String? rawDescription) {
    final String raw = rawDescription?.trim() ?? '';
    if (raw.isEmpty || raw.toLowerCase() == 'null') {
      return '';
    }

    final String withBreaks = raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(
          RegExp(
            r'</\s*(p|div|tr|li|ul|ol|h[1-6]|blockquote)\s*>',
            caseSensitive: false,
          ),
          '\n',
        )
        .replaceAll(RegExp(r'<\s*li[^>]*>', caseSensitive: false), '\n• ')
        .replaceAll(RegExp(r'<[^>]*>'), ' ');

    final String decoded = _decodeHtmlEntities(withBreaks);

    final List<String> lines = decoded
        .split('\n')
        .map((String line) => line.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((String line) => line.isNotEmpty && line != '•')
        .toList();

    return lines.join('\n');
  }

  final Map<String, String> _namedEntities = <String, String>{
    '&nbsp;': ' ',
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&quot;': '"',
    '&apos;': "'",
    '&mdash;': '—',
    '&ndash;': '–',
    '&hellip;': '…',
    '&bull;': '•',
  };

  String _decodeHtmlEntities(String value) {
    String result = value;

    _namedEntities.forEach((String entity, String replacement) {
      result =
          result.replaceAll(RegExp(entity, caseSensitive: false), replacement);
    });

    // Numeric references — decimal (&#39;) and hexadecimal (&#x27;).
    return result.replaceAllMapped(
      RegExp(r'&#(x?)([0-9a-fA-F]+);'),
      (Match match) {
        final bool isHex = (match.group(1) ?? '').isNotEmpty;
        final int? code = int.tryParse(
          match.group(2) ?? '',
          radix: isHex ? 16 : 10,
        );
        if (code == null || code < 0x20 || code > 0x10FFFF) {
          return match.group(0) ?? '';
        }
        return String.fromCharCode(code);
      },
    );
  }

  void clearFilters() {
    selectedStatus.value = 'All';
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
