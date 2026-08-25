import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../models/create_dropdown_model.dart';
import '../models/device_type_model.dart';
import '../models/trailer_model.dart';
import '../models/vehicle_details_model.dart';
import '../models/selected_device_model.dart';
import '../models/truck_model.dart';
import '../models/teams_model.dart';

typedef Body = Map<String, dynamic>;

abstract class IAssetsRemoteDataSource {
  Future<Either<BaseResponse<List<TruckModel>>, Failure>> getAllTrucks(
    Body body,
  );
  Future<Either<TruckModel, Failure>> getSingleTruck(Body body);
  Future<Either<VehicleDetailsModel, Failure>> getTruckDetails(Body body);
  Future<Either<bool, Failure>> deleteTruckDocument(Body body);
  Future<Either<bool, Failure>> updateChecklist(Body body);
  Future<Either<bool, Failure>> createNewDocuments(FormData body);
  Future<Either<bool, Failure>> uploadDocumentPictures(FormData body);
  Future<Either<bool, Failure>> updateDocument(FormData body);
  Future<Either<bool, Failure>> updateDocumentExpiration(Body body);
  Future<Either<bool, Failure>> uploadPictures(FormData body);
  Future<Either<bool, Failure>> uninstallDevice(Body body);
  Future<Either<bool, Failure>> addNewNote(Body body);
  Future<Either<List<TeamsModel>, Failure>> getAllTeams();
  Future<Either<List<DeviceTypeModel>, Failure>> getDeviceTypes();
  Future<Either<List<SelectedDeviceModel>, Failure>> getDeviceSeriaLS(
    Body body,
  );
  Future<Either<bool, Failure>> installDevice(Body body);

  Future<Either<BaseResponse<List<TrailerModel>>, Failure>> getAllTrailers(
    Body body,
  );
  Future<Either<TrailerModel, Failure>> getSingleTrailer(Body body);
  Future<Either<VehicleDetailsModel, Failure>> getTrailerDetails(Body body);
  Future<Either<bool, Failure>> deleteTrailerDocument(Body body);

  Future<Either<CreateDropdownModel, Failure>> getCreateDropdown(Body body);
  Future<Either<bool, Failure>> createVehicle(Body body);
  Future<Either<bool, Failure>> updateVehicle(Body body);
}

