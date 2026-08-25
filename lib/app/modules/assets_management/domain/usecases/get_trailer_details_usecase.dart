import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/vehicle_details_entity.dart';
import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class GetTrailerDetailsUsecase extends BaseUseCase<VehicleDetailsEntity, Body> {
  IAssetsRepository repository;
  GetTrailerDetailsUsecase({required this.repository});

  @override
  Future<Either<VehicleDetailsEntity, Failure>> call(Body params) async {
    return await repository.getTrailerDetails(params);
  }
}
