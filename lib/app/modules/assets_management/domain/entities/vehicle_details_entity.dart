import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import 'note_entity.dart';

class VehicleDetailsEntity extends Equatable {
  final Overview? overview;
  final Information? information;
  final Documents? documents;
  final Devices? devices;

  const VehicleDetailsEntity({
    this.overview,
    this.information,
    this.documents,
    this.devices,
  });

  Map<String, dynamic> toEntity() => {
        "overview": overview?.toEntity(),
        "information": information?.toEntity(),
        "documents": documents?.toEntity(),
        "devices": devices?.toEntity(),
      };

  @override
  List<Object?> get props => [
        overview,
        information,
        documents,
        devices,
      ];
}

class Devices extends Equatable {
  final List<DeviceData>? installedDevices;
  final List<DeviceData>? uninstalledDevices;

  const Devices({
    this.installedDevices,
    this.uninstalledDevices,
  });

  Map<String, dynamic> toEntity() => {
        "installedDevices": installedDevices == null
            ? []
            : List<dynamic>.from(installedDevices!.map((x) => x.toEntity())),
        "uninstalledDevices": uninstalledDevices == null
            ? []
            : List<dynamic>.from(uninstalledDevices!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [
        installedDevices,
        uninstalledDevices,
      ];
}

class DeviceData extends Equatable {
  final int? id;
  final String? installedOn;
  final dynamic uninstalledOn;
  final int? deviceId;
  final String? deviceNote;
  final String? installedBy;
  final dynamic uninstalledBy;
  final String? type;
  final String? unitId;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final int? cost;
  final String? costType;
  final String? ownedBy;
  final bool? isAssigned;

  const DeviceData({
    this.id,
    this.installedOn,
    this.uninstalledOn,
    this.deviceId,
    this.deviceNote,
    this.installedBy,
    this.uninstalledBy,
    this.type,
    this.unitId,
    this.serialNumber,
    this.purchaseDate,
    this.cost,
    this.costType,
    this.ownedBy,
    this.isAssigned,
  });

  Map<String, dynamic> toEntity() => {
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
            "${purchaseDate?.year.toString().padLeft(4, '0')}-${purchaseDate?.month.toString().padLeft(2, '0')}-${purchaseDate?.day.toString().padLeft(2, '0')}",
        "cost": cost,
        "cost_type": costType,
        "owned_by": ownedBy,
        "is_assigned": isAssigned,
      };

  @override
  List<Object?> get props => [
        id,
        installedOn,
        uninstalledOn,
        deviceId,
        deviceNote,
        installedBy,
        uninstalledBy,
        type,
        unitId,
        serialNumber,
        purchaseDate,
        cost,
        costType,
        ownedBy,
        isAssigned,
      ];
}

class Documents extends Equatable {
  final List<DocumentDto>? requestedDocuments;
  final List<Folder>? globalDocuments;
  final List<FileEntity>? oldDocuments;
  final List<Folder>? folders;
  final List<FileEntity>? otherDocuments;
  final List<FileEntity>? truckPictures;

  const Documents({
    this.requestedDocuments,
    this.globalDocuments,
    this.oldDocuments,
    this.folders,
    this.otherDocuments,
    this.truckPictures,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        requestedDocuments,
        globalDocuments,
        oldDocuments,
        folders,
        otherDocuments,
        truckPictures,
      ];
}

class Folder extends Equatable {
  final int? id;
  final String? name;
  final String? collectionType;
  final String? createdAt;
  final String? updatedAt;
  final FileEntity? file;

  const Folder({
    this.id,
    this.name,
    this.collectionType,
    this.createdAt,
    this.updatedAt,
    this.file,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "collection_type": collectionType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "file": file?.toEntity(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        collectionType,
        createdAt,
        updatedAt,
        file,
      ];
}

class FileEntity extends Equatable {
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
  final dynamic approvedBy;
  final DateTime? updatedAt;
  final String? deletedBy;
  final String? deletedAt;

  final isDownloading = false.obs;
  final downloadProgress = (0.0).obs;
  final filePath = "".obs;

  FileEntity({
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
        deletedAt,
      ];
}

class DocumentDto extends Equatable {
  final int? id;
  final int? modelId;
  final dynamic message;
  final String? collectionName;
  final String? collectionType;
  final String? createdAt;
  final String? updatedAt;
  final String? expirationDate;
  final bool? isUploaded;
  final bool? hasExpiration;
  final FileEntity? file;

  const DocumentDto({
    this.id,
    this.modelId,
    this.message,
    this.collectionName,
    this.collectionType,
    this.createdAt,
    this.updatedAt,
    this.expirationDate,
    this.isUploaded,
    this.hasExpiration,
    this.file,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        id,
        modelId,
        message,
        collectionName,
        collectionType,
        createdAt,
        updatedAt,
        expirationDate,
        isUploaded,
        hasExpiration,
        file,
      ];
}

class Information extends Equatable {
  final General? general;
  final Plate? plate;
  final Ownership? ownership;
  final Lease? lease;
  final Maintenance? maintenance;

  const Information({
    this.general,
    this.plate,
    this.ownership,
    this.lease,
    this.maintenance,
  });

  Map<String, dynamic> toEntity() => {
        "general": general?.toEntity(),
        "plate": plate?.toEntity(),
        "ownership": ownership?.toEntity(),
        "lease": lease?.toEntity(),
        "maintenance": maintenance?.toEntity(),
      };

  @override
  List<Object?> get props => [
        general,
        plate,
        ownership,
        lease,
        maintenance,
      ];
}

class General extends Equatable {
  final int? id;
  final int? identifier;
  final String? maker;
  final String? model;
  final String? makingYear;
  final String? engineMaker;
  final String? engineModel;
  final String? engineYear;
  final String? type;
  final String? vin;
  final String? titleNumber;
  final String? licencePlateNumber;
  final String? status;
  final String? lessor;
  final String? color;
  final String? glider;

  const General({
    this.id,
    this.identifier,
    this.maker,
    this.model,
    this.makingYear,
    this.engineMaker,
    this.engineModel,
    this.engineYear,
    this.type,
    this.vin,
    this.titleNumber,
    this.licencePlateNumber,
    this.status,
    this.lessor,
    this.color,
    this.glider,
  });

  Map<String, dynamic> toEntity() => {
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
        "licence_plate_number": licencePlateNumber,
        "status": status,
        "lessor": lessor,
        "color": color,
        "glider": glider,
      };

  @override
  List<Object?> get props => [
        id,
        identifier,
        maker,
        model,
        makingYear,
        engineMaker,
        engineModel,
        engineYear,
        type,
        vin,
        titleNumber,
        licencePlateNumber,
        status,
        lessor,
        color,
        glider,
      ];
}

class Lease extends Equatable {
  final String? leasingCompany;
  final String? leaseReference;
  final DateTime? leaseEndDate;
  final DateTime? leaseEarlyWalkDate;
  final String? leaseMonthlyPayment;
  final String? leaseMaintenanceCpm;
  final String? leaseMileageYearlyAllowance;

  const Lease({
    this.leasingCompany,
    this.leaseReference,
    this.leaseEndDate,
    this.leaseEarlyWalkDate,
    this.leaseMonthlyPayment,
    this.leaseMaintenanceCpm,
    this.leaseMileageYearlyAllowance,
  });

  Map<String, dynamic> toEntity() => {
        "leasing_company": leasingCompany,
        "lease_reference": leaseReference,
        "lease_end_date":
            "${leaseEndDate?.year.toString().padLeft(4, '0')}-${leaseEndDate?.month.toString().padLeft(2, '0')}-${leaseEndDate?.day.toString().padLeft(2, '0')}",
        "lease_early_walk_date":
            "${leaseEarlyWalkDate?.year.toString().padLeft(4, '0')}-${leaseEarlyWalkDate?.month.toString().padLeft(2, '0')}-${leaseEarlyWalkDate?.day.toString().padLeft(2, '0')}",
        "lease_monthly_payment": leaseMonthlyPayment,
        "lease_maintenance_cpm": leaseMaintenanceCpm,
        "lease_mileage_yearly_allowance": leaseMileageYearlyAllowance,
      };

  @override
  List<Object?> get props => [
        leasingCompany,
        leaseReference,
        leaseEndDate,
        leaseEarlyWalkDate,
        leaseMonthlyPayment,
        leaseMaintenanceCpm,
        leaseMileageYearlyAllowance,
      ];
}

class Maintenance extends Equatable {
  final DateTime? nextInspectionOn;
  final DateTime? inServiceOn;
  final DateTime? nextServiceOn;
  final String? emptyWeight;
  final String? grossWeight;

  const Maintenance({
    this.nextInspectionOn,
    this.inServiceOn,
    this.nextServiceOn,
    this.emptyWeight,
    this.grossWeight,
  });

  Map<String, dynamic> toEntity() => {
        "next_inspection_on":
            "${nextInspectionOn?.year.toString().padLeft(4, '0')}-${nextInspectionOn?.month.toString().padLeft(2, '0')}-${nextInspectionOn?.day.toString().padLeft(2, '0')}",
        "in_service_on":
            "${inServiceOn?.year.toString().padLeft(4, '0')}-${inServiceOn?.month.toString().padLeft(2, '0')}-${inServiceOn?.day.toString().padLeft(2, '0')}",
        "next_service_on":
            "${nextServiceOn?.year.toString().padLeft(4, '0')}-${nextServiceOn?.month.toString().padLeft(2, '0')}-${nextServiceOn?.day.toString().padLeft(2, '0')}",
        "empty_weight": emptyWeight,
        "gross_weight": grossWeight,
      };

  @override
  List<Object?> get props => [
        nextInspectionOn,
        inServiceOn,
        nextServiceOn,
        emptyWeight,
        grossWeight,
      ];
}

class Ownership extends Equatable {
  final String? ownedBy;
  final String? lessor;
  final String? financedBy;
  final String? purchaseDate;
  final String? purchasePrice;
  final String? saleDate;
  final String? salePrice;
  final String? ownerName;
  final String? ownerPhone;

  const Ownership({
    this.ownedBy,
    this.lessor,
    this.financedBy,
    this.purchaseDate,
    this.purchasePrice,
    this.saleDate,
    this.salePrice,
    this.ownerName,
    this.ownerPhone,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        ownedBy,
        lessor,
        financedBy,
        purchaseDate,
        purchasePrice,
        saleDate,
        salePrice,
        ownerName,
        ownerPhone,
      ];
}

class Plate extends Equatable {
  final String? licencePlateNumber;
  final String? licencePlateState;
  final DateTime? tagsExpiresOn;
  final String? platesOwnedBy;

  const Plate({
    this.licencePlateNumber,
    this.licencePlateState,
    this.tagsExpiresOn,
    this.platesOwnedBy,
  });

  Map<String, dynamic> toEntity() => {
        "licence_plate_number": licencePlateNumber,
        "licence_plate_state": licencePlateState,
        "tags_expires_on":
            "${tagsExpiresOn?.year.toString().padLeft(4, '0')}-${tagsExpiresOn?.month.toString().padLeft(2, '0')}-${tagsExpiresOn?.day.toString().padLeft(2, '0')}",
        "plates_owned_by": platesOwnedBy,
      };

  @override
  List<Object?> get props => [
        licencePlateNumber,
        licencePlateState,
        tagsExpiresOn,
        platesOwnedBy,
      ];
}

class Overview extends Equatable {
  final General? truck;
  final List<OverviewRequestedDocument>? requestedDocuments;
  final List<Checklist>? checklists;
  final List<NoteDataEntity>? notes;
  final List<Status>? statuses;

  const Overview({
    this.truck,
    this.requestedDocuments,
    this.checklists,
    this.notes,
    this.statuses,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        truck,
        requestedDocuments,
        checklists,
        notes,
        statuses,
      ];
}

class Checklist extends Equatable {
  final int? id;
  final String? name;
  final dynamic addedDate;
  final dynamic removedDate;
  final String? title;

  const Checklist({
    this.id,
    this.name,
    this.addedDate,
    this.removedDate,
    this.title,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "added_date": addedDate,
        "removed_date": removedDate,
        "title": title,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        addedDate,
        removedDate,
        title,
      ];
}

class User extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? phone;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? teamId;
  final int? departmentId;
  final int? designationId;
  final String? name;
  final String? modelType;
  final bool? isSuperAdmin;
  final String? userDesignation;
  final String? currentStatus;
  final List<Role>? roles;
  final Designation? designation;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.teamId,
    this.departmentId,
    this.designationId,
    this.name,
    this.modelType,
    this.isSuperAdmin,
    this.userDesignation,
    this.currentStatus,
    this.roles,
    this.designation,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        emailVerifiedAt,
        phone,
        image,
        createdAt,
        updatedAt,
        deletedAt,
        teamId,
        departmentId,
        designationId,
        name,
        modelType,
        isSuperAdmin,
        userDesignation,
        currentStatus,
        roles,
        designation,
      ];
}

class Designation extends Equatable {
  final int? id;
  final String? title;
  final String? name;
  final dynamic deletedAt;
  final String? createdAt;
  final DateTime? updatedAt;

  const Designation({
    this.id,
    this.title,
    this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "title": title,
        "name": name,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        title,
        name,
        deletedAt,
        createdAt,
        updatedAt,
      ];
}

class Role extends Equatable {
  final int? id;
  final String? name;
  final String? guardName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Role({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        guardName,
        createdAt,
        updatedAt,
      ];
}

class OverviewRequestedDocument extends Equatable {
  final int? id;
  final dynamic folderId;
  final String? fileType;
  final String? fileName;
  final bool? hasExpiration;
  final bool? optional;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isUploaded;
  final String? size;
  final String? icon;
  final bool? hollow;
  final String? color;

  const OverviewRequestedDocument({
    this.id,
    this.folderId,
    this.fileType,
    this.fileName,
    this.hasExpiration,
    this.optional,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isUploaded,
    this.size,
    this.icon,
    this.hollow,
    this.color,
  });

  Map<String, dynamic> toEntity() => {
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

  @override
  List<Object?> get props => [
        id,
        folderId,
        fileType,
        fileName,
        hasExpiration,
        optional,
        createdAt,
        updatedAt,
        deletedAt,
        isUploaded,
        size,
        icon,
        hollow,
        color,
      ];
}

class Status extends Equatable {
  final int? id;
  final String? name;
  final String? reason;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Status({
    this.id,
    this.name,
    this.reason,
    this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        reason,
        modelId,
        createdAt,
        updatedAt,
      ];
}
