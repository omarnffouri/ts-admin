import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import '../../../../core/values/constants.dart';

abstract class IFormRepository {
  Future<Either<List<FormEntity>, Failure>> getAllForms();
  Future<Either<bool, Failure>> signForm(MapBody params);
  Future<Either<bool, Failure>> rejectForm(MapBody params);
}
