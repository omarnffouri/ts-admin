import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/params/get_invoices_params.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../services/injection_service.dart';
import '../../domain/entities/invoice_payment_request_entity.dart';
import '../../domain/params/update_invoice_payment_status_params.dart';
import '../../domain/repositories/invoice_payments_repository.dart';
import '../data_sources/invoice_payments_remote_data_source.dart';

class InvoicePaymentsRepositoryImp extends IInvoicePaymentsRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final IInvoicePaymentsRemoteDataSource dataSource;

  InvoicePaymentsRepositoryImp({required this.dataSource});

  @override
  Future<Either<BaseResponse<List<InvoicePaymentEntity>>, Failure>>
      getInvoicePayments(GetInvoicesParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getInvoicePayments(params);
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse, Failure>> updateInvoicePaymentStatus(
      UpdateInvoicePaymentStatusParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateInvoicePaymentStatus(params);
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
