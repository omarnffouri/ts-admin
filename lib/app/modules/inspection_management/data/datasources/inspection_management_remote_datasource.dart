import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../../../core/network/connection/api_constants.dart';
import '../models/inspection__trailer_truck_model.dart';
import '../models/inspection_details_model.dart';
import '../models/inspection_driver_model.dart';
import '../models/inspection_model.dart';
import '../models/inspection_dropdown_model.dart';

abstract class IInspectionManagementRemoteDataSource {
  //! new request
  Future<Either<bool, Failure>> sumbitRequest(
    Map<String, dynamic> params,
  );

  //! driver
  Future<Either<List<InspectionDriverModel>, Failure>> getPendingDriver(
    Map<String, dynamic> params,
  );

  Future<Either<List<InspectionDriverModel>, Failure>> getInspectedDriver(
    Map<String, dynamic> params,
  );

  //! trailer truck
  Future<Either<List<InspectionTrailerTruckModel>, Failure>>
      getPendingTrailerTruck(
    Map<String, dynamic> params,
  );
  Future<Either<List<InspectionTrailerTruckModel>, Failure>>
      getInspectedTrailerTruck(
    Map<String, dynamic> params,
  );

  //! inspection fields
  Future<Either<List<InspectionModel>, Failure>> getInspectionFields(
    Map<String, dynamic> params,
  );

  //! delete inspection
  Future<Either<bool, Failure>> deleteInspection(Map<String, dynamic> params);

  Future<Either<InspectionDetailsModel, Failure>> getInspectionDetails(
    Map<String, dynamic> params,
  );

  Future<Either<InspectionDropdownModel, Failure>> getInspectionDropdown();

  Future<Either<bool, Failure>> createInspectionRequest(
    Map<String, dynamic> params,
  );
}

class InspectionManagementRemoteDataSourceImpl
    implements IInspectionManagementRemoteDataSource {
  final DioClient dioClient;
  InspectionManagementRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<bool, Failure>> sumbitRequest(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.sumbitInspectionRequest,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          //todo optimize this error handling
          try {
            if (response['code'] == 200) {
              return true;
            }
            throw Exception(response['message']);
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
  Future<Either<List<InspectionDriverModel>, Failure>> getPendingDriver(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionRequests,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => InspectionDriverModel.fromJson(e))
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
  Future<Either<List<InspectionDriverModel>, Failure>> getInspectedDriver(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionInspected,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => InspectionDriverModel.fromJson(e))
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
  Future<Either<List<InspectionTrailerTruckModel>, Failure>>
      getPendingTrailerTruck(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionRequests,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => InspectionTrailerTruckModel.fromJson(e))
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
  Future<Either<List<InspectionTrailerTruckModel>, Failure>>
      getInspectedTrailerTruck(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionInspected,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => InspectionTrailerTruckModel.fromJson(e))
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
  Future<Either<List<InspectionModel>, Failure>> getInspectionFields(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionFields,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => InspectionModel.fromJson(e))
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
  Future<Either<bool, Failure>> deleteInspection(Map<String, dynamic> params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.deleteInspection,
        data: params,
        method: RequestType.DELETE,
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

  @override
  Future<Either<InspectionDetailsModel, Failure>> getInspectionDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionDetails,
        data: params,
        converter: (response) {
          try {
            //todo optqimize this
            if (response['data'].isEmpty) {
              return const InspectionDetailsModel();
            }
            return InspectionDetailsModel.fromJson(
              response['data'] as Map<String, dynamic>,
            );
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
  Future<Either<InspectionDropdownModel, Failure>>
      getInspectionDropdown() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInspectionDropdown,
        method: RequestType.POST,
        data: {
          "lookup": {
            "drivers": {"status": "active"},
            "trailers": {"status": "active"},
            "trucks": {"status": "active"}
          }
        },
        converter: (response) {
          try {
            return InspectionDropdownModel.fromJson(
                response['data'] as Map<String, dynamic>);
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
  Future<Either<bool, Failure>> createInspectionRequest(
      Map<String, dynamic> params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.createInspectionRequest,
        data: params,
        method: RequestType.POST,
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
}
