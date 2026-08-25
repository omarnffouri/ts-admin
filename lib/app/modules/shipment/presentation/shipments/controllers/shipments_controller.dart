import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/enitities/shipment_entity.dart';
import '../../../domain/usecases/get_all_shipments.dart';
import '../views/components/shipments_filters_bottom_sheet.dart';

class ShipmentsController extends GetxController
    with GetTickerProviderStateMixin {
  final authController = Get.find<AuthController>();

// body refresh controllers
  final RefreshController refreshController = RefreshController();

  late final AnimationController searchExpandedController;
  late final AnimationController shipmentExpandedController;

// usecases
  final getAllShipmentUsecase = sl<GetAllShipmentUsecase>();

// loading state variables
  final RxList<ShipmentEntity> shipments = <ShipmentEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isHasMoreLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isSearchEnabled = false.obs;

// pagination variables
  late final ScrollController scrollController;
  final RxInt page = 1.obs;
  final RxInt limit = 20.obs;
  final RxBool hasMore = true.obs;

// filter variables and search
  final RxString selectedRole = 'assigned'.obs;
  final RxList<String> roleOptions = <String>[
    'All',
    'pending',
    'assigned',
    'waiting',
    'transit',
    'transit-complete',
    'manual-completed',
    'completed',
    'ready-to-invoice',
    'invoiced',
  ].obs;

  final TextEditingController txtSearchController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  final txtSearch = "".obs;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController()..addListener(_scrollListener);

    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    shipmentExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initial data load
    getAllShipments();
  }

  @override
  void onClose() {
    searchExpandedController.dispose();
    shipmentExpandedController.dispose();
    scrollController.dispose();
    txtSearchController.dispose();
    pickupDateController.dispose();
    deliveryDateController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        hasMore.value) {
      page.value++;
      loadMoreShipments();
    }
  }

  Future<void> getAllShipments() async {
    shipments.clear();
    filterList.clear();
    isLoading.value = true;
    await _fetchShipments(resetPage: true);
    isLoading.value = false;
  }

  Future<void> loadMoreShipments() async {
    if (txtSearchController.text.isNotEmpty) return;
    isHasMoreLoading.value = true;
    await _fetchShipments();
    isHasMoreLoading.value = false;
  }

  Future<void> searchShipments() async {
    isSearching.value = true;
    await _fetchShipments(resetPage: true);
    isSearching.value = false;
  }

  Future<void> _fetchShipments({bool resetPage = false}) async {
    if (resetPage) page.value = 1;

    try {
      final body = {
        'page': page.value,
        'limit': limit.value,
        'status': selectedRole.value == 'All' ? null : selectedRole.value,
        "pickup_date": pickupDateController.text.isEmpty
            ? null
            : pickupDateController.text.trim(),
        "delivery_date": deliveryDateController.text.isEmpty
            ? null
            : deliveryDateController.text.trim(),
        'search': txtSearchController.text.isEmpty
            ? null
            : txtSearchController.text.trim(),
      };

      final response = await getAllShipmentUsecase.call(body);
      response.fold((BaseResponse<List<ShipmentEntity>> response) {
        if (txtSearchController.text.isNotEmpty) {
          shipments.value = response.data!;
        } else {
          shipments.addAll(response.data!);
          hasMore.value = response.hasMore ?? false;
        }
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> handleShipmentRefresh() async {
    txtSearchController.clear();
    selectedRole.value = 'All';
    await getAllShipments();
    refreshController.refreshCompleted();
  }

  void handleExpantionClicks(ShipmentEntity shipment) {
    shipment.isExpanded.value = !shipment.isExpanded.value;
    shipment.isExpanded.refresh();
  }

  Future<void> handleStatusChange(String? value) async {
    selectedRole.value = value.toString();
  }

  Future<void> handleSearchChange(String value) async {
    txtSearch.value = value;
    EasyDebounce.debounce('search', const Duration(milliseconds: 500), () {
      txtSearchController.text = value;
      searchShipments();
    });
  }

  void clearSearch() {
    txtSearchController.clear();
    selectedRole.value = 'All';
  }

  RxList<ShipmentEntity> get filterList {
    // no filter no search
    if (selectedRole.value == 'All' || txtSearchController.text.isEmpty) {
      return shipments;
      // filter no search
    } else {
      return shipments
          .where((element) => element.status == (selectedRole.value))
          .toList()
          .obs;
    }
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
        child: const ShipmentsFiltersBottomSheet(),
      ),
      isScrollControlled: false,
      isDismissible: true,
      enableDrag: true,
    );
  }
}
