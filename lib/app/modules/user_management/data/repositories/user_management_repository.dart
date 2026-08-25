import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/user_management/data/models/data_model.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../domain/repositories/user_management_repository.dart';
import '../datasources/user_management_remote_datasource.dart';
import '../models/rule_model.dart';
import '../models/user_mode.dart';

class UserManagementRepositoryImpl implements IUserManagementRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  IUserManagementRemoteDataSource dataSource;
  UserManagementRepositoryImpl({required this.dataSource});

  @override
  Future<Either<bool, Failure>> createAdmin(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.createAdmin(params);
        return response.fold(
          (result) => Left(result),
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
  Future<Either<bool, Failure>> updateAdmin(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateAdmin(params);
        return response.fold(
          (result) => Left(result),
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
  Future<Either<bool, Failure>> updateAdminPassword(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateAdminPassword(params);
        return response.fold(
          (result) => Left(result),
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
  Future<Either<bool, Failure>> deleteUser(String params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.deleteUser(params);
        return response.fold(
          (result) => Left(result),
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
  Future<Either<BaseResponse<List<UserModel>>, Failure>> getAllUsers(
    Map<String, dynamic> params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllUsers(params);
        return response.fold(
          (result) => Left(result),
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
  Future<Either<List<RuleModel>, Failure>> getAllRules() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllRules();
        return response.fold(
          (result) => Left(result),
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
  Future<Either<List<DataModel>, Failure>> getAllCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllCountries();
        return response.fold(
          (result) => Left(result),
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
  Future<Either<List<DataModel>, Failure>> getAllSupervisors() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllSupervisors();
        return response.fold(
          (result) => Left(result),
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
  Future<Either<List<DataModel>, Failure>> getAllDepartments() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllDepartments();
        return response.fold(
          (result) => Left(result),
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
  Future<Either<List<DataModel>, Failure>> getAllDesignations() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllDesignations();
        return response.fold(
          (result) => Left(result),
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
  Future<Either<List<DataModel>, Failure>> getUserOffDays() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getUserOffDays();
        return response.fold(
          (result) => Left(result),
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
  Future<Either<bool, Failure>> updateUserStatus(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateUserStatus(params);
        return response.fold(
          (result) => Left(result),
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
