import 'package:get/get.dart';

import '../controllers/invoice_payments_revert_controller.dart';

class InvoicePaymentsRevertBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InvoicePaymentsRevertController>(InvoicePaymentsRevertController());
  }
}
