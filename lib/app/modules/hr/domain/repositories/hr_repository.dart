import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_data_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/params/get_applications_params.dart';

abstract class HrRepository {
  Future<Either<BaseResponse<List<ApplicationEntity>>, Failure>>
      getApplications(GetApplicationsParams params);
  Future<Either<BaseResponse<ApplicationDataEntity>, Failure>>
      getApplicationDetails(int params);
}
