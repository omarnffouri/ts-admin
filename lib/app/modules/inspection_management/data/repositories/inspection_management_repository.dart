import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/inspection_management/data/models/inspection_details_model.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/inspection_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_driver_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_truck_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../domain/repositories/inspection_management_repository.dart';
import '../datasources/inspection_management_remote_datasource.dart';
import '../models/inspection_dropdown_model.dart';

class InspectionManagementRepositoryImpl
    implements IInspectionManagementRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  IInspectionManagementRemoteDataSource dataSource;
  InspectionManagementRepositoryImpl({required this.dataSource});

  @override
  Future<Either<bool, Failure>> sumbitRequest(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.sumbitRequest(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<List<InspectionDriverEntity>, Failure>> getPendingDriver(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getPendingDriver(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<List<InspectionDriverEntity>, Failure>> getInspectedDriver(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getInspectedDriver(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<List<InspectionTrailerTruckEntity>, Failure>>
      getPendingTrailerTruck(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getPendingTrailerTruck(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<List<InspectionTrailerTruckEntity>, Failure>>
      getInspectedTrailerTruck(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getInspectedTrailerTruck(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<List<InspectionEntity>, Failure>> getInspectionFields(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getInspectionFields(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> deleteInspection(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteInspection(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<InspectionDetailsModel, Failure>> getInspectionDetails(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getInspectionDetails(params);
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<InspectionDropdownModel, Failure>>
      getInspectionDropdown() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getInspectionDropdown();
      } catch (e) {
        return Right(ServerFailure(title: '', message: e.toString()));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> createInspectionRequest(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createInspectionRequest(params);
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
