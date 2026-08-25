import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/params/get_invoices_params.dart';

import '../../../../core/network/connection/api_constants.dart';
import '../../../../core/network/connection/dio_client.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/params/update_invoice_payment_status_params.dart';
import '../models/invoice_payment_request_model.dart';

abstract class IInvoicePaymentsRemoteDataSource {
  Future<Either<BaseResponse<List<InvoicePaymentModel>>, Failure>>
      getInvoicePayments(GetInvoicesParams params);

  Future<Either<BaseResponse, Failure>> updateInvoicePaymentStatus(
      UpdateInvoicePaymentStatusParams params);
}

class InvoicePaymentsRemoteDataSourceImp
    extends IInvoicePaymentsRemoteDataSource {
  final DioClient dioClient;
  InvoicePaymentsRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<List<InvoicePaymentModel>>, Failure>>
      getInvoicePayments(GetInvoicesParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInvoicePayments,
        method: RequestType.GET,
        data: params.toMap(),
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              if (json == null) {
                return List<InvoicePaymentModel>.empty();
              }
              return (json as List)
                  .map((e) => InvoicePaymentModel.fromJson(e))
                  .toList();
            },
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse, Failure>> updateInvoicePaymentStatus(
      UpdateInvoicePaymentStatusParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateInvoicePaymentStatus,
        method: RequestType.PUT,
        data: params.toMap(),
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return null;
            },
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
