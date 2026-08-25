import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class AddNewNoteUsecase extends BaseUseCase<bool, Body> {
  IAssetsRepository repository;
  AddNewNoteUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Body params) async {
    return await repository.addNewNote(params);
  }
}
