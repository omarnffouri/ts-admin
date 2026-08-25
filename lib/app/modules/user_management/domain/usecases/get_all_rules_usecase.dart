import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/rule_entity.dart';

import '../repositories/user_management_repository.dart';

class GetAllRulesUsecase extends BaseUseCase<List<RuleEntity>, NoParams> {
  IUserManagementRepository repository;
  GetAllRulesUsecase({required this.repository});

  @override
  Future<Either<List<RuleEntity>, Failure>> call(NoParams params) async {
    return await repository.getAllRules();
  }
}
