import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/params/firebase_sign_in_params.dart';

import '../../repositories/firebase_repository.dart';

class SignInToFirebaseUseCase extends BaseUseCase<Unit, FirebaseSignInParams> {
  final IFirebaseRepository _repository;

  SignInToFirebaseUseCase(this._repository);

  @override
  Future<Either<Unit, Failure>> call(FirebaseSignInParams params) async {
    return await _repository.signInToFirebase(params);
  }
}
