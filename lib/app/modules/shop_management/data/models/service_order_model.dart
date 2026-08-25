import 'package:ts_admin/app/modules/shop_management/data/models/technician_model.dart';

import '../../domain/entities/service_order_entity.dart';
import 'client_model.dart';

class ServiceOrdermodel extends ServiceOrderEntity {
  const ServiceOrdermodel({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.maintenanceDate,
    super.completionDate,
    super.modelId,
    super.modelType,
    super.category,
    super.status,
    super.serviceDetails,
    super.customer,
    super.statuses,
    super.technicians,
    super.serviceOrderNumber,
    super.customerComplaint,
  });

  factory ServiceOrdermodel.fromJson(Map<String, dynamic> json) =>
      ServiceOrdermodel(
        id: json["id"],
        serviceOrderNumber: json["service_order_number"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        maintenanceDate: json["maintenance_date"] == null
            ? null
            : DateTime.parse(json["maintenance_date"]),
        completionDate: json["completion_date"] == null
            ? null
            : DateTime.parse(json["completion_date"]),
        modelId: json["model_id"],
        modelType: json["model_type"],
        category: json["category"],
        customerComplaint: json["customer_complaint"],
        status: json["status"],
        serviceDetails: json["serviceDetails"] == null
            ? []
            : List<ServiceDetailModel>.from(json["serviceDetails"]!
                .map((x) => ServiceDetailModel.fromJson(x))),
        customer: json["customer"] == null || json["customer"].isEmpty
            ? null
            : CustomerModel.fromJson(json["customer"]),
        statuses: json["statuses"] == null
            ? []
            : List<StatusModel>.from(
                json["statuses"]!.map((x) => StatusModel.fromJson(x))),
        technicians: json["technicians"] == null
            ? []
            : List<TechnicianModel>.from(
                json["technicians"]!.map((x) => TechnicianModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_order_number": serviceOrderNumber,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "maintenance_date":
            "${maintenanceDate!.year.toString().padLeft(4, '0')}-${maintenanceDate!.month.toString().padLeft(2, '0')}-${maintenanceDate!.day.toString().padLeft(2, '0')}",
        "completion_date":
            "${completionDate!.year.toString().padLeft(4, '0')}-${completionDate!.month.toString().padLeft(2, '0')}-${completionDate!.day.toString().padLeft(2, '0')}",
        "model_id": modelId,
        "model_type": modelType,
        "category": category,
        "customer_complaint": customerComplaint,
        "status": status,
        "customer": customer?.toEntity(),
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toEntity())),
        "technicians": technicians == null
            ? []
            : List<dynamic>.from(technicians!.map((x) => x.toJson())),
      };
}

class ServiceDetailModel extends ServiceDetailEntity {
  const ServiceDetailModel({
    super.id,
    super.maintenanceType,
    super.serviceType,
    super.serviceTypeTitle,
    super.maintenanceTypeTitle,
    super.serviceChargesType,
    super.rate,
    super.hours,
    super.partsRequired,
    super.tax,
    super.mileage,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.vehicleParts,
    super.files,
    super.filesAfterService,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) =>
      ServiceDetailModel(
        id: json["id"],
        maintenanceType: json["maintenance_type"],
        serviceType: json["service_type"],
        serviceTypeTitle: json["service_type_title"],
        maintenanceTypeTitle: json["maintenance_type_title"],
        serviceChargesType: json["service_charges_type"],
        rate: json["rate"],
        hours: json["hours"],
        partsRequired: json["parts_required"] == 0 ? "no" : "yes",
        tax: json["tax"],
        mileage: json["mileage"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        vehicleParts: json["vehicle_parts"] == null
            ? []
            : List<VehiclePartModel>.from(json["vehicle_parts"]!
                .map((x) => VehiclePartModel.fromJson(x))),
        files: json["files"] == null
            ? []
            : List<FileElementModel>.from(
                json["files"]!.map((x) => FileElementModel.fromJson(x))),
        filesAfterService: json["filesAfterService"] == null
            ? []
            : List<FileElementModel>.from(json["filesAfterService"]!
                .map((x) => FileElementModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "maintenance_type": maintenanceType,
        "service_type": serviceType,
        "service_type_title": serviceTypeTitle,
        "maintenance_type_title": maintenanceTypeTitle,
        "service_charges_type": serviceChargesType,
        "rate": rate,
        "hours": hours,
        "parts_required": partsRequired,
        "tax": tax,
        "mileage": mileage,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "vehicle_parts": vehicleParts == null
            ? []
            : List<dynamic>.from(vehicleParts!.map((x) => x.toEntity())),
        "files": files == null
            ? []
            : List<dynamic>.from(files!.map((x) => x.toEntity())),
        "filesAfterService": filesAfterService == null
            ? []
            : List<dynamic>.from(filesAfterService!.map((x) => x.toEntity())),
      };
}

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    super.id,
    super.identifier,
    super.make,
    super.year,
    super.vin,
    super.licensePlate,
    super.client,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"],
        identifier: json["identifier"].toString(),
        make: json["make"],
        year: json["year"],
        vin: json["vin"],
        licensePlate: json["license_plate"],
        client: json["client"] == null
            ? null
            : ClientModel.fromJson(json["client"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "make": make,
        "year": year,
        "vin": vin,
        "license_plate": licensePlate,
        "client": client?.toEntity(),
      };
}

class FileElementModel extends FileElementEntity {
  const FileElementModel({
    super.id,
    super.fileType,
    super.name,
    super.fileName,
    super.fileNameExt,
    super.url,
    super.mimeType,
    super.size,
    super.fileIcon,
    super.uploadedBy,
    super.createdAt,
    super.approvedBy,
    super.updatedAt,
    super.deletedBy,
    super.deletedAt,
  });

  factory FileElementModel.fromJson(Map<String, dynamic> json) =>
      FileElementModel(
        id: json["id"],
        fileType: json["file_type"],
        name: json["name"],
        fileName: json["file_name"],
        fileNameExt: json["file_name_ext"],
        url: json["url"],
        mimeType: json["mime_type"],
        size: json["size"],
        fileIcon: json["file_icon"],
        uploadedBy: json["uploadedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        approvedBy: json["approvedBy"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedBy: json["deletedBy"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
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
}

class StatusModel extends StatusEntity {
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

class VehiclePartModel extends VehiclePartEntity {
  const VehiclePartModel({
    super.id,
    super.vehicleMaintenanceRecordId,
    super.numberOfPartsAvailable,
    super.numberOfPartsRequired,
    super.partPrice,
    super.totalPrice,
    super.partsToBePurchased,
    super.shopInventoryId,
    super.itemName,
  });

  factory VehiclePartModel.fromJson(Map<String, dynamic> json) =>
      VehiclePartModel(
        id: json["id"],
        vehicleMaintenanceRecordId: json["vehicle_maintenance_record_id"],
        numberOfPartsAvailable: json["number_of_parts_available"],
        numberOfPartsRequired: json["number_of_parts_required"],
        partPrice: json["part_price"],
        totalPrice: json["total_price"],
        partsToBePurchased: json["parts_to_be_purchased"],
        shopInventoryId: json["shop_inventory_id"],
        itemName: json["item_name"],
      );

  Map<String, dynamic> toJson() => {
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
}
