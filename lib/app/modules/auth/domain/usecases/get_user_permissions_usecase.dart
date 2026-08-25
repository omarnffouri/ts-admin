import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/user_permission_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';

class GetUserPermissionsUseCase
    extends BaseUseCase<BaseResponse<List<UserPermissionEntity>>, NoParams> {
  final IAuthRepository authRepository;
  GetUserPermissionsUseCase({required this.authRepository});

  @override
  Future<Either<BaseResponse<List<UserPermissionEntity>>, Failure>> call(
      NoParams params) async {
    return await authRepository.getUserPermissions();
  }
}
