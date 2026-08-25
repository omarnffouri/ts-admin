import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/params/upload_file_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class UploadFileResourceUsecase
    extends BaseUseCase<bool, UploadFileResourceParams> {
  final IStorageRespository respository;

  UploadFileResourceUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(UploadFileResourceParams params) async {
    return await respository.uploadFileResource(params);
  }
}
