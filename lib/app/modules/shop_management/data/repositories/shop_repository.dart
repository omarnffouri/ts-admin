import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/data/models/purchase_order_model.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_datasource.dart';
import '../models/client_model.dart';
import '../models/service_dropdown_model.dart';
import '../models/service_order_model.dart';
import '../models/shop_inventory_model.dart';
import '../models/supplier_model.dart';

typedef Body = Map<String, dynamic>;

class ShopRepositoryImp extends IShopRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final IShopRemoteDataSource dataSource;

  ShopRepositoryImp({required this.dataSource});

  // service orders
  @override
  Future<Either<List<ServiceOrdermodel>, Failure>> getAllServiceOrders() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllServiceOrders();
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
  Future<Either<ServiceOrdermodel, Failure>> getServiceOrderDetails(
    Body params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getServiceOrderDetails(params);
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
  Future<Either<ServiceDropdownModel, Failure>> getServiceDropdown() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getServiceDropdown();
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
  Future<Either<List<ItemModel>, Failure>> getCarrierVehicles(
    Body params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getCarrierVehicles(params);
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
  Future<Either<bool, Failure>> createOrEditServiceOrder(
    FormData params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createOrEditServiceOrder(params);
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
  Future<Either<bool, Failure>> changeServiceOrderStatus(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.changeServiceOrderStatus(params);
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
  Future<Either<bool, Failure>> completeServiceOrder(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.completeServiceOrder(params);
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
  Future<Either<bool, Failure>> resubmitServiceOrder(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.resubmitServiceOrder(params);
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
  Future<Either<CustomerModel, Failure>> getCustomerDetails(
    Body params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getCustomerDetails(params);
      } catch (e) {
        return Right(ServerFailure(title: '', message: e.toString()));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  // inventory
  @override
  Future<Either<List<ShopInventoryModel>, Failure>>
      getAllShopInventories() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllShopInventories();
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
  Future<Either<bool, Failure>> createInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createInventory(params);
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
  Future<Either<bool, Failure>> editInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.editInventory(params);
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
  Future<Either<bool, Failure>> disableInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableInventory(params);
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
  Future<Either<bool, Failure>> deleteInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteInventory(params);
      } catch (e) {
        return Right(ServerFailure(title: '', message: e.toString()));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  // supplier
  @override
  Future<Either<List<SupplierModel>, Failure>> getAllSuppliers() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllSuppliers();
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
  Future<Either<bool, Failure>> createSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createSupplier(params);
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
  Future<Either<bool, Failure>> editSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.editSupplier(params);
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
  Future<Either<bool, Failure>> disableSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableSupplier(params);
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
  Future<Either<bool, Failure>> deleteSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteSupplier(params);
      } catch (e) {
        return Right(ServerFailure(title: '', message: e.toString()));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  // clients
  @override
  Future<Either<List<ClientModel>, Failure>> getAllClients() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllClients();
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
  Future<Either<bool, Failure>> createOrEditClient(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createOrEditClient(params);
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
  Future<Either<bool, Failure>> disableClient(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableClient(params);
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
  Future<Either<List<TechnicianEntity>, Failure>> getAllTechnicians() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllTechnicians();
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
  Future<Either<bool, Failure>> createTechnician(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createTechnician(params);
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
  Future<Either<bool, Failure>> editTechnician(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.editTechnician(params);
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
  Future<Either<bool, Failure>> disableTechnician(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableTechnician(params);
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
  Future<Either<bool, Failure>> deleteTechnician(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteTechnician(params);
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
  Future<Either<bool, Failure>> createPurchaseOrder(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createPurchaseOrder(params);
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
  Future<Either<bool, Failure>> editPurchaseOrder(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.editPurchaseOrder(params);
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
  Future<Either<List<PurchaseOrderModel>, Failure>>
      getAllPurchaseOrders() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllPurchaseOrders();
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
  Future<Either<PurchaseOrderModel, Failure>> getPurchaseDetails(
      Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getPurchaseDetails(params);
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
  Future<Either<bool, Failure>> changePurchaseOrderStatus(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.changePurchaseOrderStatus(params);
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
  Future<Either<List<ShopInventoryModel>, Failure>>
      getAllUsedInventories() async {
    if (await networkInfo.isConnected) {
      try {
        return dataSource.getAllUsedInventories();
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
  Future<Either<bool, Failure>> createUsedInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createUsedInventory(params);
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
  Future<Either<bool, Failure>> editUsedInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.editUsedInventory(params);
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
  Future<Either<bool, Failure>> deleteUsedInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteUsedInventory(params);
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
  Future<Either<bool, Failure>> disableUsedInventory(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableUsedInventory(params);
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
  Future<Either<List<SupplierModel>, Failure>> getAllUsedSuppliers() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllUsedSuppliers();
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
  Future<Either<bool, Failure>> createUsedSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createUsedSupplier(params);
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
  Future<Either<bool, Failure>> deleteUsedSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.deleteUsedSupplier(params);
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
  Future<Either<bool, Failure>> disableUsedSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableUsedSupplier(params);
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
  Future<Either<bool, Failure>> editUsedSupplier(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.editUsedSupplier(params);
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
  Future<Either<bool, Failure>> createOrEditUsedClient(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.createOrEditUsedClient(params);
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
  Future<Either<bool, Failure>> disableUsedClient(Body params) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.disableUsedClient(params);
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
  Future<Either<List<ClientModel>, Failure>> getAllUsedClients() async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getAllUsedClients();
      } catch (e) {
        return Right(ServerFailure(title: '', message: e.toString()));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
