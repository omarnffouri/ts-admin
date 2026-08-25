import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';

class GetAllShipmentUsecase extends BaseUseCase<
    BaseResponse<List<ShipmentEntity>>, Map<String, dynamic>> {
  final IShipmentRepository shipmentRepository;

  GetAllShipmentUsecase({required this.shipmentRepository});

  @override
  Future<Either<BaseResponse<List<ShipmentEntity>>, Failure>> call(
      Map<String, dynamic> params) async {
    return await shipmentRepository.getAllShipments(params);
  }
}
