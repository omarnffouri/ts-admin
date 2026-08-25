import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/params/firebase_sign_in_params.dart';

import '../../domain/repositories/firebase_repository.dart';
import '../data_sources/firebase_remote_datasource.dart';

class FirebaseRepositoryImpl extends IFirebaseRepository {
  final IFirebaseRemoteDataSource _dataSource;
  final INetworkInfo _networkInfo;

  FirebaseRepositoryImpl({
    required IFirebaseRemoteDataSource dataSource,
    required INetworkInfo networkInfo,
  })  : _dataSource = dataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Unit, Failure>> signInToFirebase(
      FirebaseSignInParams params) async {
    if (await _networkInfo.isConnected) {
      try {
        return await _dataSource.signInToFirebase(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
