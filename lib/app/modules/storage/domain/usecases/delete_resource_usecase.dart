import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/params/delete_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class DeleteResourceUsecase extends BaseUseCase<bool, DeleteResourcesParams> {
  final IStorageRespository respository;

  DeleteResourceUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(DeleteResourcesParams params) async {
    return await respository.deleteResources(params);
  }
}
