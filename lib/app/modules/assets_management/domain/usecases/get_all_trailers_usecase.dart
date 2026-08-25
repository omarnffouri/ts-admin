import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/trailer_entity.dart';

import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class GetAllTrailersUsecase
    extends BaseUseCase<BaseResponse<List<TrailerEntity>>, Body> {
  IAssetsRepository repository;
  GetAllTrailersUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<List<TrailerEntity>>, Failure>> call(
    Body params,
  ) async {
    return await repository.getAllTrailers(params);
  }
}
