import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_data_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/repositories/hr_repository.dart';

class GetApplicationDetailsUsecase
    extends BaseUseCase<BaseResponse<ApplicationDataEntity>, int> {
  final HrRepository repository;

  GetApplicationDetailsUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<ApplicationDataEntity>, Failure>> call(
      int params) async {
    return await repository.getApplicationDetails(params);
  }
}