class AssetsRemoteDataSourceImpl implements IAssetsRemoteDataSource {
  final DioClient dioClient;
  AssetsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<BaseResponse<List<TruckModel>>, Failure>> getAllTrucks(
    Body body,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllTrucks,
        data: body,
        converter: (response) => BaseResponse.listFromJson(
          response,
          (x) => TruckModel.fromJson(x),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<TruckModel, Failure>> getSingleTruck(Body params) async {
    try {
      final id = params['id'];
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.getSingleTruck}/$id",
        data: params,
        converter: (response) {
          try {
            return TruckModel.fromJson(
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
  Future<Either<VehicleDetailsModel, Failure>> getTruckDetails(
      Body params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getTruckDetails,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return VehicleDetailsModel.fromJson(
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
  Future<Either<bool, Failure>> deleteTruckDocument(Body params) async {
    try {
      final bool isOtherDocument = params['isOtherDocument'] ?? false;
      final id = params['id'];
      final url = isOtherDocument
          ? "${ApiConstants.deleteTruckOtherDocument}/$id"
          : "${ApiConstants.deleteTruckDocument}/$id";
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return true;
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
  Future<Either<bool, Failure>> updateChecklist(Body params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateChecklist,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return true;
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
  Future<Either<bool, Failure>> createNewDocuments(FormData body) async {
    try {
      final bool isTrailer =
          body.fields.any((field) => field.key == 'isTrailer');
      final url = isTrailer
          ? ApiConstants.createTrailerDocumentRequest
          : ApiConstants.createTruckDocumentRequest;
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          try {
            return (response["code"] == 200 || response["code"] == 201);
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
  Future<Either<bool, Failure>> uploadDocumentPictures(FormData body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.uploadDocumentPictures,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          try {
            return (response["code"] == 200 || response["code"] == 201);
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
  Future<Either<bool, Failure>> updateDocument(FormData body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateDocumentRequest,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          try {
            return (response["code"] == 200 || response["code"] == 201);
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
  Future<Either<bool, Failure>> updateDocumentExpiration(Body params) async {
    try {
      final bool isTrailer = params['isTrailer'] ?? false;
      final url = isTrailer
          ? ApiConstants.updateTrailerDocumentExpiration
          : ApiConstants.updateTruckDocumentExpiration;
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return true;
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
  Future<Either<bool, Failure>> uploadPictures(FormData body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.uploadPictures,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          try {
            return (response["code"] == 200 || response["code"] == 201);
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
  Future<Either<bool, Failure>> uninstallDevice(Body params) async {
    try {
      final bool isTrailer = params['isTrailer'] ?? false;
      final url = isTrailer
          ? ApiConstants.uninstallTrailerDevice
          : ApiConstants.uninstallTruckDevice;
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return true;
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
  Future<Either<bool, Failure>> addNewNote(Body params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.addNewNote,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return true;
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
  Future<Either<List<TeamsModel>, Failure>> getAllTeams() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllTeams,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => TeamsModel.fromJson(e))
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
  Future<Either<List<DeviceTypeModel>, Failure>> getDeviceTypes() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getDeviceTypes,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => DeviceTypeModel.fromJson(e))
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
  Future<Either<List<SelectedDeviceModel>, Failure>> getDeviceSeriaLS(
    Body body,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getSelectedDevice,
        data: body,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => SelectedDeviceModel.fromJson(e))
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
  Future<Either<bool, Failure>> installDevice(Body body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.installNewDevice,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          try {
            return true;
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
  Future<Either<BaseResponse<List<TrailerModel>>, Failure>> getAllTrailers(
    Body body,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllTrailers,
        data: body,
        converter: (response) => BaseResponse.listFromJson(
          response,
          (x) => TrailerModel.fromJson(x),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<TrailerModel, Failure>> getSingleTrailer(Body params) async {
    try {
      final id = params['id'];
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.getSingleTrailer}/$id",
        data: params,
        converter: (response) {
          try {
            return TrailerModel.fromJson(
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
  Future<Either<VehicleDetailsModel, Failure>> getTrailerDetails(
      Body params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getTrailerDetails,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return VehicleDetailsModel.fromJson(
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
  Future<Either<bool, Failure>> deleteTrailerDocument(Body params) async {
    try {
      final bool isOtherDocument = params['isOtherDocument'] ?? false;
      final id = params['id'];
      final url = isOtherDocument
          ? "${ApiConstants.deleteTrailerOtherDocument}/$id"
          : "${ApiConstants.deleteTrailerDocument}/$id";
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return true;
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
  Future<Either<CreateDropdownModel, Failure>> getCreateDropdown(
    Body body,
  ) async {
    final bool isTrailer = body['isTrailer'] ?? false;
    final url = isTrailer
        ? ApiConstants.getTrailerCreateData
        : ApiConstants.getTruckCreateData;
    try {
      final response = await dioClient.makeRequest(
        url: url,
        data: body,
        converter: (response) {
          try {
            return CreateDropdownModel.fromJson(
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
  Future<Either<bool, Failure>> createVehicle(Body body) async {
    final bool isTrailer = body['isTrailer'] ?? false;
    final url =
        isTrailer ? ApiConstants.createTrailer : ApiConstants.createTruck;
    try {
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          try {
            return true;
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
  Future<Either<bool, Failure>> updateVehicle(Body body) async {
    final id = body['id'];
    final bool isTrailer = body['isTrailer'] ?? false;
    final url = isTrailer
        ? "${ApiConstants.updateTrailer}/$id/update"
        : "${ApiConstants.updateTruck}/$id/update";
    try {
      final response = await dioClient.makeRequest(
        url: url,
        method: RequestType.PUT,
        data: body,
        converter: (response) {
          try {
            return true;
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
