import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';

import '../../../../core/network/error/failures.dart';

abstract class ILoadsRepository {
  Future<Either<BaseResponse<bool>, Failure>> requestLoads(
    Map<String, dynamic> body,
  );
}
