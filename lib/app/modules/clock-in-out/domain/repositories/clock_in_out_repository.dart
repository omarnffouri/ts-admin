import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/check_clock_in_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/clock_in_out_history_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/week_hours_entity.dart';

abstract class IClockInOutRepository {
  Future<Either<BaseResponse<CheckClockInDataEntity>, Failure>> checkClockIn();
  Future<Either<BaseResponse<bool>, Failure>> clockIn();
  Future<Either<BaseResponse<bool>, Failure>> clockOut();
  Future<Either<BaseResponse<List<ClockInOutHistoryDataEntity>>, Failure>>
      getClockInOutHistory(String date);
  Future<Either<BaseResponse<WeekHoursEntity>, Failure>> getWeeklyHours(
      String date);
}
