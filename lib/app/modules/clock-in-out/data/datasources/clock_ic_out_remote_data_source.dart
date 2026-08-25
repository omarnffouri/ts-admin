import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/data/models/check_clock_in_model.dart';
import 'package:ts_admin/app/modules/clock-in-out/data/models/clock_in_out_history_model.dart';
import 'package:ts_admin/app/modules/clock-in-out/data/models/week_hours_model.dart';

abstract class IClockInOutDataSource {
  Future<Either<BaseResponse<CheckClockInDataModel>, Failure>> checkClockIn();
  Future<Either<BaseResponse<bool>, Failure>> clockIn();
  Future<Either<BaseResponse<bool>, Failure>> clockOut();
  Future<Either<BaseResponse<List<ClockInOutHistoryDataModel>>, Failure>>
      getClockInOutHistory(String date);
  Future<Either<BaseResponse<WeekHoursResponseModel>, Failure>> getWeeklyHours(
      String date);
}

class ClockInOutRemoteDataSourceImp extends IClockInOutDataSource {
  final DioClient dioClient;
  ClockInOutRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<CheckClockInDataModel>, Failure>>
      checkClockIn() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.checkClockIn,
        method: RequestType.GET,
        converter: (response) {
          try {
            return BaseResponse.fromJson(
              response,
              (p0) => CheckClockInDataModel.fromJson(p0),
            );
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<List<ClockInOutHistoryDataModel>>, Failure>>
      getClockInOutHistory(String date) async {
    try {
      final curentMonthStartDate = DateFormat('yyyy-MM-dd')
          .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
      //
      //
      final curentMonthEndDate = DateFormat('yyyy-MM-dd')
          .format(DateTime(DateTime.now().year, (DateTime.now().month + 1), 0));

      final response = await dioClient.makeRequest(
        url: ApiConstants.clockInOutHistory,
        method: RequestType.GET,
        queryParams: {
          'start_date': curentMonthStartDate,
          'end_date': curentMonthEndDate,
          'date': date
        },
        converter: (response) => BaseResponse.listFromJson(
          response,
          (e) => ClockInOutHistoryDataModel.fromJson(e),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> clockIn() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.clockIn,
        method: RequestType.GET,
        converter: (response) {
          try {
            return BaseResponse.fromJson(
              response,
              (p0) => response['code'] == 200,
            );
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> clockOut() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.clockOut,
        method: RequestType.GET,
        converter: (response) {
          try {
            return BaseResponse.fromJson(
              response,
              (p0) => response['code'] == 200,
            );
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<WeekHoursResponseModel>, Failure>> getWeeklyHours(
      String date) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.weeklyHours,
        method: RequestType.GET,
        queryParams: {
          "date": date,
        },
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (p0) => WeekHoursResponseModel.fromJson(p0 ?? {}),
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
