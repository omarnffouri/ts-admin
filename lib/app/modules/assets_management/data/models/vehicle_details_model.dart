import 'package:ts_admin/app/modules/assets_management/domain/entities/vehicle_details_entity.dart';

import '../../domain/entities/note_entity.dart';
import 'note_model.dart';

class VehicleDetailsModel extends VehicleDetailsEntity {
  const VehicleDetailsModel({
    super.overview,
    super.information,
    super.documents,
    super.devices,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) =>
      VehicleDetailsModel(
        overview: json["overview"] == null
            ? null
            : OverviewModel.fromJson(json["overview"]),
        information: json["information"] == null
            ? null
            : InformationModel.fromJson(json["information"]),
        documents: json["documents"] == null
            ? null
            : DocumentsModel.fromJson(json["documents"]),
        devices: json["devices"] == null
            ? null
            : DevicesModel.fromJson(json["devices"]),
      );

  Map<String, dynamic> toJson() => {
        "overview": overview?.toEntity(),
        "information": information?.toEntity(),
        "documents": documents?.toEntity(),
        "devices": devices?.toEntity(),
      };
}

class DevicesModel extends Devices {
  const DevicesModel({
    super.installedDevices,
    super.uninstalledDevices,
  });

  factory DevicesModel.fromJson(Map<String, dynamic> json) => DevicesModel(
        installedDevices: json["installedDevices"] == null
            ? []
            : List<DeviceDataModel>.from(json["installedDevices"]!
                .map((x) => DeviceDataModel.fromJson(x))),
        uninstalledDevices: json["uninstalledDevices"] == null
            ? []
            : List<DeviceDataModel>.from(json["uninstalledDevices"]!
                .map((x) => DeviceDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "installedDevices": installedDevices == null
            ? []
            : List<dynamic>.from(installedDevices!.map((x) => x.toEntity())),
        "uninstalledDevices": uninstalledDevices == null
            ? []
            : List<dynamic>.from(installedDevices!.map((x) => x.toEntity())),
      };
}

class DeviceDataModel extends DeviceData {
  const DeviceDataModel({
    super.id,
    super.installedOn,
    super.uninstalledOn,
    super.deviceId,
    super.deviceNote,
    super.installedBy,
    super.uninstalledBy,
    super.type,
    super.unitId,
    super.serialNumber,
    super.purchaseDate,
    super.cost,
    super.costType,
    super.ownedBy,
    super.isAssigned,
  });

  factory DeviceDataModel.fromJson(Map<String, dynamic> json) =>
      DeviceDataModel(
        id: json["id"],
        installedOn: json["installed_on"],
        uninstalledOn: json["uninstalled_on"],
        deviceId: json["device_id"],
        deviceNote: json["device_note"],
        installedBy: json["installed_by"],
        uninstalledBy: json["uninstalled_by"],
        type: json["type"],
        unitId: json["unit_id"],
        serialNumber: json["serial_number"],
        purchaseDate:
            json["purchase_date"] == null || json["purchase_date"] == "N/A"
                ? null
                : DateTime.parse(json["purchase_date"]),
        cost: json["cost"],
        costType: json["cost_type"],
        ownedBy: json["owned_by"],
        isAssigned: json["is_assigned"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "installed_on": installedOn,
        "uninstalled_on": uninstalledOn,
        "device_id": deviceId,
        "device_note": deviceNote,
        "installed_by": installedBy,
        "uninstalled_by": uninstalledBy,
        "type": type,
        "unit_id": unitId,
        "serial_number": serialNumber,
        "purchase_date":
            "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}",
        "cost": cost,
        "cost_type": costType,
        "owned_by": ownedBy,
        "is_assigned": isAssigned,
      };
}

class DocumentsModel extends Documents {
  const DocumentsModel({
    super.requestedDocuments,
    super.globalDocuments,
    super.oldDocuments,
    super.folders,
    super.otherDocuments,
    super.truckPictures,
  });

  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
        requestedDocuments: json["requestedDocuments"] == null
            ? []
            : List<DocumentsRequestedDocumentModel>.from(
                json["requestedDocuments"]!
                    .map((x) => DocumentsRequestedDocumentModel.fromJson(x))),
        globalDocuments: json["globalDocuments"] == null
            ? []
            : List<FolderModel>.from(
                json["globalDocuments"]!.map((x) => FolderModel.fromJson(x))),
        oldDocuments: json["oldDocuments"] == null
            ? []
            : List<OldDocumentModel>.from(
                json["oldDocuments"]!.map((x) => OldDocumentModel.fromJson(x))),
        folders: json["folders"] == null
            ? []
            : List<FolderModel>.from(
                json["folders"]!.map((x) => FolderModel.fromJson(x))),
        otherDocuments: json["otherDocuments"] == null
            ? []
            : List<OldDocumentModel>.from(json["otherDocuments"]!
                .map((x) => OldDocumentModel.fromJson(x))),
        truckPictures: json["truckPictures"] == null
            ? []
            : List<OldDocumentModel>.from(json["truckPictures"]!
                .map((x) => OldDocumentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "requestedDocuments": requestedDocuments == null
            ? []
            : List<dynamic>.from(requestedDocuments!.map((x) => x.toEntity())),
        "globalDocuments": globalDocuments == null
            ? []
            : List<dynamic>.from(globalDocuments!.map((x) => x.toEntity())),
        "oldDocuments": oldDocuments == null
            ? []
            : List<dynamic>.from(oldDocuments!.map((x) => x.toEntity())),
        "folders": folders == null
            ? []
            : List<dynamic>.from(folders!.map((x) => x.toEntity())),
        "otherDocuments": otherDocuments == null
            ? []
            : List<dynamic>.from(otherDocuments!.map((x) => x.toEntity())),
        "truckPictures": truckPictures == null
            ? []
            : List<dynamic>.from(otherDocuments!.map((x) => x.toEntity())),
      };
}

class FolderModel extends Folder {
  const FolderModel({
    super.id,
    super.name,
    super.collectionType,
    super.createdAt,
    super.updatedAt,
    super.file,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
        id: json["id"],
        name: json["name"],
        collectionType: json["collection_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        file: json["file"] == null
            ? null
            : OldDocumentModel.fromJson(json["file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "collection_type": collectionType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "file": file?.toEntity(),
      };
}

class OldDocumentModel extends FileEntity {
  OldDocumentModel({
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

  factory OldDocumentModel.fromJson(Map<String, dynamic> json) =>
      OldDocumentModel(
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
        createdAt: json["createdAt"] == null || json["createdAt"] == "N/A"
            ? null
            : DateTime.parse(json["createdAt"]),
        approvedBy: json["approvedBy"],
        updatedAt: json["updatedAt"] == null || json["updatedAt"] == "N/A"
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

class DocumentsRequestedDocumentModel extends DocumentDto {
  const DocumentsRequestedDocumentModel({
    super.id,
    super.modelId,
    super.message,
    super.collectionName,
    super.collectionType,
    super.createdAt,
    super.updatedAt,
    super.expirationDate,
    super.isUploaded,
    super.hasExpiration,
    super.file,
  });

  factory DocumentsRequestedDocumentModel.fromJson(Map<String, dynamic> json) =>
      DocumentsRequestedDocumentModel(
        id: json["id"],
        modelId: json["model_id"],
        message: json["message"],
        collectionName: json["collection_name"],
        collectionType: json["collection_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        expirationDate: json["expiration_date"],
        isUploaded: json["is_uploaded"],
        hasExpiration: json["has_expiration"],
        file: json["file"] == null
            ? null
            : OldDocumentModel.fromJson(json["file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "model_id": modelId,
        "message": message,
        "collection_name": collectionName,
        "collection_type": collectionType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "expiration_date": expirationDate,
        "is_uploaded": isUploaded,
        "has_expiration": hasExpiration,
        "file": file?.toEntity(),
      };
}

class InformationModel extends Information {
  const InformationModel({
    super.general,
    super.plate,
    super.ownership,
    super.lease,
    super.maintenance,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) =>
      InformationModel(
        general: json["general"] == null
            ? null
            : GeneralModel.fromJson(json["general"]),
        plate:
            json["plate"] == null ? null : PlateModel.fromJson(json["plate"]),
        ownership: json["ownership"] == null
            ? null
            : OwnershipModel.fromJson(json["ownership"]),
        lease:
            json["lease"] == null ? null : LeaseModel.fromJson(json["lease"]),
        maintenance: json["maintenance"] == null
            ? null
            : MaintenanceModel.fromJson(json["maintenance"]),
      );

  Map<String, dynamic> toJson() => {
        "general": general?.toEntity(),
        "plate": plate?.toEntity(),
        "ownership": ownership?.toEntity(),
        "lease": lease?.toEntity(),
        "maintenance": maintenance?.toEntity(),
      };
}

class GeneralModel extends General {
  const GeneralModel({
    super.id,
    super.identifier,
    super.maker,
    super.model,
    super.makingYear,
    super.engineMaker,
    super.engineModel,
    super.engineYear,
    super.type,
    super.vin,
    super.titleNumber,
    super.licencePlateNumber,
    super.status,
    super.lessor,
    super.color,
    super.glider,
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
        id: json["id"],
        identifier: json["identifier"],
        maker: json["maker"],
        model: json["model"],
        makingYear: json["making_year"],
        engineMaker: json["engine_maker"],
        engineModel: json["engine_model"],
        engineYear: json["engine_year"],
        type: json["type"],
        vin: json["vin"],
        titleNumber: json["title_number"],
        licencePlateNumber: json["licence_plate_number"],
        status: json["status"],
        lessor: json["lessor"],
        color: json["color"],
        glider: json["glider"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "maker": maker,
        "model": model,
        "making_year": makingYear,
        "engine_maker": engineMaker,
        "engine_model": engineModel,
        "engine_year": engineYear,
        "type": type,
        "vin": vin,
        "title_number": titleNumber,
        "status": status,
        "lessor": lessor,
        "color": color,
        "glider": glider,
      };
}

class LeaseModel extends Lease {
  const LeaseModel({
    super.leasingCompany,
    super.leaseReference,
    super.leaseEndDate,
    super.leaseEarlyWalkDate,
    super.leaseMonthlyPayment,
    super.leaseMaintenanceCpm,
    super.leaseMileageYearlyAllowance,
  });

  factory LeaseModel.fromJson(Map<String, dynamic> json) => LeaseModel(
        leasingCompany: json["leasing_company"],
        leaseReference: json["lease_reference"],
        leaseEndDate:
            json["lease_end_date"] == null || json["lease_end_date"] == "N/A"
                ? null
                : DateTime.parse(json["lease_end_date"]),
        leaseEarlyWalkDate: json["lease_early_walk_date"] == null ||
                json["lease_early_walk_date"] == "N/A"
            ? null
            : DateTime.parse(json["lease_early_walk_date"]),
        leaseMonthlyPayment: json["lease_monthly_payment"],
        leaseMaintenanceCpm: json["lease_maintenance_cpm"],
        leaseMileageYearlyAllowance: json["lease_mileage_yearly_allowance"],
      );

  Map<String, dynamic> toJson() => {
        "leasing_company": leasingCompany,
        "lease_reference": leaseReference,
        "lease_end_date":
            "${leaseEndDate!.year.toString().padLeft(4, '0')}-${leaseEndDate!.month.toString().padLeft(2, '0')}-${leaseEndDate!.day.toString().padLeft(2, '0')}",
        "lease_early_walk_date":
            "${leaseEarlyWalkDate!.year.toString().padLeft(4, '0')}-${leaseEarlyWalkDate!.month.toString().padLeft(2, '0')}-${leaseEarlyWalkDate!.day.toString().padLeft(2, '0')}",
        "lease_monthly_payment": leaseMonthlyPayment,
        "lease_maintenance_cpm": leaseMaintenanceCpm,
        "lease_mileage_yearly_allowance": leaseMileageYearlyAllowance,
      };
}

class MaintenanceModel extends Maintenance {
  const MaintenanceModel({
    super.nextInspectionOn,
    super.inServiceOn,
    super.nextServiceOn,
    super.emptyWeight,
    super.grossWeight,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) =>
      MaintenanceModel(
        nextInspectionOn: json["next_inspection_on"] == null ||
                json["next_inspection_on"] == "N/A"
            ? null
            : DateTime.parse(json["next_inspection_on"]),
        inServiceOn:
            json["in_service_on"] == null || json["in_service_on"] == "N/A"
                ? null
                : DateTime.parse(json["in_service_on"]),
        nextServiceOn:
            json["next_service_on"] == null || json["next_service_on"] == "N/A"
                ? null
                : DateTime.parse(json["next_service_on"]),
        emptyWeight: json["empty_weight"],
        grossWeight: json["gross_weight"],
      );

  Map<String, dynamic> toJson() => {
        "next_inspection_on":
            "${nextInspectionOn!.year.toString().padLeft(4, '0')}-${nextInspectionOn!.month.toString().padLeft(2, '0')}-${nextInspectionOn!.day.toString().padLeft(2, '0')}",
        "in_service_on":
            "${inServiceOn!.year.toString().padLeft(4, '0')}-${inServiceOn!.month.toString().padLeft(2, '0')}-${inServiceOn!.day.toString().padLeft(2, '0')}",
        "next_service_on":
            "${nextServiceOn!.year.toString().padLeft(4, '0')}-${nextServiceOn!.month.toString().padLeft(2, '0')}-${nextServiceOn!.day.toString().padLeft(2, '0')}",
        "empty_weight": emptyWeight,
        "gross_weight": grossWeight,
      };
}

class OwnershipModel extends Ownership {
  const OwnershipModel({
    super.ownedBy,
    super.lessor,
    super.financedBy,
    super.purchaseDate,
    super.purchasePrice,
    super.saleDate,
    super.salePrice,
    super.ownerName,
    super.ownerPhone,
  });

  factory OwnershipModel.fromJson(Map<String, dynamic> json) => OwnershipModel(
        ownedBy: json["owned_by"],
        lessor: json["lessor"],
        financedBy: json["financed_by"],
        purchaseDate: json["purchase_date"],
        purchasePrice: json["purchase_price"].toString(),
        saleDate: json["sale_date"],
        salePrice: json["sale_price"].toString(),
        ownerName: json["owner_name"],
        ownerPhone: json["owner_phone"],
      );

  Map<String, dynamic> toJson() => {
        "owned_by": ownedBy,
        "lessor": lessor,
        "financed_by": financedBy,
        "purchase_date": purchaseDate,
        "purchase_price": purchasePrice,
        "sale_date": saleDate,
        "sale_price": salePrice,
        "owner_name": ownerName,
        "owner_phone": ownerPhone,
      };
}

class PlateModel extends Plate {
  const PlateModel({
    super.licencePlateNumber,
    super.licencePlateState,
    super.tagsExpiresOn,
    super.platesOwnedBy,
  });

  factory PlateModel.fromJson(Map<String, dynamic> json) => PlateModel(
        licencePlateNumber: json["licence_plate_number"],
        licencePlateState: json["licence_plate_state"],
        tagsExpiresOn:
            json["tags_expires_on"] == null || json["tags_expires_on"] == "N/A"
                ? null
                : DateTime.parse(json["tags_expires_on"]),
        platesOwnedBy: json["plates_owned_by"],
      );

  Map<String, dynamic> toJson() => {
        "licence_plate_number": licencePlateNumber,
        "licence_plate_state": licencePlateState,
        "tags_expires_on":
            "${tagsExpiresOn!.year.toString().padLeft(4, '0')}-${tagsExpiresOn!.month.toString().padLeft(2, '0')}-${tagsExpiresOn!.day.toString().padLeft(2, '0')}",
        "plates_owned_by": platesOwnedBy,
      };
}

class OverviewModel extends Overview {
  const OverviewModel({
    super.truck,
    super.requestedDocuments,
    super.checklists,
    super.notes,
    super.statuses,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) => OverviewModel(
        truck:
            json["truck"] == null ? null : GeneralModel.fromJson(json["truck"]),
        requestedDocuments: json["requestedDocuments"] == null
            ? []
            : List<OverviewRequestedDocumentModel>.from(
                json["requestedDocuments"]!
                    .map((x) => OverviewRequestedDocumentModel.fromJson(x))),
        checklists: json["checklists"] == null
            ? []
            : List<ChecklistModel>.from(
                json["checklists"]!.map((x) => ChecklistModel.fromJson(x))),
        notes: json["notes"] == null
            ? []
            : List<NoteDataEntity>.from(
                json["notes"]!.map((x) => NoteDataModel.fromJson(x))),
        statuses: json["statuses"] == null
            ? []
            : List<StatusModel>.from(
                json["statuses"]!.map((x) => StatusModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "truck": truck?.toEntity(),
        "requestedDocuments": requestedDocuments == null
            ? []
            : List<dynamic>.from(requestedDocuments!.map((x) => x.toEntity())),
        "checklists": checklists == null
            ? []
            : List<dynamic>.from(checklists!.map((x) => x.toEntity())),
        "notes": notes == null
            ? []
            : List<dynamic>.from(notes!.map((x) => x.toEntity())),
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toEntity())),
      };
}

class ChecklistModel extends Checklist {
  const ChecklistModel({
    super.id,
    super.name,
    super.addedDate,
    super.removedDate,
    super.title,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) => ChecklistModel(
        id: json["id"],
        name: json["name"],
        addedDate: json["added_date"],
        removedDate: json["removed_date"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "added_date": addedDate,
        "removed_date": removedDate,
        "title": title,
      };
}

class UserModel extends User {
  const UserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.email,
    super.emailVerifiedAt,
    super.phone,
    super.image,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.teamId,
    super.departmentId,
    super.designationId,
    super.name,
    super.modelType,
    super.isSuperAdmin,
    super.userDesignation,
    super.currentStatus,
    super.roles,
    super.designation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null ||
                json["email_verified_at"] == "N/A"
            ? null
            : DateTime.parse(json["email_verified_at"]),
        phone: json["phone"],
        image: json["image"],
        createdAt: json["created_at"] == null || json["created_at"] == "N/A"
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null || json["updated_at"] == "N/A"
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        teamId: json["team_id"],
        departmentId: json["department_id"],
        designationId: json["designation_id"],
        name: json["name"],
        modelType: json["model_type"],
        isSuperAdmin: json["is_super_admin"],
        userDesignation: json["user_designation"],
        currentStatus: json["current_status"],
        roles: json["roles"] == null
            ? []
            : List<RoleModel>.from(
                json["roles"]!.map((x) => RoleModel.fromJson(x))),
        designation: json["designation"] == null
            ? null
            : DesignationModel.fromJson(json["designation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phone": phone,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "team_id": teamId,
        "department_id": departmentId,
        "designation_id": designationId,
        "name": name,
        "model_type": modelType,
        "is_super_admin": isSuperAdmin,
        "user_designation": userDesignation,
        "current_status": currentStatus,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toEntity())),
        "designation": designation?.toEntity(),
      };
}

class DesignationModel extends Designation {
  const DesignationModel({
    super.id,
    super.title,
    super.name,
    super.deletedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) =>
      DesignationModel(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null || json["updated_at"] == "N/A"
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class RoleModel extends Role {
  const RoleModel({
    super.id,
    super.name,
    super.guardName,
    super.createdAt,
    super.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        createdAt: json["created_at"] == null || json["created_at"] == "N/A"
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null || json["updated_at"] == "N/A"
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class OverviewRequestedDocumentModel extends OverviewRequestedDocument {
  const OverviewRequestedDocumentModel({
    super.id,
    super.folderId,
    super.fileType,
    super.fileName,
    super.hasExpiration,
    super.optional,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.isUploaded,
    super.size,
    super.icon,
    super.hollow,
    super.color,
  });

  factory OverviewRequestedDocumentModel.fromJson(Map<String, dynamic> json) =>
      OverviewRequestedDocumentModel(
        id: json["id"],
        folderId: json["folder_id"],
        fileType: json["file_type"],
        fileName: json["file_name"],
        hasExpiration: json["has_expiration"],
        optional: json["optional"],
        createdAt: json["created_at"] == null || json["created_at"] == "N/A"
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null || json["updated_at"] == "N/A"
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null || json["deleted_at"] == "N/A"
            ? null
            : DateTime.parse(json["deleted_at"]),
        isUploaded: json["is_uploaded"],
        size: json["size"],
        icon: json["icon"],
        hollow: json["hollow"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "folder_id": folderId,
        "file_type": fileType,
        "file_name": fileName,
        "has_expiration": hasExpiration,
        "optional": optional,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
        "is_uploaded": isUploaded,
        "size": size,
        "icon": icon,
        "hollow": hollow,
        "color": color,
      };
}

class StatusModel extends Status {
  const StatusModel({
    super.id,
    super.name,
    super.reason,
    super.modelId,
    super.createdAt,
    super.updatedAt,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        id: json["id"],
        name: json["name"],
        reason: json["reason"] == null || json["reason"] == "N/A"
            ? null
            : json["reason"],
        modelId: json["model_id"],
        createdAt: json["created_at"] == null || json["created_at"] == "N/A"
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null || json["updated_at"] == "N/A"
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
