import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/update_profile/domain/entities/update_profile_data_entity.dart';

import '../../../../core/network/error/failures.dart';

abstract class IUpdateProfileRepository {
  Future<Either<BaseResponse<UpdateProfileDataEntity>, Failure>> updateProfile(
      Object params);
}
