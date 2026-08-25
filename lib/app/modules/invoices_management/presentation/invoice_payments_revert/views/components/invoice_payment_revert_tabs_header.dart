import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/controllers/invoice_payments_revert_controller.dart';

class InvoicePaymentRevertTabsHead
    extends GetView<InvoicePaymentsRevertController> {
  const InvoicePaymentRevertTabsHead({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;
    // Color primaryColorDark = theme.primaryColorDark;
    // Color primaryColorLight = theme.primaryColorLight;
    // Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    // Color cardColor = theme.cardColor;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: Container(
        color: primaryColor,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                //
                //
                // back button
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                ),

                //
                //
                // heading
                Text(
                  "Revert Adjusted Invoices",
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ).marginOnly(left: 14),
              ],
            ).marginSymmetric(horizontal: 14, vertical: 10),

            //
            //
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller
                              .currentTab(InvoicePaymentsRevertTabs.pending);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.currentTab.value ==
                                    InvoicePaymentsRevertTabs.pending
                                ? Get.isDarkMode
                                    ? AppColorsDark
                                        .conversationsSelectedTabColor
                                    : AppColorsLight
                                        .conversationsSelectedTabColor
                                : primaryColor,
                            borderRadius: controller.currentTab.value ==
                                    InvoicePaymentsRevertTabs.pending
                                ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )
                                : const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                  ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Pending",
                                  style: TextStyle(
                                    color: controller.currentTab.value ==
                                            InvoicePaymentsRevertTabs.pending
                                        ? AppColorsLight.mainColor
                                        : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: (controller.currentTab.value !=
                                            InvoicePaymentsRevertTabs
                                                .pending) &&
                                        (controller
                                            .pendingInvoicePayments.isNotEmpty),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        controller.pendingInvoicePayments
                                                    .length >
                                                99
                                            ? "99+"
                                            : controller
                                                .pendingInvoicePayments.length
                                                .toString(),
                                        style: const TextStyle(
                                          color: AppColorsLight.mainColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: primaryColor,
                      child: GestureDetector(
                        onTap: () {
                          controller
                              .currentTab(InvoicePaymentsRevertTabs.approved);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.currentTab.value ==
                                    InvoicePaymentsRevertTabs.approved
                                ? Get.isDarkMode
                                    ? AppColorsDark
                                        .conversationsSelectedTabColor
                                    : AppColorsLight
                                        .conversationsSelectedTabColor
                                : primaryColor,
                            borderRadius: controller.currentTab.value ==
                                    InvoicePaymentsRevertTabs.approved
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              "Approved",
                              style: TextStyle(
                                color: controller.currentTab.value ==
                                        InvoicePaymentsRevertTabs.approved
                                    ? AppColorsLight.mainColor
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller
                              .currentTab(InvoicePaymentsRevertTabs.rejected);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.currentTab.value ==
                                    InvoicePaymentsRevertTabs.rejected
                                ? Get.isDarkMode
                                    ? AppColorsDark
                                        .conversationsSelectedTabColor
                                    : AppColorsLight
                                        .conversationsSelectedTabColor
                                : primaryColor,
                            borderRadius: controller.currentTab.value ==
                                    InvoicePaymentsRevertTabs.rejected
                                ? const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )
                                : const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                  ),
                          ),
                          child: Center(
                            child: Text(
                              "Rejected",
                              style: TextStyle(
                                color: controller.currentTab.value ==
                                        InvoicePaymentsRevertTabs.rejected
                                    ? AppColorsLight.mainColor
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
