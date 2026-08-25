import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/request_loads/data/data_sources/loads_remote_data_source.dart';
import 'package:ts_admin/app/modules/request_loads/domain/repositories/loads_repository.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../services/injection_service.dart';

class LoadsRepositoryImp extends ILoadsRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final ILoadsRemoteDataSource loadsRemoteDataSource;

  LoadsRepositoryImp({required this.loadsRemoteDataSource});

  @override
  Future<Either<BaseResponse<bool>, Failure>> requestLoads(
      Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await loadsRemoteDataSource.requestLoads(body);
        return response.fold(
          (resposne) => Left(resposne),
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
