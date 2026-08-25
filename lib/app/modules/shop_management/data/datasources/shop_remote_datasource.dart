import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/data/models/purchase_order_model.dart';
import 'package:ts_admin/app/modules/shop_management/data/models/shop_inventory_model.dart';
import 'package:ts_admin/app/modules/shop_management/data/models/technician_model.dart';

import '../models/service_dropdown_model.dart';
import '../models/service_order_model.dart';
import '../models/supplier_model.dart';
import '../models/client_model.dart';

typedef Body = Map<String, dynamic>;

abstract class IShopRemoteDataSource {
  // service order
  Future<Either<List<ServiceOrdermodel>, Failure>> getAllServiceOrders();
  Future<Either<ServiceOrdermodel, Failure>> getServiceOrderDetails(
    Body params,
  );
  Future<Either<ServiceDropdownModel, Failure>> getServiceDropdown();
  Future<Either<List<ItemModel>, Failure>> getCarrierVehicles(Body params);
  Future<Either<bool, Failure>> createOrEditServiceOrder(FormData params);
  Future<Either<bool, Failure>> changeServiceOrderStatus(Body params);
  Future<Either<bool, Failure>> completeServiceOrder(FormData params);
  Future<Either<bool, Failure>> resubmitServiceOrder(Body params);
  Future<Either<CustomerModel, Failure>> getCustomerDetails(Body params);

  // inventory
  Future<Either<List<ShopInventoryModel>, Failure>> getAllShopInventories();
  Future<Either<bool, Failure>> createInventory(Body params);
  Future<Either<bool, Failure>> editInventory(Body params);
  Future<Either<bool, Failure>> disableInventory(Body params);
  Future<Either<bool, Failure>> deleteInventory(Body params);

  // suppliers
  Future<Either<List<SupplierModel>, Failure>> getAllSuppliers();
  Future<Either<bool, Failure>> createSupplier(Body params);
  Future<Either<bool, Failure>> editSupplier(Body params);
  Future<Either<bool, Failure>> disableSupplier(Body params);
  Future<Either<bool, Failure>> deleteSupplier(Body params);

  // clients
  Future<Either<List<ClientModel>, Failure>> getAllClients();
  Future<Either<bool, Failure>> createOrEditClient(Body params);
  Future<Either<bool, Failure>> disableClient(Body params);

  // technician
  Future<Either<List<TechnicianModel>, Failure>> getAllTechnicians();
  Future<Either<bool, Failure>> createTechnician(Body params);
  Future<Either<bool, Failure>> editTechnician(Body params);
  Future<Either<bool, Failure>> disableTechnician(Body params);
  Future<Either<bool, Failure>> deleteTechnician(Body params);

  //used-part inventory
  Future<Either<List<ShopInventoryModel>, Failure>> getAllUsedInventories();
  Future<Either<bool, Failure>> createUsedInventory(Body params);
  Future<Either<bool, Failure>> editUsedInventory(Body params);
  Future<Either<bool, Failure>> deleteUsedInventory(Body params);
  Future<Either<bool, Failure>> disableUsedInventory(Body params);

  // used-part supplier
  Future<Either<List<SupplierModel>, Failure>> getAllUsedSuppliers();
  Future<Either<bool, Failure>> createUsedSupplier(Body params);
  Future<Either<bool, Failure>> editUsedSupplier(Body params);
  Future<Either<bool, Failure>> deleteUsedSupplier(Body params);
  Future<Either<bool, Failure>> disableUsedSupplier(Body params);

  // used-part client
  Future<Either<bool, Failure>> createOrEditUsedClient(Body params);
  Future<Either<List<ClientModel>, Failure>> getAllUsedClients();
  Future<Either<bool, Failure>> disableUsedClient(Body params);

  // used-part purchase orders
  Future<Either<List<PurchaseOrderModel>, Failure>> getAllPurchaseOrders();
  Future<Either<PurchaseOrderModel, Failure>> getPurchaseDetails(Body params);
  Future<Either<bool, Failure>> createPurchaseOrder(Body params);
  Future<Either<bool, Failure>> editPurchaseOrder(Body params);
  Future<Either<bool, Failure>> changePurchaseOrderStatus(Body params);
}

