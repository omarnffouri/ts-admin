import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/assets_management/data/models/teams_model.dart';
import 'package:ts_admin/app/modules/assets_management/data/models/truck_model.dart';
import '../../../../services/injection_service.dart';
import '../../domain/repositories/assets_repository.dart';
import '../datasource/assets_remote_datasource.dart';
import '../models/create_dropdown_model.dart';
import '../models/device_type_model.dart';
import '../models/selected_device_model.dart';
import '../models/trailer_model.dart';
import '../models/vehicle_details_model.dart';

typedef Body = Map<String, dynamic>;

class AssetsRepositoryImpl extends IAssetsRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  IAssetsRemoteDataSource dataSource;

  AssetsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<BaseResponse<List<TruckModel>>, Failure>> getAllTrucks(
    Body body,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllTrucks(body);
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
  Future<Either<TruckModel, Failure>> getSingleTruck(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getSingleTruck(body);
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
  Future<Either<VehicleDetailsModel, Failure>> getTruckDetails(
      Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getTruckDetails(body);
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
  Future<Either<bool, Failure>> deleteTruckDocument(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteTruckDocument(body);
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
  Future<Either<bool, Failure>> updateChecklist(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.updateChecklist(body);
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
  Future<Either<bool, Failure>> createNewDocuments(FormData body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createNewDocuments(body);
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
  Future<Either<bool, Failure>> uploadDocumentPictures(FormData body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.uploadDocumentPictures(body);
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
  Future<Either<bool, Failure>> updateDocument(FormData body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.updateDocument(body);
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
  Future<Either<bool, Failure>> updateDocumentExpiration(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.updateDocumentExpiration(body);
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
  Future<Either<bool, Failure>> uploadPictures(FormData body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.uploadPictures(body);
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
  Future<Either<bool, Failure>> uninstallDevice(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.uninstallDevice(body);
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
  Future<Either<bool, Failure>> addNewNote(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.addNewNote(body);
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
  Future<Either<List<TeamsModel>, Failure>> getAllTeams() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllTeams();
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
  Future<Either<List<DeviceTypeModel>, Failure>> getDeviceTypes() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getDeviceTypes();
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
  Future<Either<List<SelectedDeviceModel>, Failure>> getDeviceSerials(
    Body body,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getDeviceSeriaLS(body);
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
  Future<Either<bool, Failure>> installDevice(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.installDevice(body);
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
  Future<Either<BaseResponse<List<TrailerModel>>, Failure>> getAllTrailers(
    Body body,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllTrailers(body);
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
  Future<Either<TrailerModel, Failure>> getSingleTrailer(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getSingleTrailer(body);
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
  Future<Either<VehicleDetailsModel, Failure>> getTrailerDetails(
      Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getTrailerDetails(body);
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
  Future<Either<bool, Failure>> deleteTrailerDocument(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteTrailerDocument(body);
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
  Future<Either<CreateDropdownModel, Failure>> getCreateDropdown(
    Body body,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getCreateDropdown(body);
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
  Future<Either<bool, Failure>> createVehicle(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createVehicle(body);
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
  Future<Either<bool, Failure>> updateVehicle(Body body) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.updateVehicle(body);
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
