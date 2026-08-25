import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/storage_users_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class GetStorageUsersUsecase
    extends BaseUseCase<BaseResponse<StorageUsersEntity?>, NoParams> {
  final IStorageRespository respository;

  GetStorageUsersUsecase({required this.respository});

  @override
  Future<Either<BaseResponse<StorageUsersEntity?>, Failure>> call(
      NoParams params) async {
    return await respository.getStorageUsers();
  }
}
