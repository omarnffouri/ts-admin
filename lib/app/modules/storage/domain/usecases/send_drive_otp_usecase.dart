import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class SendDriveOtpUsecase extends BaseUseCase<bool, NoParams> {
  final IStorageRespository respository;

  SendDriveOtpUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(NoParams params) async {
    return await respository.sendOtp();
  }
}
