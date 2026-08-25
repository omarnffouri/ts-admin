import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/check_clock_in_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/repositories/clock_in_out_repository.dart';

class CheckClockInUsecase
    extends BaseUseCase<BaseResponse<CheckClockInDataEntity>, NoParams> {
  final IClockInOutRepository repository;

  CheckClockInUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<CheckClockInDataEntity>, Failure>> call(
      NoParams params) async {
    return repository.checkClockIn();
  }
}
