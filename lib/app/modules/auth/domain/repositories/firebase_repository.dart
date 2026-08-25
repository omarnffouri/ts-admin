import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/params/firebase_sign_in_params.dart';

abstract class IFirebaseRepository {
  Future<Either<Unit, Failure>> signInToFirebase(FirebaseSignInParams params);
}
