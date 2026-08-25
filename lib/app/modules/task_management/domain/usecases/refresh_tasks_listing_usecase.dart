import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

class RefreshTasksListingUsecase
    extends BaseUseCase<BaseResponse<List<TaskEntity>>, String> {
  final TasksRepository repository;

  RefreshTasksListingUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<List<TaskEntity>>, Failure>> call(
      String params) async {
    return await repository.refreshTasksListing(params);
  }
}
