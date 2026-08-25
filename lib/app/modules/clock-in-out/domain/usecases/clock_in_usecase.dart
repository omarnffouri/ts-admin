import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/repositories/clock_in_out_repository.dart';

class ClockInUsecase extends BaseUseCase<BaseResponse<bool>, NoParams> {
  final IClockInOutRepository repository;

  ClockInUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<bool>, Failure>> call(NoParams params) async {
    return repository.clockIn();
  }
}
