// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';

import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/update_profile/data/data_sources/update_profile_remote_data_source.dart';
import 'package:ts_admin/app/modules/update_profile/data/models/update_profile_data_model.dart';
import 'package:ts_admin/app/modules/update_profile/domain/repositories/update_profile_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class UpdateProfileRepositoryImp extends IUpdateProfileRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  IUpdateProfileDataSource dataSource;

  UpdateProfileRepositoryImp({
    required this.dataSource,
  });

  @override
  Future<Either<BaseResponse<UpdateProfileDataModel>, Failure>> updateProfile(
      Object params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateProfile(params);
        return response.fold(
          (profile) => Left(profile),
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