class ShopRemoteDataSourceImp extends IShopRemoteDataSource {
  ShopRemoteDataSourceImp({required this.dioClient});
  final DioClient dioClient;
  @override
  Future<Either<List<ServiceOrdermodel>, Failure>> getAllServiceOrders() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getServiceOrders,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => ServiceOrdermodel.fromJson(e))
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
  Future<Either<ServiceOrdermodel, Failure>> getServiceOrderDetails(
    Map<String, dynamic> params,
  ) async {
    try {
      final id = params['id'];
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.getServiceOrderDetails}/$id",
        data: params,
        converter: (response) {
          try {
            return ServiceOrdermodel.fromJson(
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
  Future<Either<ServiceDropdownModel, Failure>> getServiceDropdown() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getSericeDropdowns,
        converter: (response) {
          try {
            return ServiceDropdownModel.fromJson(
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
  Future<Either<List<ItemModel>, Failure>> getCarrierVehicles(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getCarrierVehicles,
        data: params,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => ItemModel.fromJson(e))
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
  Future<Either<bool, Failure>> createOrEditServiceOrder(
      FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createOrEditServiceOrder,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> changeServiceOrderStatus(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.changeServiceOrderStatus,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> completeServiceOrder(FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.completeServiceOrder,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> resubmitServiceOrder(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.resubmitServiceOrder,
        method: RequestType.POST,
        data: params,
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
  Future<Either<CustomerModel, Failure>> getCustomerDetails(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getCustomerDetail,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return CustomerModel.fromJson(
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
  Future<Either<List<ShopInventoryModel>, Failure>>
      getAllShopInventories() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getInventoryItems,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => ShopInventoryModel.fromJson(e))
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
  Future<Either<bool, Failure>> createInventory(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createInventory,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> editInventory(
      Map<String, dynamic> params) async {
    final id = params['id'];
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.editInventoryItem}/$id/edit',
        method: RequestType.PUT,
        data: params,
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
  Future<Either<bool, Failure>> disableInventory(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.disableInventory,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> deleteInventory(
      Map<String, dynamic> params) async {
    try {
      final id = params['id'];
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.deleteInventoryItem}/$id/delete',
        method: RequestType.DELETE,
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
  Future<Either<List<SupplierModel>, Failure>> getAllSuppliers() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllSuppliers,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => SupplierModel.fromJson(e))
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
  Future<Either<bool, Failure>> createSupplier(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createSupplier,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> editSupplier(
      Map<String, dynamic> params) async {
    final id = params['id'];
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.editSupplier}/$id/edit',
        method: RequestType.PUT,
        data: params,
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
  Future<Either<bool, Failure>> disableSupplier(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.disableSupplier,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> deleteSupplier(
      Map<String, dynamic> params) async {
    try {
      final id = params['id'];
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.deleteSupplier}/$id/delete',
        method: RequestType.DELETE,
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
  Future<Either<List<ClientModel>, Failure>> getAllClients() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllClients,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => ClientModel.fromJson(e))
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
  Future<Either<bool, Failure>> createOrEditClient(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createOrEditClient,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> disableClient(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.disableClient,
        method: RequestType.POST,
        data: params,
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
  Future<Either<List<TechnicianModel>, Failure>> getAllTechnicians() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllTechnicians,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => TechnicianModel.fromJson(e))
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
  Future<Either<bool, Failure>> createTechnician(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createTechnician,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> editTechnician(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.editTechnician}/${params['id']}",
        method: RequestType.PUT,
        data: params,
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
  Future<Either<bool, Failure>> disableTechnician(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.disableTechnician,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> deleteTechnician(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.deleteTechnician}/${params['id']}',
        method: RequestType.DELETE,
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
  Future<Either<bool, Failure>> createPurchaseOrder(
    Body params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.usedPartPurchaseUrl,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> editPurchaseOrder(Body params) async {
    final id = params['id'];
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.usedPartPurchaseUrl}/$id',
        method: RequestType.PUT,
        data: params,
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
  Future<Either<List<PurchaseOrderModel>, Failure>>
      getAllPurchaseOrders() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.usedPartPurchaseUrl,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => PurchaseOrderModel.fromJson(e))
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
  Future<Either<PurchaseOrderModel, Failure>> getPurchaseDetails(Body params) {
    try {
      final id = params['id'];
      final response = dioClient.makeRequest(
        url: "${ApiConstants.usedPartPurchaseUrl}/$id/edit",
        data: params,
        converter: (response) {
          try {
            return PurchaseOrderModel.fromJson(
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
  Future<Either<bool, Failure>> changePurchaseOrderStatus(Body params) {
    final id = params['id'];
    try {
      final response = dioClient.makeRequest(
        url: '${ApiConstants.changeUsedPurchaseOrderStatus}/$id',
        method: RequestType.PUT,
        data: params,
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
  Future<Either<bool, Failure>> createUsedInventory(Body params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.usedInventoryUrl,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> editUsedInventory(Body params) {
    final id = params['id'];
    try {
      final response = dioClient.makeRequest(
        url: '${ApiConstants.usedInventoryUrl}/$id',
        method: RequestType.PUT,
        data: params,
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
  Future<Either<List<ShopInventoryModel>, Failure>>
      getAllUsedInventories() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.usedInventoryUrl,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => ShopInventoryModel.fromJson(e))
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
  Future<Either<bool, Failure>> deleteUsedInventory(Body params) {
    final id = params['id'];
    try {
      final response = dioClient.makeRequest(
        url: '${ApiConstants.usedInventoryUrl}/$id',
        method: RequestType.DELETE,
        data: params,
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
  Future<Either<bool, Failure>> disableUsedInventory(Body params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.disableUsedInventory,
        method: RequestType.POST,
        data: params,
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
  Future<Either<List<ClientModel>, Failure>> getAllUsedClients() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.usedClientUrl,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => ClientModel.fromJson(e))
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
  Future<Either<bool, Failure>> createOrEditUsedClient(Body params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.usedClientUrl,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> disableUsedClient(Body params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.disableUsedClient,
        method: RequestType.POST,
        data: params,
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
  Future<Either<bool, Failure>> createUsedSupplier(Body params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.usedSupplierUrl,
        method: RequestType.POST,
        data: params,
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
  Future<Either<List<SupplierModel>, Failure>> getAllUsedSuppliers() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.usedSupplierUrl,
        converter: (response) {
          try {
            return (response['data'] as List?)
                    ?.map((e) => SupplierModel.fromJson(e))
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
  Future<Either<bool, Failure>> disableUsedSupplier(Body params) {
    try {
      final response = dioClient.makeRequest(
        url: ApiConstants.disableUsedSupplier,
        method: RequestType.PUT,
        data: params,
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
  Future<Either<bool, Failure>> editUsedSupplier(Body params) {
    final id = params['id'];
    try {
      final response = dioClient.makeRequest(
        url: '${ApiConstants.usedSupplierUrl}/$id',
        method: RequestType.PUT,
        data: params,
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
  Future<Either<bool, Failure>> deleteUsedSupplier(Body params) {
    final id = params['id'];
    try {
      final response = dioClient.makeRequest(
        url: '${ApiConstants.usedSupplierUrl}/$id',
        method: RequestType.DELETE,
        data: params,
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
}
