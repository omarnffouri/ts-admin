import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';

class GetAdditionalPaysUsecase extends BaseUseCase<
    BaseResponse<AdditionalPayPayloadEntity>, Map<String, dynamic>> {
  final IShipmentRepository shipmentRepository;

  GetAdditionalPaysUsecase({required this.shipmentRepository});

  @override
  Future<Either<BaseResponse<AdditionalPayPayloadEntity>, Failure>> call(
      Map<String, dynamic> params) async {
    return await shipmentRepository.getAdditionalPays(params);
  }
}
