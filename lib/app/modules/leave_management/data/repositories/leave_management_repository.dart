import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/data/models/incoming_user_leave_request_model.dart';
import 'package:ts_admin/app/modules/leave_management/data/models/leave_history_model.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../domain/repositories/leave_management_repository.dart';
import '../../domain/usecases/check_eligibility_usecase.dart';
import '../datasources/leave_management_remote_datasource.dart';
import '../models/alternative_user_model.dart';
import '../models/eligibility_model.dart';
import '../models/leave_type_model.dart';
import '../models/remaining_leave_category_model.dart';
import '../models/requested_leave_model.dart';
import '../models/super_visor_model.dart';

class LeaveManagementRepositoryImpl implements ILeaveManagementRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  ILeaveManagementRemoteDataSource dataSource;
  LeaveManagementRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<LeaveTypeModel>, Failure>> getAllLeaveTypes() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllLeaveTypes();
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
  Future<Either<List<RemainingLeaveCategoryModel>, Failure>>
      getRemainingLeavesPerCategory() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getRemainingLeavesPerCategory();
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
  Future<Either<List<SupervisorModel>, Failure>> getAllSupervisors(
    Map<String, dynamic> params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllSupervisors(params);
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
  Future<Either<List<AlternativeUserModel>, Failure>>
      getAlternativeUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAlternativeUsers();
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
  Future<Either<EligibilityModel, Failure>> checkEligibility(
      CheckEligibilityParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final checkResponse = await dataSource.checkEligibility(params);
        return checkResponse.fold(
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
  Future<Either<bool, Failure>> sumbitLeaveRequest(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.sumbitLeaveRequest(params);
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
  Future<Either<List<RequestModel>, Failure>> getAllRequestedLeaves(
    Map<String, dynamic> params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getRequestedLeaves(params);
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
  Future<Either<List<UserLeaveRequestModel>, Failure>>
      getUsersRequestedLeaves() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getUsersRequestedLeaves();
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
  Future<Either<bool, Failure>> adminAction(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.adminAction(params);
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
  Future<Either<List<LeaveHistoryModel>, Failure>> getRequestedHistory() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getRequestedHistory();
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
