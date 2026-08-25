import 'package:equatable/equatable.dart';

import 'client_entity.dart';

class PurchaseOrderEntity extends Equatable {
  final int? id;
  final String? orderNumber;
  final DateTime? purchaseDate;
  final int? usedPartShopClientId;
  final String? description;
  final String? createdBy;
  final int? updatedBy;
  final ClientEntity? client;
  final String? status;
  final List<Status>? statuses;
  final List<VehiclePart> vehicleParts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic file;

  const PurchaseOrderEntity({
    this.id,
    this.orderNumber,
    this.purchaseDate,
    this.usedPartShopClientId,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.client,
    this.status,
    this.statuses,
    required this.vehicleParts,
    this.createdAt,
    this.updatedAt,
    this.file,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        purchaseDate,
        usedPartShopClientId,
        description,
        createdBy,
        updatedBy,
        client,
        status,
        statuses,
        vehicleParts,
        createdAt,
        updatedAt,
        file,
      ];
}

class Status extends Equatable {
  final int? id;
  final String? name;
  final String? reason;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Status({
    this.id,
    this.name,
    this.reason,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        reason,
        modelType,
        modelId,
        createdAt,
        updatedAt,
      ];
}

class VehiclePart extends Equatable {
  final int? id;
  final int? usedShopInventoryId;
  final String? itemName;
  final String? itemNumber;
  final String? createdBy;
  final int? numberOfPartsAvailable;
  final int? numberOfPartsRequired;
  final String? partPrice;
  final int? partsToBePurchased;
  final String? totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VehiclePart({
    this.id,
    this.usedShopInventoryId,
    this.itemName,
    this.itemNumber,
    this.createdBy,
    this.numberOfPartsAvailable,
    this.numberOfPartsRequired,
    this.partPrice,
    this.partsToBePurchased,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        id,
        usedShopInventoryId,
        itemName,
        itemNumber,
        createdBy,
        numberOfPartsAvailable,
        numberOfPartsRequired,
        partPrice,
        partsToBePurchased,
        totalPrice,
        createdAt,
        updatedAt,
      ];
}
