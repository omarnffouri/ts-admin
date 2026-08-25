import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/data_entity.dart';
import '../entities/rule_entity.dart';
import '../entities/user_entity.dart';

abstract class IUserManagementRepository {
  //! new request
  Future<Either<bool, Failure>> createAdmin(Map<String, dynamic> params);
  Future<Either<bool, Failure>> updateAdmin(Map<String, dynamic> params);
  Future<Either<bool, Failure>> updateUserStatus(Map<String, dynamic> params);
  Future<Either<bool, Failure>> updateAdminPassword(
      Map<String, dynamic> params);
  Future<Either<BaseResponse<List<UserEntity>>, Failure>> getAllUsers(
      Map<String, dynamic> params);
  Future<Either<List<RuleEntity>, Failure>> getAllRules();
  Future<Either<List<DataEntity>, Failure>> getAllCountries();
  Future<Either<List<DataEntity>, Failure>> getAllSupervisors();
  Future<Either<List<DataEntity>, Failure>> getAllDepartments();
  Future<Either<List<DataEntity>, Failure>> getAllDesignations();
  Future<Either<List<DataEntity>, Failure>> getUserOffDays();
  Future<Either<bool, Failure>> deleteUser(String params);
}
