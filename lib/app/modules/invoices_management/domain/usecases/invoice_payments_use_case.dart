import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/params/get_invoices_params.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';
import '../entities/invoice_payment_request_entity.dart';
import '../repositories/invoice_payments_repository.dart';

class InvoicePaymentsUseCase extends BaseUseCase<
    BaseResponse<List<InvoicePaymentEntity>>, GetInvoicesParams> {
  final IInvoicePaymentsRepository repository;
  InvoicePaymentsUseCase({required this.repository});

  @override
  Future<Either<BaseResponse<List<InvoicePaymentEntity>>, Failure>> call(
      GetInvoicesParams params) async {
    return await repository.getInvoicePayments(params);
  }
}
