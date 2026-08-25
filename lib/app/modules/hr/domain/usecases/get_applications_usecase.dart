import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/params/get_applications_params.dart';
import 'package:ts_admin/app/modules/hr/domain/repositories/hr_repository.dart';

class GetApplicationsUsecase extends BaseUseCase<
    BaseResponse<List<ApplicationEntity>>, GetApplicationsParams> {
  final HrRepository repository;

  GetApplicationsUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<List<ApplicationEntity>>, Failure>> call(
      GetApplicationsParams params) async {
    return await repository.getApplications(params);
  }
}
