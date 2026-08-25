import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';

import '../enitities/shipment_details_entity.dart';

class GetShipmentDetailsUsecase
    extends BaseUseCase<BaseResponse<ShipmentDetails>, int> {
  final IShipmentRepository shipmentRepository;

  GetShipmentDetailsUsecase({required this.shipmentRepository});

  @override
  Future<Either<BaseResponse<ShipmentDetails>, Failure>> call(
    int params,
  ) async {
    return await shipmentRepository.getShipmentDetails(params);
  }
}
