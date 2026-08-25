import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/params/rename_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class RenameResourceUsecase extends BaseUseCase<bool, RenameResourceParams> {
  final IStorageRespository respository;

  RenameResourceUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(RenameResourceParams params) async {
    return await respository.renameResource(params);
  }
}
