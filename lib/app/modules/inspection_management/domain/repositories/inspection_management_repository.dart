import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/inspection_details_entity.dart';
import '../entities/inspection_entity.dart';
import '../entities/pending_driver_entity.dart';
import '../entities/pending_truck_entity.dart';
import '../entities/inspection_dropdown_entity.dart';

abstract class IInspectionManagementRepository {
  //! new request
  Future<Either<bool, Failure>> sumbitRequest(
    Map<String, dynamic> params,
  );

  //! driver
  Future<Either<List<InspectionDriverEntity>, Failure>> getPendingDriver(
    Map<String, dynamic> params,
  );

  Future<Either<List<InspectionDriverEntity>, Failure>> getInspectedDriver(
    Map<String, dynamic> params,
  );

  //! trailer truck
  Future<Either<List<InspectionTrailerTruckEntity>, Failure>>
      getPendingTrailerTruck(
    Map<String, dynamic> params,
  );
  Future<Either<List<InspectionTrailerTruckEntity>, Failure>>
      getInspectedTrailerTruck(
    Map<String, dynamic> params,
  );

  //! inspection fields
  Future<Either<List<InspectionEntity>, Failure>> getInspectionFields(
    Map<String, dynamic> params,
  );

  //! delete inspection
  Future<Either<bool, Failure>> deleteInspection(Map<String, dynamic> params);

  Future<Either<InspectionDetailsEntity, Failure>> getInspectionDetails(
    Map<String, dynamic> params,
  );

  Future<Either<InspectionDropdownEntity, Failure>> getInspectionDropdown();

  Future<Either<bool, Failure>> createInspectionRequest(
    Map<String, dynamic> params,
  );
}
