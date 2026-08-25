import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/annoucments/data/models/annoucement_model.dart';
import '../../../../services/injection_service.dart';
import '../../domain/repositories/annoucements_repository.dart';
import '../datasources/annoucements_remote_datasource.dart';
import '../models/user_type_model.dart';

class AnnoucementsRepositoryImpl extends IAnnoucementsRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  IAnnoucementsRemoteDataSource dataSource;

  AnnoucementsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<List<AnnoucementModel>, Failure>> getAllAnnoucements() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllAnnoucements();
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
  Future<Either<bool, Failure>> createAnnoucement(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createAnnoucement(params);
      } catch (e) {
        return Right(ServerFailure(title: '', message: e.toString()));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> updateAnnoucementReadStatus(
      int annoucementId) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.updateAnnoucementReadStatus(annoucementId);
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
  Future<Either<UserTypeModel, Failure>> getAnnoucementUserTypes() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAnnoucementUserTypes();
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
