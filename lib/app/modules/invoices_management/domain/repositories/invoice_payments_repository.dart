import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/params/get_invoices_params.dart';

import '../../../../core/network/error/failures.dart';
import '../entities/invoice_payment_request_entity.dart';
import '../params/update_invoice_payment_status_params.dart';

abstract class IInvoicePaymentsRepository {
  Future<Either<BaseResponse<List<InvoicePaymentEntity>>, Failure>>
      getInvoicePayments(
    GetInvoicesParams params,
  );

  Future<Either<BaseResponse, Failure>> updateInvoicePaymentStatus(
    UpdateInvoicePaymentStatusParams params,
  );
}
