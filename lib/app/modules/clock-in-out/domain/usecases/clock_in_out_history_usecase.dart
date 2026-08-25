import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/clock_in_out_history_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/repositories/clock_in_out_repository.dart';

class ClockInOutHistoryUsecase extends BaseUseCase<
    BaseResponse<List<ClockInOutHistoryDataEntity>>, String> {
  final IClockInOutRepository repository;

  ClockInOutHistoryUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<List<ClockInOutHistoryDataEntity>>, Failure>> call(
      String date) async {
    return repository.getClockInOutHistory(date);
  }
}
