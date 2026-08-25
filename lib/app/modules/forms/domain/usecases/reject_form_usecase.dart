import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../../../core/helpers/base_use_case.dart';
import '../repositories/form_repository.dart';

class RejectFormUsecase extends BaseUseCase<bool, Map<String, dynamic>> {
  IFormRepository formRepository;
  RejectFormUsecase({required this.formRepository});

  @override
  Future<Either<bool, Failure>> call(Map<String, dynamic> params) async {
    return await formRepository.rejectForm(params);
  }
}
