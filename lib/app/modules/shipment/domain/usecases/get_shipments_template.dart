import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';

class GetShipmentTemplatesUsecase
    extends BaseUseCase<BaseResponse<List<ShipmentEntity>>, NoParams> {
  final IShipmentRepository shipmentRepository;

  GetShipmentTemplatesUsecase({required this.shipmentRepository});

  @override
  Future<Either<BaseResponse<List<ShipmentEntity>>, Failure>> call(
      NoParams params) async {
    return await shipmentRepository.getTemplateShipments();
  }
}
