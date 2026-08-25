import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';

class CreateShipmentTemplateUsecase
    extends BaseUseCase<BaseResponse<bool>, FormData> {
  final IShipmentRepository shipmentRepository;

  CreateShipmentTemplateUsecase({required this.shipmentRepository});

  @override
  Future<Either<BaseResponse<bool>, Failure>> call(FormData params) async {
    return await shipmentRepository.creatShipmentTemplate(params);
  }
}
