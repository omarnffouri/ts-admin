import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/params/create_folder_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class CreateFolderResourceUsecase
    extends BaseUseCase<bool, CreateFolderParams> {
  final IStorageRespository respository;

  CreateFolderResourceUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(CreateFolderParams params) async {
    return await respository.createFolderResource(params);
  }
}
