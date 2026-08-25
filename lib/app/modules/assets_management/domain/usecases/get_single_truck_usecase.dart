import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/truck_entity.dart';
import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class GetSingleTruckUsecase extends BaseUseCase<TruckEntity, Body> {
  IAssetsRepository repository;
  GetSingleTruckUsecase({required this.repository});

  @override
  Future<Either<TruckEntity, Failure>> call(Body params) async {
    return await repository.getSingleTruck(params);
  }
}
