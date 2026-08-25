import '../../domain/entities/selected_device_entity.dart';

class SelectedDeviceModel extends SelectedDeviceEntity {
  const SelectedDeviceModel({
    super.id,
    super.type,
    super.unitId,
    super.serialNumber,
    super.purchaseDate,
    super.cost,
    super.costType,
    super.ownedBy,
    super.isAssigned,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory SelectedDeviceModel.fromJson(Map<String, dynamic> json) =>
      SelectedDeviceModel(
        id: json["id"],
        type: json["type"],
        unitId: json["unit_id"],
        serialNumber: json["serial_number"],
        purchaseDate: json["purchase_date"] == null
            ? null
            : DateTime.parse(json["purchase_date"]),
        cost: json["cost"],
        costType: json["cost_type"],
        ownedBy: json["owned_by"],
        isAssigned: json["is_assigned"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "unit_id": unitId,
        "serial_number": serialNumber,
        "purchase_date":
            "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}",
        "cost": cost,
        "cost_type": costType,
        "owned_by": ownedBy,
        "is_assigned": isAssigned,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
