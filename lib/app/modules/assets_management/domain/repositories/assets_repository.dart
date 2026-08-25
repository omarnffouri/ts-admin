import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/trailer_entity.dart';

import '../entities/create_dropdown_entity.dart';
import '../entities/device_type_entity.dart';
import '../entities/selected_device_entity.dart';
import '../entities/teams_entity.dart';
import '../entities/vehicle_details_entity.dart';
import '../entities/truck_entity.dart';

typedef Body = Map<String, dynamic>;

abstract class IAssetsRepository {
  Future<Either<BaseResponse<List<TruckEntity>>, Failure>> getAllTrucks(
    Body body,
  );
  Future<Either<TruckEntity, Failure>> getSingleTruck(Body body);
  Future<Either<VehicleDetailsEntity, Failure>> getTruckDetails(Body body);
  Future<Either<bool, Failure>> deleteTruckDocument(Body body);
  Future<Either<bool, Failure>> updateChecklist(Body body);
  Future<Either<bool, Failure>> createNewDocuments(FormData body);
  Future<Either<bool, Failure>> uploadDocumentPictures(FormData body);
  Future<Either<bool, Failure>> updateDocument(FormData body);
  Future<Either<bool, Failure>> updateDocumentExpiration(Body body);
  Future<Either<bool, Failure>> uploadPictures(FormData body);
  Future<Either<bool, Failure>> uninstallDevice(Body body);
  Future<Either<bool, Failure>> addNewNote(Body body);
  Future<Either<List<TeamsEntity>, Failure>> getAllTeams();
  Future<Either<List<DeviceTypeEntity>, Failure>> getDeviceTypes();
  Future<Either<List<SelectedDeviceEntity>, Failure>> getDeviceSerials(
    Body body,
  );
  Future<Either<bool, Failure>> installDevice(Body body);

  Future<Either<BaseResponse<List<TrailerEntity>>, Failure>> getAllTrailers(
    Body body,
  );
  Future<Either<TrailerEntity, Failure>> getSingleTrailer(Body body);
  Future<Either<VehicleDetailsEntity, Failure>> getTrailerDetails(Body body);
  Future<Either<bool, Failure>> deleteTrailerDocument(Body body);
  Future<Either<CreateDropdownEntity, Failure>> getCreateDropdown(
    Body body,
  );
  Future<Either<bool, Failure>> createVehicle(Body body);
  Future<Either<bool, Failure>> updateVehicle(Body body);
}
