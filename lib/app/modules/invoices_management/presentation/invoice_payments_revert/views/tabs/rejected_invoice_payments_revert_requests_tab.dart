import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/entities/invoice_payment_request_entity.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/controllers/invoice_payments_revert_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class RejectedInvoicePaymentsRevertTab
    extends GetView<InvoicePaymentsRevertController> {
  const RejectedInvoicePaymentsRevertTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingRejectedInvoicePayments
          ? _buildLoadingView()
          : Obx(
              () => SmartRefresher(
                controller: controller.rejectedRefreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handleRejectedRefresh,
                child: controller.rejectedInvoicePayments.isEmpty
                    ? const NoDataView()
                    : ListView.separated(
                        itemCount: controller.rejectedInvoicePayments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final InvoicePaymentEntity invoice = controller
                              .rejectedInvoicePayments
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
          bottom: (index == (controller.rejectedInvoicePayments.length - 1))
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
                if (controller.rejectedInvoiceExpandedIndex.value == index) {
                  controller.rejectedInvoiceExpandedIndex.value = -1;
                } else {
                  controller.rejectedInvoiceExpandedIndex.value = index;
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
                          color:
                              controller.rejectedInvoiceExpandedIndex.value ==
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
                      controller.rejectedInvoiceExpandedIndex.value == index
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
              visible: index == controller.rejectedInvoiceExpandedIndex.value,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
