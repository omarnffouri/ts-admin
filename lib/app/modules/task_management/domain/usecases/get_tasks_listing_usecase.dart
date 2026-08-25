import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_listing_data_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

class GetTasksListingUsecase
    extends BaseUseCase<BaseResponse<TaskListingDataEntity>, NoParams> {
  final TasksRepository repository;

  GetTasksListingUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<TaskListingDataEntity>, Failure>> call(
      NoParams params) async {
    return await repository.getTasksListing(params);
  }
}
