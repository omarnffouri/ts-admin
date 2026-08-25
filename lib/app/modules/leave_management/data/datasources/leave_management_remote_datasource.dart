import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/data/models/leave_history_model.dart';

import '../../../../core/network/connection/api_constants.dart';
import '../../domain/usecases/check_eligibility_usecase.dart';
import '../models/alternative_user_model.dart';
import '../models/eligibility_model.dart';
import '../models/incoming_user_leave_request_model.dart';
import '../models/leave_type_model.dart';
import '../models/remaining_leave_category_model.dart';
import '../models/requested_leave_model.dart';
import '../models/super_visor_model.dart';

abstract class ILeaveManagementRemoteDataSource {
  //! new request
  Future<Either<List<LeaveTypeModel>, Failure>> getAllLeaveTypes();
  Future<Either<List<RemainingLeaveCategoryModel>, Failure>>
      getRemainingLeavesPerCategory();
  Future<Either<List<SupervisorModel>, Failure>> getAllSupervisors(
    Map<String, dynamic> params,
  );
  Future<Either<List<AlternativeUserModel>, Failure>> getAlternativeUsers();
  Future<Either<EligibilityModel, Failure>> checkEligibility(
    CheckEligibilityParams params,
  );
  Future<Either<bool, Failure>> sumbitLeaveRequest(FormData params);

  //! my leave requested
  Future<Either<List<RequestModel>, Failure>> getRequestedLeaves(
    Map<String, dynamic> params,
  );

  //! manage leave requests
  Future<Either<List<UserLeaveRequestModel>, Failure>>
      getUsersRequestedLeaves();
  Future<Either<bool, Failure>> adminAction(Map<String, dynamic> params);

  //! leave history
  Future<Either<List<LeaveHistoryModel>, Failure>> getRequestedHistory();
}

class LeaveManagementRemoteDataSourceImpl
    implements ILeaveManagementRemoteDataSource {
  final DioClient dioClient;
  LeaveManagementRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<List<LeaveTypeModel>, Failure>> getAllLeaveTypes() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getLeaveTypes,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => LeaveTypeModel.fromJson(e))
                    .toList() ??
                [];
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<RemainingLeaveCategoryModel>, Failure>>
      getRemainingLeavesPerCategory() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.remainingLeavesPerCategory,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => RemainingLeaveCategoryModel.fromJson(e))
                    .toList() ??
                [];
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<SupervisorModel>, Failure>> getAllSupervisors(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getSupervisors,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => SupervisorModel.fromJson(e))
                .toList();
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<AlternativeUserModel>, Failure>>
      getAlternativeUsers() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAlternativeUsers,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => AlternativeUserModel.fromJson(e))
                .toList();
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<EligibilityModel, Failure>> checkEligibility(
      CheckEligibilityParams params) async {
    try {
      final response = await dioClient.makeRequest(
        method: RequestType.POST,
        url: ApiConstants.checkEligibility,
        data: params.toMap(),
        converter: (response) {
          try {
            return EligibilityModel.fromJson(response['data']);
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> sumbitLeaveRequest(FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        method: RequestType.POST,
        data: params,
        url: ApiConstants.submitLeaveRequest,
        converter: (response) {
          try {
            return response['code'] == 200;
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //! leave requested
  @override
  Future<Either<List<RequestModel>, Failure>> getRequestedLeaves(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getRequestedLeaves,
        data: params,
        converter: (response) {
          try {
            if (response['data'] == null) {
              return <RequestModel>[];
            }
            return (response['data'] as List? ?? [])
                .map((e) => RequestModel.fromJson(e))
                .toList();
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //! manage leave requests
  @override
  Future<Either<List<UserLeaveRequestModel>, Failure>>
      getUsersRequestedLeaves() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getUsersLeaves,
        converter: (response) {
          try {
            if (response['data'] == null) {
              return <UserLeaveRequestModel>[];
            }
            return (response['data'] as List? ?? [])
                .map((e) => UserLeaveRequestModel.fromJson(e))
                .toList();
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> adminAction(Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        method: RequestType.PUT,
        url: ApiConstants.adminAction,
        data: params,
        converter: (response) {
          try {
            return response['code'] == 200;
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //! leave history
  @override
  Future<Either<List<LeaveHistoryModel>, Failure>> getRequestedHistory() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getLeaveHistory,
        converter: (response) {
          try {
            if (response['data'] == null) {
              return <LeaveHistoryModel>[];
            }
            return (response['data'] as List? ?? [])
                .map((e) => LeaveHistoryModel.fromJson(e))
                .toList();
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
