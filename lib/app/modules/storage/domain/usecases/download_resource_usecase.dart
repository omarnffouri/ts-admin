import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/download_resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class DownloadResourceUsecase
    extends BaseUseCase<BaseResponse<DownloadResourceEntity?>, int> {
  final IStorageRespository respository;

  DownloadResourceUsecase({required this.respository});

  @override
  Future<Either<BaseResponse<DownloadResourceEntity?>, Failure>> call(
      int params) async {
    return await respository.downloadResource(params);
  }
}
