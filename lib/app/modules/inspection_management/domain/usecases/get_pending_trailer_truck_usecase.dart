import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/pending_truck_entity.dart';
import '../repositories/inspection_management_repository.dart';

class GetPendingTrailerTruckUsecase extends BaseUseCase<
    List<InspectionTrailerTruckEntity>, Map<String, dynamic>> {
  IInspectionManagementRepository repository;
  GetPendingTrailerTruckUsecase({required this.repository});

  @override
  Future<Either<List<InspectionTrailerTruckEntity>, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getPendingTrailerTruck(params);
  }
}
