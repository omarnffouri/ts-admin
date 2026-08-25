import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

import '../entities/remaining_leave_category_entity.dart';

class GetRemainingLeavesPerCategoryUsecase
    extends BaseUseCase<List<RemainingLeaveCategoryEntity>, NoParams> {
  ILeaveManagementRepository repository;
  GetRemainingLeavesPerCategoryUsecase({required this.repository});

  @override
  Future<Either<List<RemainingLeaveCategoryEntity>, Failure>> call(
    NoParams params,
  ) async {
    return await repository.getRemainingLeavesPerCategory();
  }
}
