// To parse this JSON data, do
//
//     final purchaseOrderModel = purchaseOrderModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/purchase_order_entity.dart';
import 'client_model.dart';

PurchaseOrderModel purchaseOrderModelFromJson(String str) =>
    PurchaseOrderModel.fromJson(json.decode(str));

String purchaseOrderModelToJson(PurchaseOrderModel data) =>
    json.encode(data.toJson());

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    super.id,
    super.orderNumber,
    super.purchaseDate,
    super.usedPartShopClientId,
    super.description,
    super.createdBy,
    super.updatedBy,
    super.client,
    super.status,
    super.statuses,
    super.vehicleParts = const [],
    super.createdAt,
    super.updatedAt,
    super.file,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderModel(
        id: json["id"],
        orderNumber: json["order_number"],
        purchaseDate: json["purchase_date"] == null
            ? null
            : DateTime.parse(json["purchase_date"]),
        usedPartShopClientId: json["used_part_shop_client_id"],
        description: json["description"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        client: json["client"] == null
            ? null
            : ClientModel.fromJson(json["client"]),
        status: json["status"],
        statuses: json["statuses"] == null
            ? []
            : List<StatusModel>.from(
                json["statuses"]!.map((x) => StatusModel.fromJson(x))),
        vehicleParts: json["vehicle_parts"] == null
            ? []
            : List<VehiclePartModel>.from(json["vehicle_parts"]!
                .map((x) => VehiclePartModel.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "purchase_date": purchaseDate?.toIso8601String(),
        "used_part_shop_client_id": usedPartShopClientId,
        "description": description,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "client": client?.toEntity(),
        "status": status,
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toEntity())),
        "vehicle_parts":
            List<dynamic>.from(vehicleParts.map((x) => x.toEntity())),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "file": file,
      };
}

class StatusModel extends Status {
  const StatusModel({
    super.id,
    super.name,
    super.reason,
    super.modelType,
    super.modelId,
    super.createdAt,
    super.updatedAt,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        id: json["id"],
        name: json["name"],
        reason: json["reason"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class VehiclePartModel extends VehiclePart {
  const VehiclePartModel({
    super.id,
    super.usedShopInventoryId,
    super.itemName,
    super.itemNumber,
    super.createdBy,
    super.numberOfPartsAvailable,
    super.numberOfPartsRequired,
    super.partPrice,
    super.partsToBePurchased,
    super.totalPrice,
    super.createdAt,
    super.updatedAt,
  });

  factory VehiclePartModel.fromJson(Map<String, dynamic> json) =>
      VehiclePartModel(
        id: json["id"],
        usedShopInventoryId: json["used_shop_inventory_id"],
        itemName: json["item_name"],
        itemNumber: json["item_number"],
        createdBy: json["created_by"],
        numberOfPartsAvailable: json["number_of_parts_available"],
        numberOfPartsRequired: json["number_of_parts_required"],
        partPrice: json["part_price"],
        partsToBePurchased: json["parts_to_be_purchased"],
        totalPrice: json["total_price"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "used_shop_inventory_id": usedShopInventoryId,
        "item_name": itemName,
        "item_number": itemNumber,
        "created_by": createdBy,
        "number_of_parts_available": numberOfPartsAvailable,
        "number_of_parts_required": numberOfPartsRequired,
        "part_price": partPrice,
        "parts_to_be_purchased": partsToBePurchased,
        "total_price": totalPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
