import 'package:equatable/equatable.dart';

import 'note_entity.dart';

class TruckEntity extends Equatable {
  final int? id;
  final int? identifier;
  final String? maker;
  final dynamic model;
  final String? makingYear;
  final String? engineMaker;
  final String? engineModel;
  final dynamic engineYear;
  final String? type;
  final String? vin;
  final String? titleNumber;
  final String? licencePlateNumber;
  final int? licencePlateStateId;
  final String? stateName;
  final String? platesOwnedBy;
  final DateTime? tagsExpiresOn;
  final DateTime? nextInspectionOn;
  final DateTime? inServiceOn;
  final DateTime? nextServiceOn;
  final String? ownedBy;
  final String? ownerName;
  final String? ownerPhone;
  final int? lessorId;
  final String? lessorName;
  final String? financedBy;
  final DateTime? purchaseDate;
  final int? purchasePrice;
  final DateTime? saleDate;
  final int? salePrice;
  final String? color;
  final int? glider;
  final String? leasingCompany;
  final String? leaseReference;
  final DateTime? leaseEndDate;
  final DateTime? leaseEarlyWalkDate;
  final String? leaseMonthlyPayment;
  final String? leaseMaintenanceCpm;
  final dynamic leaseMileageYearlyAllowance;
  final String? emptyWeight;
  final String? grossWeight;
  final String? status;
  final String? statusText;
  final String? notes;
  final List<NoteDataEntity>? truckNotes;
  final int? noteCount;
  final DateTime? createdAt;
  final String? truckModelPath;
  final String? leaseAgreementPath;
  final String? shipmentInspectionPath;
  final List<DriverEntity>? drivers;
  final List<DeviceEntity>? devices;

  const TruckEntity({
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
    this.licencePlateStateId,
    this.stateName,
    this.platesOwnedBy,
    this.tagsExpiresOn,
    this.nextInspectionOn,
    this.inServiceOn,
    this.nextServiceOn,
    this.ownedBy,
    this.ownerName,
    this.ownerPhone,
    this.lessorId,
    this.lessorName,
    this.financedBy,
    this.purchaseDate,
    this.purchasePrice,
    this.saleDate,
    this.salePrice,
    this.color,
    this.glider,
    this.leasingCompany,
    this.leaseReference,
    this.leaseEndDate,
    this.leaseEarlyWalkDate,
    this.leaseMonthlyPayment,
    this.leaseMaintenanceCpm,
    this.leaseMileageYearlyAllowance,
    this.emptyWeight,
    this.grossWeight,
    this.status,
    this.statusText,
    this.notes,
    this.truckNotes,
    this.noteCount,
    this.createdAt,
    this.truckModelPath,
    this.leaseAgreementPath,
    this.shipmentInspectionPath,
    this.drivers,
    this.devices,
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
        "licence_plate_state_id": licencePlateStateId,
        "state_name": stateName,
        "plates_owned_by": platesOwnedBy,
        "tags_expires_on":
            "${tagsExpiresOn!.year.toString().padLeft(4, '0')}-${tagsExpiresOn!.month.toString().padLeft(2, '0')}-${tagsExpiresOn!.day.toString().padLeft(2, '0')}",
        "next_inspection_on":
            "${nextInspectionOn!.year.toString().padLeft(4, '0')}-${nextInspectionOn!.month.toString().padLeft(2, '0')}-${nextInspectionOn!.day.toString().padLeft(2, '0')}",
        "in_service_on":
            "${inServiceOn!.year.toString().padLeft(4, '0')}-${inServiceOn!.month.toString().padLeft(2, '0')}-${inServiceOn!.day.toString().padLeft(2, '0')}",
        "next_service_on":
            "${nextServiceOn!.year.toString().padLeft(4, '0')}-${nextServiceOn!.month.toString().padLeft(2, '0')}-${nextServiceOn!.day.toString().padLeft(2, '0')}",
        "owned_by": ownedBy,
        "owner_name": ownerName,
        "owner_phone": ownerPhone,
        "lessor_id": lessorId,
        "lessor_name": lessorName,
        "financed_by": financedBy,
        "purchase_date":
            "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}",
        "purchase_price": purchasePrice,
        "sale_date":
            "${saleDate!.year.toString().padLeft(4, '0')}-${saleDate!.month.toString().padLeft(2, '0')}-${saleDate!.day.toString().padLeft(2, '0')}",
        "sale_price": salePrice,
        "color": color,
        "glider": glider,
        "leasing_company": leasingCompany,
        "lease_reference": leaseReference,
        "lease_end_date":
            "${leaseEndDate!.year.toString().padLeft(4, '0')}-${leaseEndDate!.month.toString().padLeft(2, '0')}-${leaseEndDate!.day.toString().padLeft(2, '0')}",
        "lease_early_walk_date":
            "${leaseEarlyWalkDate!.year.toString().padLeft(4, '0')}-${leaseEarlyWalkDate!.month.toString().padLeft(2, '0')}-${leaseEarlyWalkDate!.day.toString().padLeft(2, '0')}",
        "lease_monthly_payment": leaseMonthlyPayment,
        "lease_maintenance_cpm": leaseMaintenanceCpm,
        "lease_mileage_yearly_allowance": leaseMileageYearlyAllowance,
        "empty_weight": emptyWeight,
        "gross_weight": grossWeight,
        "status": status,
        "status_text": statusText,
        "notes": notes,
        "truck_notes": truckNotes == null
            ? []
            : List<dynamic>.from(truckNotes!.map((x) => x.toEntity())),
        "note_count": noteCount,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "truck_model_path": truckModelPath,
        "lease_agreement_path": leaseAgreementPath,
        "shipment_inspection_path": shipmentInspectionPath,
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toEntity())),
        "devices": devices == null
            ? []
            : List<dynamic>.from(devices!.map((x) => x.toEntity())),
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
        licencePlateStateId,
        stateName,
        platesOwnedBy,
        tagsExpiresOn,
        nextInspectionOn,
        inServiceOn,
        nextServiceOn,
        ownedBy,
        ownerName,
        ownerPhone,
        lessorId,
        lessorName,
        financedBy,
        purchaseDate,
        purchasePrice,
        saleDate,
        salePrice,
        color,
        glider,
        leasingCompany,
        leaseReference,
        leaseEndDate,
        leaseEarlyWalkDate,
        leaseMonthlyPayment,
        leaseMaintenanceCpm,
        leaseMileageYearlyAllowance,
        emptyWeight,
        grossWeight,
        status,
        statusText,
        notes,
        truckNotes?.length ?? 0,
        noteCount,
        createdAt?.toIso8601String(),
      ];
}

class DeviceEntity extends Equatable {
  final int? id;
  final String? type;

  const DeviceEntity({
    this.id,
    this.type,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "type": type,
      };

  @override
  List<Object?> get props => [
        id,
        type,
      ];
}

class DriverEntity extends Equatable {
  final int? id;
  final String? name;

  const DriverEntity({
    this.id,
    this.name,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
