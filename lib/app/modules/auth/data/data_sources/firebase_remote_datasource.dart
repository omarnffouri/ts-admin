import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/params/firebase_sign_in_params.dart';

abstract class IFirebaseRemoteDataSource {
  Future<Either<Unit, Failure>> signInToFirebase(FirebaseSignInParams params);
}

class FirebaseRemoteDatasourceImpl extends IFirebaseRemoteDataSource {
  final FirebaseAuth _auth;

  FirebaseRemoteDatasourceImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<Either<Unit, Failure>> signInToFirebase(
    FirebaseSignInParams params,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: params.email,
        password: params.phone,
      );
      log('Firebase Auth: Signed in successfully');
      return const Left(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return _createFirebaseUser(params);
      } else if (e.code == 'wrong-password') {
        log('Firebase Auth: Wrong password');
        return const Right(
            FirebaseFailure(message: 'Wrong password provided for that user.'));
      }
      log('Firebase Auth: Error - ${e.code}');
      return Right(FirebaseFailure(message: 'Firebase Auth error: ${e.code}'));
    } catch (e) {
      log('Firebase Auth: Unexpected error - $e');
      return const Right(FirebaseFailure(message: 'Error signing in'));
    }
  }

  Future<Either<Unit, Failure>> _createFirebaseUser(
    FirebaseSignInParams params,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.phone,
      );
      log('Firebase Auth: Created new user and signed in');
      return const Left(unit);
    } catch (e) {
      log('Firebase Auth: Error creating user - $e');
      return Right(
          FirebaseFailure(message: 'Error creating Firebase user: $e'));
    }
  }
}
