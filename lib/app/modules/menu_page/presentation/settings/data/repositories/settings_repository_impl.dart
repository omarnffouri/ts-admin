import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/data/datasources/settings_data_source.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/domain/repositories/settings_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class SettingsRepositoryImpl extends ISettingsRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  ISettingsDataSource dataSource = sl<ISettingsDataSource>();

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<bool, Failure>> updateOtp(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateOtp(params);
        return response.fold(
          (bool otp) => Left(otp),
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
