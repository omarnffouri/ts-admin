import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class RevokeAllResourcePermissionUsecase extends BaseUseCase<bool, String> {
  final IStorageRespository respository;

  RevokeAllResourcePermissionUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(String params) async {
    return await respository.revokeAllResourcePermission(params);
  }
}
