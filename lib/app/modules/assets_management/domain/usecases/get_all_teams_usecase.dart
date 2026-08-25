import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/teams_entity.dart';
import '../repositories/assets_repository.dart';

class GetAllTeamsUsecase extends BaseUseCase<List<TeamsEntity>, NoParams> {
  IAssetsRepository repository;
  GetAllTeamsUsecase({required this.repository});

  @override
  Future<Either<List<TeamsEntity>, Failure>> call(NoParams params) async {
    return await repository.getAllTeams();
  }
}
