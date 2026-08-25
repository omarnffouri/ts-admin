import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/purchased_orders_controller.dart';
import 'components/purchase_order_card.dart';
import 'components/purchase_orders_empty_state.dart';
import 'components/purchase_orders_loading_view.dart';

class PurchasedOrdersView extends GetView<PurchasedOrdersController> {
  const PurchasedOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          heroTag: 'create_purchase_order',
          tooltip: 'Create purchase order',
          elevation: context.isDark ? 2 : 6,
          highlightElevation: 3,
          backgroundColor: context.floatingButtonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () {
            Get.toNamed(Routes.CREATE_EDIT_PURCHASED_ORDER);
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: Column(
        children: [
          //
          // header
          const _Header(),

          //
          // body
          Expanded(
            child: SafeArea(
              top: false,
              child: SmartRefresher(
                controller: controller.refreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handleRefresh,
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: _buildBody(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Skeletons only while there is nothing to show yet — a background
    // refresh keeps the orders already on screen.
    if (controller.isLoading.value && controller.purchaseOrders.isEmpty) {
      return const PurchaseOrdersLoadingView(
        key: ValueKey('purchase_orders_loading'),
      );
    }

    if (controller.filterList.isEmpty) {
      final bool isFiltered = controller.isAnyFilterSelected.value;

      return CustomScrollView(
        key: const ValueKey('purchase_orders_empty'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: PurchaseOrdersEmptyState(
              isFiltered: isFiltered,
              filterLabel: controller.selectedStatus.value.toTitleCase(),
              onClearFilters: controller.clearFilters,
              onCreate: () {
                Get.toNamed(Routes.CREATE_EDIT_PURCHASED_ORDER);
              },
            ),
          ),
        ],
      );
    }

    return const _PurchaseOrdersBody(key: ValueKey('purchase_orders_body'));
  }
}

class _PurchaseOrdersBody extends GetView<PurchasedOrdersController> {
  const _PurchaseOrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final orders = controller.filterList;

        return SlidableAutoCloseBehavior(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return PurchaseOrderCard(
                key: ValueKey(order.id),
                purchaseOrder: order,
              );
            },
          ),
        );
      },
    );
  }
}

class _Header extends GetView<PurchasedOrdersController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isFiltered = controller.isAnyFilterSelected.value;
        final String filterLabel =
            controller.selectedStatus.value.toTitleCase();
        final int count = controller.filterList.length;
        final String countLabel = count == 1 ? '1 order' : '$count orders';
        final String subtitle =
            isFiltered ? '$countLabel · $filterLabel' : countLabel;

        return AppReadHeader(
          title: "Purchased Orders",
          subtitle: subtitle,
          subtitleSemanticsLabel:
              isFiltered ? '$countLabel, filtered by $filterLabel' : countLabel,
          onBack: Get.back,
          trailing: _FilterAction(
            isFiltered: isFiltered,
            filterLabel: filterLabel,
          ),
        );
      },
    );
  }
}

class _FilterAction extends GetView<PurchasedOrdersController> {
  const _FilterAction({required this.isFiltered, required this.filterLabel});

  final bool isFiltered;
  final String filterLabel;

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = Theme.of(context).colorScheme.onPrimary;

    return Semantics(
      button: true,
      label: isFiltered
          ? 'Filter purchase orders, filtered by $filterLabel'
          : 'Filter purchase orders',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.showFiltersBottomSheet,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: foregroundColor.applyOpacity(isFiltered ? 0.26 : 0.16),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: foregroundColor.applyOpacity(isFiltered ? 0.42 : 0.22),
              ),
            ),
            child: Icon(
              isFiltered
                  ? Icons.filter_list_off_outlined
                  : Icons.filter_list_alt,
              size: 20,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
