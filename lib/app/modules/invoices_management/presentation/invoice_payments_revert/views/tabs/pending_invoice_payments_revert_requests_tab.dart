import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/entities/invoice_payment_request_entity.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/enums/invoice_payment_statuses.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/controllers/invoice_payments_revert_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class PendingInvoicePaymentsRevertTab
    extends GetView<InvoicePaymentsRevertController> {
  const PendingInvoicePaymentsRevertTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingPendingInvoicePayments
          ? _buildLoadingView()
          : Obx(
              () => SmartRefresher(
                controller: controller.pendingRefreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handlePendingRefresh,
                child: controller.pendingInvoicePayments.isEmpty
                    ? const NoDataView()
                    : ListView.separated(
                        itemCount: controller.pendingInvoicePayments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final InvoicePaymentEntity invoice = controller
                              .pendingInvoicePayments
                              .elementAt(index);
                          return _InvoicePaymentItemView(
                            index: index,
                            invoice: invoice,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildLoadingView() {
    return IgnorePointer(
      child: ListView.separated(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.white30,
            child: Container(
              width: double.infinity,
              height: 40,
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.only(
                  top: index == 0 ? 14 : 0, left: 14, right: 14),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}

class _InvoicePaymentItemView extends GetView<InvoicePaymentsRevertController> {
  final InvoicePaymentEntity invoice;
  final int index;

  const _InvoicePaymentItemView({required this.index, required this.invoice});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Obx(
      () => AnimatedContainer(
        margin: EdgeInsets.only(
          left: 14,
          right: 14,
          top: (index == 0) ? 14 : 0,
          bottom: (index == (controller.pendingInvoicePayments.length - 1))
              ? 14
              : 0,
        ),
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.grey.applyOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        // height: index == controller.expandedIndex.value ? null : 50,
        child: Column(
          children: [
            //
            // invoice number
            GestureDetector(
              onTap: () {
                if (controller.pendingInvoiceExpandedIndex.value == index) {
                  controller.pendingInvoiceExpandedIndex.value = -1;
                } else {
                  controller.pendingInvoiceExpandedIndex.value = index;
                }
              },
              child: Row(
                children: [
                  //
                  // invoice number
                  Expanded(
                    child: Text(
                      invoice.invoiceNumber ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: controller.pendingInvoiceExpandedIndex.value ==
                                      index &&
                                  (!Get.isDarkMode)
                              ? AppColorsLight.mainColor
                              : null),
                    ),
                  ),

                  //
                  // drop down icon
                  Obx(
                    () => Icon(
                      controller.pendingInvoiceExpandedIndex.value == index
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
                  )
                ],
              ),
            ),

            //
            //
            Visibility(
              visible: index == controller.pendingInvoiceExpandedIndex.value,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.white,
                  ),

                  //
                  // shipment no
                  Row(
                    children: [
                      Text(
                        'Shipment No:',
                        style: theme.textTheme.labelMedium,
                      ).marginOnly(right: 10),
                      Expanded(
                        child: Text(
                          invoice.shipmentNumber ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),

                  //
                  // actual amount
                  Row(
                    children: [
                      Text(
                        'Original Amount:',
                        style: theme.textTheme.labelMedium,
                      ).marginOnly(right: 10),
                      Expanded(
                        child: Text(
                          "\$${invoice.actualAmount?.toString() ?? ""}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ).marginOnly(top: 5),

                  //
                  // requested amount
                  Row(
                    children: [
                      Text(
                        'Requested Amount:',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: Colors.green),
                      ).marginOnly(right: 10),
                      Expanded(
                        child: Text(
                          "\$${invoice.updatedAmount?.toString() ?? ""}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.green),
                        ),
                      )
                    ],
                  ).marginOnly(top: 5),

                  //
                  // created by
                  Row(
                    children: [
                      Text(
                        'Requested By:',
                        style: theme.textTheme.labelMedium,
                      ).marginOnly(right: 10),
                      Expanded(
                        child: Text(
                          invoice.createdBy ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ).marginOnly(top: 5),

                  //
                  // requested at
                  Row(
                    children: [
                      Text(
                        'Requested At:',
                        style: theme.textTheme.labelMedium,
                      ).marginOnly(right: 10),
                      Expanded(
                        child: Text(
                          DateFormat('MMM/dd/yyyy \'at\' hh:mm a')
                              .format(invoice.createdAt ?? DateTime.now()),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ).marginOnly(top: 5),

                  //
                  // buttons
                  Obx(
                    () => (controller.isUpdatingInvoiceStatus &&
                            controller.updatingAtIndex.value == index)
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColorsLight.mainColor,
                            ),
                          ).marginOnly(top: 10)
                        : Visibility(
                            visible: controller
                                .authController.userPermissionHelper
                                .canUpdateInvoices(),
                            child: Row(
                              children: [
                                //
                                // rejection button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.updatingAtIndex(index);
                                      controller.updateInvoicePaymentStatus(
                                        invoice.id ?? 0,
                                        InvoicePaymentStatuses.rejected,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? AppColorsDark.mainRedColor
                                            : AppColorsLight.mainColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reject",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //
                                //
                                const SizedBox(
                                  width: 20,
                                ),

                                //
                                // approved button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.updatingAtIndex(index);
                                      controller.updateInvoicePaymentStatus(
                                        invoice.id ?? 0,
                                        InvoicePaymentStatuses.approved,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : AppColorsLight.mainColor),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Approve",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : AppColorsLight
                                                          .mainColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).marginOnly(top: 10),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
