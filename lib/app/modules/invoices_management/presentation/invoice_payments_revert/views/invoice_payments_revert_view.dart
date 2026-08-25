import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/views/components/invoice_payment_revert_tabs_header.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/views/tabs/approved_invoice_payments_revert_requests_tab.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/views/tabs/pending_invoice_payments_revert_requests_tab.dart';
import 'package:ts_admin/app/modules/invoices_management/presentation/invoice_payments_revert/views/tabs/rejected_invoice_payments_revert_requests_tab.dart';

import '../controllers/invoice_payments_revert_controller.dart';

class InvoicePaymentsDeleteView
    extends GetView<InvoicePaymentsRevertController> {
  const InvoicePaymentsDeleteView({super.key});
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

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          color: Get.isDarkMode
              ? Get.theme.scaffoldBackgroundColor
              : AppColorsLight.white,
          child: Column(children: [
            //
            // header
            const InvoicePaymentRevertTabsHead(),

            // body
            Expanded(
              child: Obx(
                () => controller.currentTab.value ==
                        InvoicePaymentsRevertTabs.pending
                    ? const PendingInvoicePaymentsRevertTab()
                    : controller.currentTab.value ==
                            InvoicePaymentsRevertTabs.approved
                        ? const ApprovedInvoicePaymentsRevertTab()
                        : const RejectedInvoicePaymentsRevertTab(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
