import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';

import 'client_entity.dart';

class ServiceOrderEntity extends Equatable {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final DateTime? maintenanceDate;
  final DateTime? completionDate;
  final int? modelId;
  final String? modelType;
  final String? status;
  final List<ServiceDetailEntity>? serviceDetails;
  final CustomerEntity? customer;
  final List<StatusEntity>? statuses;
  final List<TechnicianEntity>? technicians;
  final String? serviceOrderNumber;
  final String? customerComplaint;
  final String? category;

  const ServiceOrderEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.modelId,
    this.modelType,
    this.category,
    this.maintenanceDate,
    this.completionDate,
    this.status,
    this.serviceDetails,
    this.customer,
    this.statuses,
    this.technicians,
    this.serviceOrderNumber,
    this.customerComplaint,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        maintenanceDate,
        completionDate,
        modelId,
        modelType,
        category,
        status,
        customer,
        statuses,
        technicians,
        serviceOrderNumber,
        customerComplaint,
      ];
}

class ServiceDetailEntity extends Equatable {
  final int? id;
  final String? maintenanceType;
  final String? serviceType;
  final String? serviceTypeTitle;
  final String? maintenanceTypeTitle;
  final String? serviceChargesType;
  final String? rate;
  final int? hours;
  final String? partsRequired;
  final String? tax;
  final String? mileage;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<VehiclePartEntity>? vehicleParts;
  final List<FileElementEntity>? files;
  final List<FileElementEntity>? filesAfterService;

  const ServiceDetailEntity({
    this.id,
    this.maintenanceType,
    this.serviceType,
    this.serviceTypeTitle,
    this.maintenanceTypeTitle,
    this.serviceChargesType,
    this.rate,
    this.hours,
    this.partsRequired,
    this.tax,
    this.mileage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vehicleParts,
    this.files,
    this.filesAfterService,
  });

  @override
  List<Object?> get props => [
        id,
        maintenanceType,
        serviceType,
        serviceTypeTitle,
        maintenanceTypeTitle,
        serviceChargesType,
        rate,
        hours,
        partsRequired,
        tax,
        mileage,
        status,
        createdAt,
        updatedAt,
        vehicleParts,
        files,
        filesAfterService,
      ];
}

class CustomerEntity extends Equatable {
  final int? id;
  final String? identifier;
  final String? make;
  final String? year;
  final String? vin;
  final String? licensePlate;
  final ClientEntity? client;

  const CustomerEntity({
    this.id,
    this.identifier,
    this.make,
    this.year,
    this.vin,
    this.licensePlate,
    this.client,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "identifier": identifier,
        "make": make,
        "year": year,
        "vin": vin,
        "license_plate": licensePlate,
        "client": client?.toEntity(),
      };

  @override
  List<Object?> get props => [
        id,
        identifier,
        make,
        year,
        vin,
        licensePlate,
        client,
      ];
}

class FileElementEntity extends Equatable {
  final int? id;
  final String? fileType;
  final String? name;
  final String? fileName;
  final String? fileNameExt;
  final String? url;
  final String? mimeType;
  final String? size;
  final String? fileIcon;
  final String? uploadedBy;
  final DateTime? createdAt;
  final String? approvedBy;
  final DateTime? updatedAt;
  final String? deletedBy;
  final String? deletedAt;

  const FileElementEntity({
    this.id,
    this.fileType,
    this.name,
    this.fileName,
    this.fileNameExt,
    this.url,
    this.mimeType,
    this.size,
    this.fileIcon,
    this.uploadedBy,
    this.createdAt,
    this.approvedBy,
    this.updatedAt,
    this.deletedBy,
    this.deletedAt,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "file_type": fileType,
        "name": name,
        "file_name": fileName,
        "file_name_ext": fileNameExt,
        "url": url,
        "mime_type": mimeType,
        "size": size,
        "file_icon": fileIcon,
        "uploadedBy": uploadedBy,
        "createdAt": createdAt?.toIso8601String(),
        "approvedBy": approvedBy,
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedBy": deletedBy,
        "deletedAt": deletedAt,
      };

  @override
  List<Object?> get props => [
        id,
        fileType,
        name,
        fileName,
        fileNameExt,
        url,
        mimeType,
        size,
        fileIcon,
        uploadedBy,
        createdAt,
        approvedBy,
        updatedAt,
        deletedBy,
        deletedAt
      ];
}

class StatusEntity extends Equatable {
  final int? id;
  final String? name;
  final String? reason;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StatusEntity({
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

class VehiclePartEntity extends Equatable {
  final int? id;
  final int? vehicleMaintenanceRecordId;
  final int? numberOfPartsAvailable;
  final int? numberOfPartsRequired;
  final String? partPrice;
  final String? totalPrice;
  final int? partsToBePurchased;
  final int? shopInventoryId;
  final String? itemName;

  const VehiclePartEntity({
    this.id,
    this.vehicleMaintenanceRecordId,
    this.numberOfPartsAvailable,
    this.numberOfPartsRequired,
    this.partPrice,
    this.totalPrice,
    this.partsToBePurchased,
    this.shopInventoryId,
    this.itemName,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "vehicle_maintenance_record_id": vehicleMaintenanceRecordId,
        "number_of_parts_available": numberOfPartsAvailable,
        "number_of_parts_required": numberOfPartsRequired,
        "part_price": partPrice,
        "total_price": totalPrice,
        "parts_to_be_purchased": partsToBePurchased,
        "shop_inventory_id": shopInventoryId,
        "item_name": itemName,
      };

  @override
  List<Object?> get props => [
        id,
        vehicleMaintenanceRecordId,
        numberOfPartsAvailable,
        numberOfPartsRequired,
        partPrice,
        totalPrice,
        partsToBePurchased,
        shopInventoryId,
        itemName
      ];
}
