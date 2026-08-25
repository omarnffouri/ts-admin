import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/form_entity.dart';
import '../repositories/form_repository.dart';

class GetAllFormsUsecase extends BaseUseCase<List<FormEntity>, NoParams> {
  IFormRepository formRepository;
  GetAllFormsUsecase({required this.formRepository});

  @override
  Future<Either<List<FormEntity>, Failure>> call(NoParams params) async {
    return await formRepository.getAllForms();
  }
}
