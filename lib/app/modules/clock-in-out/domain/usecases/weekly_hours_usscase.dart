import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/week_hours_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/repositories/clock_in_out_repository.dart';

class GetWeeklyHoursUseCase
    extends BaseUseCase<BaseResponse<WeekHoursEntity>, String> {
  final IClockInOutRepository repository;

  GetWeeklyHoursUseCase({required this.repository});

  @override
  Future<Either<BaseResponse<WeekHoursEntity>, Failure>> call(
      String date) async {
    return repository.getWeeklyHours(date);
  }
}
