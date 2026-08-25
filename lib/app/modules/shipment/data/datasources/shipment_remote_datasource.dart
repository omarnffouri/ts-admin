import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/data/models/additional_pay_model.dart';
import 'package:ts_admin/app/modules/shipment/data/models/shipment_dropdowns_model.dart';
import 'package:ts_admin/app/modules/shipment/data/models/shipment_model.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/resolve_additional_pay_usecase.dart';

import '../models/shipment_details_model.dart';

abstract class IShipmentRemoteDataSource {
  Future<Either<BaseResponse<ShipmentDropdownsPlayloadModel>, Failure>>
      getCSDropdownsValues();

  Future<Either<BaseResponse<List<ShipmentModel>>, Failure>> getAllShipments(
    Map<String, dynamic> params,
  );

  Future<Either<BaseResponse<ShipmentDetailsModel>, Failure>>
      getShipmentDetails(
    int params,
  );

  Future<Either<BaseResponse<List<ShipmentModel>>, Failure>>
      getTemplateShipments();
  Future<Either<BaseResponse<bool>, Failure>> creatShipmentTemplate(
    FormData params,
  );
  Future<Either<BaseResponse<bool>, Failure>> updateShipmentTemplate(
    FormData params,
  );
  Future<Either<BaseResponse<AdditionalPayPayloadModel>, Failure>>
      getAdditionalPays(Map<String, dynamic> params);

  Future<Either<AdditionalPayModel, Failure>> resolveAdditionalPay(
    ResolveAdditionalPayParams params,
  );
}

class ShipmentRemoteDataSourceImp extends IShipmentRemoteDataSource {
  final DioClient dioClient;
  ShipmentRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<ShipmentDropdownsPlayloadModel>, Failure>>
      getCSDropdownsValues() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getCSDropdowns,
        method: RequestType.GET,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return ShipmentDropdownsPlayloadModel.fromJson(json);
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
  Future<Either<BaseResponse<List<ShipmentModel>>, Failure>> getAllShipments(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllShipments,
        method: RequestType.GET,
        data: params,
        converter: (response) {
          final int limit = (params['limit'] as num?)?.toInt() ?? 0;
          return BaseResponse.listFromJson(
            response,
            (e) => ShipmentModel.fromJson(e),
            hasMoreWhenOmitted: (data) => limit > 0 && data.length >= limit,
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<ShipmentDetailsModel>, Failure>>
      getShipmentDetails(int params) async {
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.getShipmentDetails}/$params',
        method: RequestType.GET,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return ShipmentDetailsModel.fromJson(json);
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
  Future<Either<BaseResponse<bool>, Failure>> creatShipmentTemplate(
      FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createShipmentTemplate,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return response['code'] == 200;
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
  Future<Either<BaseResponse<List<ShipmentModel>>, Failure>>
      getTemplateShipments() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getTemplateShipments,
        method: RequestType.GET,
        converter: (response) => BaseResponse.listFromJson(
          response,
          (e) => ShipmentModel.fromJson(e),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> updateShipmentTemplate(
    FormData params,
  ) async {
    try {
      // get the shipment id from the params
      final id = params.fields.firstWhere((e) => e.key == 'shipment_id').value;
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.updateShipmentTemplate}$id/update",
        method: RequestType.POST,
        data: params,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return response['code'] == 200;
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
  Future<Either<BaseResponse<AdditionalPayPayloadModel>, Failure>>
      getAdditionalPays(Map<String, dynamic> params) async {
    return dioClient.makeRequest(
      url: ApiConstants.additionalPayApprovals,
      method: RequestType.GET,
      queryParams: params,
      converter: (response) {
        final data = AdditionalPayPayloadModel.fromJson(response['data'] ?? {});
        final int perPage = (params['per_page'] as num?)?.toInt() ?? 0;
        return BaseResponse<AdditionalPayPayloadModel>(
          message: response['message'],
          code: response['code'],
          // Fallback when envelope omits has_more: full page implies more.
          hasMore: response['has_more'] ??
              (perPage > 0 && data.approvals.length >= perPage),
          data: data,
        );
      },
    );
  }

  @override
  Future<Either<AdditionalPayModel, Failure>> resolveAdditionalPay(
    ResolveAdditionalPayParams params,
  ) async {
    return dioClient.makeRequest(
      url: '${ApiConstants.additionalPayApprovals}/${params.id}',
      method: RequestType.PUT,
      data: params.toBody(),
      // responseHandler already threw for any non-2xx `code`, in-band included.
      // `data` echoes the decided record, so the list can take it wholesale.
      converter: (response) =>
          AdditionalPayModel.fromJson(response['data'] ?? {}),
    );
  }
}
