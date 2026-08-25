import 'package:get/get.dart';

import '../controllers/invoice_payment_requests_controller.dart';

class InvoicePaymentRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InvoicePaymentRequestsController>(
        InvoicePaymentRequestsController());
  }
}
