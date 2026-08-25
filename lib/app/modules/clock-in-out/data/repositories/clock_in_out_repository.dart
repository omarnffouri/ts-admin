import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/data/datasources/clock_ic_out_remote_data_source.dart';
import 'package:ts_admin/app/modules/clock-in-out/data/models/week_hours_model.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/check_clock_in_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/clock_in_out_history_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/repositories/clock_in_out_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ClockInOutRepositoryImp extends IClockInOutRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  IClockInOutDataSource clockInOutDataSource;

  ClockInOutRepositoryImp({required this.clockInOutDataSource});

  @override
  Future<Either<BaseResponse<CheckClockInDataEntity>, Failure>>
      checkClockIn() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await clockInOutDataSource.checkClockIn();
        return response.fold(
          (clockInOut) => Left(clockInOut),
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
  Future<Either<BaseResponse<List<ClockInOutHistoryDataEntity>>, Failure>>
      getClockInOutHistory(String date) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await clockInOutDataSource.getClockInOutHistory(date);
        return response.fold(
          (history) => Left(history),
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
  Future<Either<BaseResponse<bool>, Failure>> clockIn() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await clockInOutDataSource.clockIn();
        return response.fold(
          (clockin) => Left(clockin),
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
  Future<Either<BaseResponse<bool>, Failure>> clockOut() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await clockInOutDataSource.clockOut();
        return response.fold(
          (clockout) => Left(clockout),
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
  Future<Either<BaseResponse<WeekHoursResponseModel>, Failure>> getWeeklyHours(
      String date) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await clockInOutDataSource.getWeeklyHours(date);
        return response.fold(
          (weekHours) => Left(weekHours),
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
