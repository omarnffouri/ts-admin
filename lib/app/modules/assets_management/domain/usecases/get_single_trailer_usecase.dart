import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/trailer_entity.dart';
import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class GetSingleTrailerUsecase extends BaseUseCase<TrailerEntity, Body> {
  IAssetsRepository repository;
  GetSingleTrailerUsecase({required this.repository});

  @override
  Future<Either<TrailerEntity, Failure>> call(Body params) async {
    return await repository.getSingleTrailer(params);
  }
}
