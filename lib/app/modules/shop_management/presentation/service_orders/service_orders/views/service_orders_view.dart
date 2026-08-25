import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/service_orders_controller.dart';
import 'components/service_orders_body.dart';
import 'components/service_orders_header.dart';
import 'components/service_orders_loading_view.dart';
import 'components/service_orders_state_view.dart';

class ServiceOrdersView extends GetView<ServiceOrdersController> {
  const ServiceOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          heroTag: 'create_service_order',
          elevation: context.isDark ? 2 : 6,
          highlightElevation: 3,
          backgroundColor: context.floatingButtonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () => Get.toNamed(Routes.CREATE_EDIT_SERVICE_ORDER),
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'New order'.tr,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const ServiceOrdersHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: SlidableAutoCloseBehavior(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    header: const WaterDropMaterialHeader(),
                    onRefresh: controller.handleRefresh,
                    child: CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        Obx(() => _buildContentSliver(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSliver(BuildContext context) {
    if (controller.isLoading.value) {
      return const ServiceOrdersLoadingView();
    }

    final orders = controller.filterList;
    if (controller.errorMessage.value != null && orders.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: ServiceOrdersStateView(
          icon: Icons.cloud_off_rounded,
          title: 'Unable to load service orders',
          message: controller.errorMessage.value!,
          actionLabel: 'Try again',
          onAction: controller.getAllServiceOrders,
        ),
      );
    }

    if (orders.isEmpty) {
      final bool isFiltering = controller.txtSearch.value.isNotEmpty ||
          controller.isAnyFilterSelected.value;

      return SliverFillRemaining(
        hasScrollBody: false,
        child: ServiceOrdersStateView(
          icon: isFiltering
              ? Icons.search_off_rounded
              : Icons.receipt_long_rounded,
          title: isFiltering
              ? 'No matching service orders'
              : 'No service orders yet',
          message: isFiltering
              ? 'Try changing your search or filters.'
              : 'New service orders will appear here when they are created.',
          actionLabel: isFiltering && controller.isAnyFilterSelected.value
              ? 'Clear filters'
              : null,
          onAction: isFiltering && controller.isAnyFilterSelected.value
              ? controller.clearFilters
              : null,
        ),
      );
    }

    return ServiceOrdersBody(orders: orders);
  }
}
