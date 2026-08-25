import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/hr/data/data_sources/hr_remote_data_source.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_data_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/params/get_applications_params.dart';
import 'package:ts_admin/app/modules/hr/domain/repositories/hr_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class HrRepositoryImp extends HrRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final HrRemoteDataSource dataSource;

  HrRepositoryImp({required this.dataSource});

  @override
  Future<Either<BaseResponse<List<ApplicationEntity>>, Failure>>
      getApplications(GetApplicationsParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getApplications(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse<ApplicationDataEntity>, Failure>>
      getApplicationDetails(int params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getApplicationDetails(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
