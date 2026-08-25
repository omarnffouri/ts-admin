import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';
import '../params/update_invoice_payment_status_params.dart';
import '../repositories/invoice_payments_repository.dart';

class UpdateInvoicePaymentStatusUseCase
    extends BaseUseCase<BaseResponse, UpdateInvoicePaymentStatusParams> {
  final IInvoicePaymentsRepository repository;
  UpdateInvoicePaymentStatusUseCase({required this.repository});

  @override
  Future<Either<BaseResponse, Failure>> call(
      UpdateInvoicePaymentStatusParams params) async {
    return await repository.updateInvoicePaymentStatus(params);
  }
}
