import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/data/datasources/shipment_remote_datasource.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_dropdowns_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/resolve_additional_pay_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../models/shipment_details_model.dart';

class ShipmentRepositoryImp extends IShipmentRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final IShipmentRemoteDataSource dataSource;

  ShipmentRepositoryImp({required this.dataSource});

  @override
  Future<Either<BaseResponse<ShipmentDropdownsPlayloadEntity>, Failure>>
      getCSDropdownsValues() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getCSDropdownsValues();
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
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
  Future<Either<BaseResponse<List<ShipmentEntity>>, Failure>> getAllShipments(
    Map<String, dynamic> params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllShipments(params);
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
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
  Future<Either<BaseResponse<ShipmentDetailsModel>, Failure>>
      getShipmentDetails(int params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getShipmentDetails(params);
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
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
  Future<Either<BaseResponse<bool>, Failure>> creatShipmentTemplate(
      FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.creatShipmentTemplate(params);
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
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
  Future<Either<BaseResponse<List<ShipmentEntity>>, Failure>>
      getTemplateShipments() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getTemplateShipments();
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
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
  Future<Either<BaseResponse<bool>, Failure>> updateShipmentTemplate(
      FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateShipmentTemplate(params);
        return response.fold(
          (resposne) => Left(resposne),
          (failure) => Right(failure),
        );
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
  Future<Either<BaseResponse<AdditionalPayPayloadEntity>, Failure>>
      getAdditionalPays(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAdditionalPays(params);
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
  Future<Either<AdditionalPayEntity, Failure>> resolveAdditionalPay(
    ResolveAdditionalPayParams params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.resolveAdditionalPay(params);
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
