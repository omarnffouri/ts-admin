import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/params/get_resources_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class GetResourcesUsecase extends BaseUseCase<
    BaseResponse<List<ResourceEntity>?>, GetResourcesParams> {
  final IStorageRespository respository;

  GetResourcesUsecase({required this.respository});

  @override
  Future<Either<BaseResponse<List<ResourceEntity>?>, Failure>> call(
      GetResourcesParams params) async {
    return await respository.getResources(params);
  }
}
