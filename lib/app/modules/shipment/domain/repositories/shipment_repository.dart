import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_dropdowns_entity.dart';

import '../enitities/additional_pay_entity.dart';
import '../enitities/shipment_details_entity.dart';
import '../enitities/shipment_entity.dart';
import '../usecases/resolve_additional_pay_usecase.dart';

abstract class IShipmentRepository {
  Future<Either<BaseResponse<ShipmentDropdownsPlayloadEntity>, Failure>>
      getCSDropdownsValues();

  Future<Either<BaseResponse<List<ShipmentEntity>>, Failure>> getAllShipments(
    Map<String, dynamic> params,
  );

  Future<Either<BaseResponse<ShipmentDetails>, Failure>> getShipmentDetails(
    int params,
  );

  Future<Either<BaseResponse<bool>, Failure>> creatShipmentTemplate(
    FormData params,
  );
  Future<Either<BaseResponse<List<ShipmentEntity>>, Failure>>
      getTemplateShipments();
  Future<Either<BaseResponse<bool>, Failure>> updateShipmentTemplate(
    FormData params,
  );
  Future<Either<BaseResponse<AdditionalPayPayloadEntity>, Failure>>
      getAdditionalPays(Map<String, dynamic> params);

  Future<Either<AdditionalPayEntity, Failure>> resolveAdditionalPay(
    ResolveAdditionalPayParams params,
  );
}
