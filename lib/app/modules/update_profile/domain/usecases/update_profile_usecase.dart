import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/update_profile/domain/entities/update_profile_data_entity.dart';
import 'package:ts_admin/app/modules/update_profile/domain/repositories/update_profile_repository.dart';

class UpdateProfileUsecase
    extends BaseUseCase<BaseResponse<UpdateProfileDataEntity>, Object> {
  final IUpdateProfileRepository repository;

  UpdateProfileUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<UpdateProfileDataEntity>, Failure>> call(
      Object params) async {
    return await repository.updateProfile(params);
  }
}
