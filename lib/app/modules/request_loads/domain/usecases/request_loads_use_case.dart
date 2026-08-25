import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/request_loads/domain/repositories/loads_repository.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';

class RequestLoadsUseCase
    extends BaseUseCase<BaseResponse<bool>, Map<String, dynamic>> {
  final ILoadsRepository loadsRepository;
  RequestLoadsUseCase({required this.loadsRepository});

  @override
  Future<Either<BaseResponse<bool>, Failure>> call(
      Map<String, dynamic> params) async {
    return await loadsRepository.requestLoads(params);
  }
}
