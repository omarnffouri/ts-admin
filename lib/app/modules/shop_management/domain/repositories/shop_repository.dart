import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';

import '../entities/purchase_order_entity.dart';
import '../entities/service_dropdown_entity.dart';
import '../entities/service_order_entity.dart';
import '../entities/shop_inventory_entity.dart';
import '../entities/supplier_entity.dart';
import '../entities/client_entity.dart';

typedef Body = Map<String, dynamic>;

abstract class IShopRepository {
  // service orders
  Future<Either<List<ServiceOrderEntity>, Failure>> getAllServiceOrders();
  Future<Either<ServiceOrderEntity, Failure>> getServiceOrderDetails(
    Body params,
  );
  Future<Either<ServiceDropdownEntity, Failure>> getServiceDropdown();
  Future<Either<List<ItemEntity>, Failure>> getCarrierVehicles(Body params);
  Future<Either<bool, Failure>> createOrEditServiceOrder(FormData params);
  Future<Either<bool, Failure>> changeServiceOrderStatus(Body params);
  Future<Either<bool, Failure>> completeServiceOrder(FormData params);
  Future<Either<CustomerEntity, Failure>> getCustomerDetails(Body params);
  Future<Either<bool, Failure>> resubmitServiceOrder(Body params);

  //
  //
  // inventory
  Future<Either<List<ShopInventoryEntity>, Failure>> getAllShopInventories();
  Future<Either<bool, Failure>> createInventory(Body params);
  Future<Either<bool, Failure>> editInventory(Body params);
  Future<Either<bool, Failure>> deleteInventory(Body params);
  Future<Either<bool, Failure>> disableInventory(Body params);

  //
  //
  // supplier
  Future<Either<List<SupplierEntity>, Failure>> getAllSuppliers();
  Future<Either<bool, Failure>> createSupplier(Body params);
  Future<Either<bool, Failure>> editSupplier(Body params);
  Future<Either<bool, Failure>> deleteSupplier(Body params);
  Future<Either<bool, Failure>> disableSupplier(Body params);

  //
  //
  // clients
  Future<Either<List<ClientEntity>, Failure>> getAllClients();
  Future<Either<bool, Failure>> createOrEditClient(Body params);
  Future<Either<bool, Failure>> disableClient(Body params);

  //
  //
  // technicians
  Future<Either<List<TechnicianEntity>, Failure>> getAllTechnicians();
  Future<Either<bool, Failure>> createTechnician(Body params);
  Future<Either<bool, Failure>> editTechnician(Body params);
  Future<Either<bool, Failure>> deleteTechnician(Body params);
  Future<Either<bool, Failure>> disableTechnician(Body params);

  //
  //
  //used-part inventory
  Future<Either<List<ShopInventoryEntity>, Failure>> getAllUsedInventories();
  Future<Either<bool, Failure>> createUsedInventory(Body params);
  Future<Either<bool, Failure>> editUsedInventory(Body params);
  Future<Either<bool, Failure>> deleteUsedInventory(Body params);
  Future<Either<bool, Failure>> disableUsedInventory(Body params);

  // used-part supplier
  Future<Either<List<SupplierEntity>, Failure>> getAllUsedSuppliers();
  Future<Either<bool, Failure>> createUsedSupplier(Body params);
  Future<Either<bool, Failure>> editUsedSupplier(Body params);
  Future<Either<bool, Failure>> deleteUsedSupplier(Body params);
  Future<Either<bool, Failure>> disableUsedSupplier(Body params);

  // used-part client
  Future<Either<bool, Failure>> createOrEditUsedClient(Body params);
  Future<Either<List<ClientEntity>, Failure>> getAllUsedClients();
  Future<Either<bool, Failure>> disableUsedClient(Body params);

  // used-part purchase orders
  Future<Either<List<PurchaseOrderEntity>, Failure>> getAllPurchaseOrders();
  Future<Either<PurchaseOrderEntity, Failure>> getPurchaseDetails(Body params);
  Future<Either<bool, Failure>> createPurchaseOrder(Body params);
  Future<Either<bool, Failure>> editPurchaseOrder(Body params);
  Future<Either<bool, Failure>> changePurchaseOrderStatus(Body params);
}
