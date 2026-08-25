import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/params/revoke_resource_permission_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class RevokeResourcePermissionUsecase
    extends BaseUseCase<bool, RevokeResourcePermissionParams> {
  final IStorageRespository respository;

  RevokeResourcePermissionUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(
      RevokeResourcePermissionParams params) async {
    return await respository.revokeResourcePermission(params);
  }
}
