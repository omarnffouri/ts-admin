import 'package:equatable/equatable.dart';

class SelectedDeviceEntity extends Equatable {
  final int? id;
  final String? type;
  final String? unitId;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final int? cost;
  final String? costType;
  final String? ownedBy;
  final int? isAssigned;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  const SelectedDeviceEntity({
    this.id,
    this.type,
    this.unitId,
    this.serialNumber,
    this.purchaseDate,
    this.cost,
    this.costType,
    this.ownedBy,
    this.isAssigned,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        id,
        type,
        unitId,
        serialNumber,
        purchaseDate,
        cost,
        costType,
        ownedBy,
        isAssigned,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
