import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/annoucments/domain/entities/annoucement_entity.dart';
import 'package:ts_admin/app/modules/annoucments/domain/entities/user_type_entity.dart';

abstract class IAnnoucementsRepository {
  Future<Either<List<AnnoucementEntity>, Failure>> getAllAnnoucements();
  Future<Either<bool, Failure>> createAnnoucement(FormData params);
  Future<Either<bool, Failure>> updateAnnoucementReadStatus(int annoucementId);
  Future<Either<UserTypeEntity, Failure>> getAnnoucementUserTypes();
}
