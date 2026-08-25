import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/data_entity.dart';
import '../repositories/user_management_repository.dart';

class GetUserOffDaysUsecase extends BaseUseCase<List<DataEntity>, NoParams> {
  IUserManagementRepository repository;
  GetUserOffDaysUsecase({required this.repository});

  @override
  Future<Either<List<DataEntity>, Failure>> call(NoParams params) async {
    return await repository.getUserOffDays();
  }
}
