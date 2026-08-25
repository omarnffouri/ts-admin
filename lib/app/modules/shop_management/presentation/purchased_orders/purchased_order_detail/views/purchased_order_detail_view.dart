import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../domain/entities/purchase_order_entity.dart';
import '../controllers/purchased_order_detail_controller.dart';
import 'components/client_details_card.dart';
import 'components/purchase_order_detail_section.dart';
import 'components/purchase_order_details_empty_state.dart';
import 'components/purchase_order_part_card.dart';
import 'components/purchase_order_summary_card.dart';

class PurchasedOrderDetailView extends GetView<PurchasedOrderDetailController> {
  const PurchasedOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
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
                child: Obx(() => _buildBody(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final PurchaseOrderEntity? purchaseOrder = controller.purchasedOrder.value;

    // Spinner only until there is something to show — a background refresh
    // keeps the loaded details on screen.
    if (controller.isLoading.value && purchaseOrder == null) {
      return _FillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(context.brandColor),
          ),
        ),
      );
    }

    if (purchaseOrder == null) {
      return const _FillRemaining(
        child: Center(
          child: PurchaseOrderDetailsEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Purchase order unavailable',
            message: 'We could not load this purchase order. '
                'Pull down to try again.',
            compact: false,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // order number + status
          PurchaseOrderSummaryCard(purchaseOrder: purchaseOrder),

          const SizedBox(height: 20),

          //
          // client
          ClientDetailsCard(purchaseOrder: purchaseOrder),

          const SizedBox(height: 20),

          //
          // vehicle parts
          _VehiclePartsSection(purchaseOrder: purchaseOrder),

          const SizedBox(height: 24),

          //
          // update status action
          _UpdateStatusButton(status: purchaseOrder.status),
        ],
      ),
    );
  }
}

/// Keeps a single centred child scrollable so pull-to-refresh still works on
/// the loading and unavailable states.
class _FillRemaining extends StatelessWidget {
  const _FillRemaining({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}

class _VehiclePartsSection extends StatelessWidget {
  const _VehiclePartsSection({required this.purchaseOrder});

  final PurchaseOrderEntity purchaseOrder;

  @override
  Widget build(BuildContext context) {
    final List<VehiclePart> parts = purchaseOrder.vehicleParts;
    final String title = 'Vehicle Part${parts.length == 1 ? '' : 's'}';

    return PurchaseOrderDetailSection(
      icon: Icons.inventory_2_outlined,
      title: title,
      child: parts.isEmpty
          ? const PurchaseOrderDetailsEmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No vehicle parts',
              message: 'This purchase order has no parts attached.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < parts.length; index++) ...[
                  if (index > 0) const SizedBox(height: 12),
                  PurchaseOrderPartCard(
                    key: ValueKey(parts[index].id ?? index),
                    part: parts[index],
                  ),
                ],
              ],
            ),
    );
  }
}

class _UpdateStatusButton extends GetView<PurchasedOrderDetailController> {
  const _UpdateStatusButton({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final String label = _getNextStatus(status);

    final ThemeData buttonTheme = Theme.of(context).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(
            MediaQuery.textScalerOf(context).scale(52),
          ),
        ),
      ),
    );

    return Obx(
      () => Visibility(
        visible: controller.showUpdateButton.value,
        child: Semantics(
          button: true,
          label: label,
          child: Theme(
            data: buttonTheme,
            child: MainAppButton(
              label: label,
              isLoading: controller.isUpdating.value,
              onPressed: () {
                if (controller.isUpdating.value) {
                  return;
                }
                controller.changePurchaseOrderStatus();
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getNextStatus(String? status) {
    if (status == null) return '';
    return switch (status) {
      'pending' => 'Approve',
      'approved' => 'Complete',
      _ => '',
    };
  }
}

class _Header extends GetView<PurchasedOrderDetailController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final PurchaseOrderEntity? order = controller.purchasedOrder.value;
        final String orderNumber = order?.orderNumber?.capitalizeFirst ?? '';
        final bool canEdit = order?.status == 'pending';

        return AppReadHeader(
          title: 'Purchase Order Details',
          subtitle: orderNumber.isEmpty ? 'Purchase order' : orderNumber,
          subtitleSemanticsLabel: orderNumber.isEmpty
              ? 'Purchase order'
              : 'Purchase order $orderNumber',
          onBack: Get.back,
          trailing: canEdit ? const _EditAction() : null,
        );
      },
    );
  }
}

class _EditAction extends GetView<PurchasedOrderDetailController> {
  const _EditAction();

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = Theme.of(context).colorScheme.onPrimary;

    return Semantics(
      button: true,
      label: 'Edit purchase order',
      child: Tooltip(
        message: 'Edit purchase order',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.toNamed(
                Routes.CREATE_EDIT_PURCHASED_ORDER,
                arguments: controller.purchasedOrder.value,
              );
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: foregroundColor.applyOpacity(0.16),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: foregroundColor.applyOpacity(0.22),
                ),
              ),
              child: Icon(
                Icons.edit_outlined,
                size: 20,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
