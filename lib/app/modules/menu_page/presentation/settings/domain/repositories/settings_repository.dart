import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/constants.dart';

abstract class ISettingsRepository {
  Future<Either<bool, Failure>> updateOtp(MapBody params);
}
