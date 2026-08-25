import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/truck_entity.dart';
import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class GetAllTrucksUsecase
    extends BaseUseCase<BaseResponse<List<TruckEntity>>, Body> {
  IAssetsRepository repository;
  GetAllTrucksUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<List<TruckEntity>>, Failure>> call(
    Body params,
  ) async {
    return await repository.getAllTrucks(params);
  }
}
