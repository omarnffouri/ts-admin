import '../../domain/entities/note_entity.dart';
import '../../domain/entities/truck_entity.dart';
import 'note_model.dart';

class TruckModel extends TruckEntity {
  const TruckModel({
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
    super.licencePlateStateId,
    super.stateName,
    super.platesOwnedBy,
    super.tagsExpiresOn,
    super.nextInspectionOn,
    super.inServiceOn,
    super.nextServiceOn,
    super.ownedBy,
    super.ownerName,
    super.ownerPhone,
    super.lessorId,
    super.lessorName,
    super.financedBy,
    super.purchaseDate,
    super.purchasePrice,
    super.saleDate,
    super.salePrice,
    super.color,
    super.glider,
    super.leasingCompany,
    super.leaseReference,
    super.leaseEndDate,
    super.leaseEarlyWalkDate,
    super.leaseMonthlyPayment,
    super.leaseMaintenanceCpm,
    super.leaseMileageYearlyAllowance,
    super.emptyWeight,
    super.grossWeight,
    super.status,
    super.statusText,
    super.notes,
    super.truckNotes,
    super.noteCount,
    super.createdAt,
    super.truckModelPath,
    super.leaseAgreementPath,
    super.shipmentInspectionPath,
    super.drivers,
    super.devices,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) => TruckModel(
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
        licencePlateStateId: json["licence_plate_state_id"],
        stateName: json["state_name"],
        platesOwnedBy: json["plates_owned_by"],
        tagsExpiresOn: json["tags_expires_on"] == null
            ? null
            : DateTime.parse(json["tags_expires_on"]),
        nextInspectionOn: json["next_inspection_on"] == null
            ? null
            : DateTime.parse(json["next_inspection_on"]),
        inServiceOn: json["in_service_on"] == null
            ? null
            : DateTime.parse(json["in_service_on"]),
        nextServiceOn: json["next_service_on"] == null
            ? null
            : DateTime.parse(json["next_service_on"]),
        ownedBy: json["owned_by"],
        ownerName: json["owner_name"],
        ownerPhone: json["owner_phone"],
        lessorId: json["lessor_id"],
        lessorName: json["lessor_name"],
        financedBy: json["financed_by"],
        purchaseDate: json["purchase_date"] == null
            ? null
            : DateTime.parse(json["purchase_date"]),
        purchasePrice: json["purchase_price"],
        saleDate: json["sale_date"] == null
            ? null
            : DateTime.parse(json["sale_date"]),
        salePrice: json["sale_price"],
        color: json["color"],
        glider: json["glider"],
        leasingCompany: json["leasing_company"],
        leaseReference: json["lease_reference"],
        leaseEndDate: json["lease_end_date"] == null
            ? null
            : DateTime.parse(json["lease_end_date"]),
        leaseEarlyWalkDate: json["lease_early_walk_date"] == null
            ? null
            : DateTime.parse(json["lease_early_walk_date"]),
        leaseMonthlyPayment: json["lease_monthly_payment"],
        leaseMaintenanceCpm: json["lease_maintenance_cpm"],
        leaseMileageYearlyAllowance: json["lease_mileage_yearly_allowance"],
        emptyWeight: json["empty_weight"],
        grossWeight: json["gross_weight"],
        status: json["status"],
        statusText: json["status_text"],
        notes: json["notes"],
        truckNotes: json["truck_notes"] == null
            ? []
            : List<NoteDataEntity>.from(
                json["truck_notes"]!.map((x) => NoteDataModel.fromJson(x))),
        noteCount: json["note_count"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        truckModelPath: json["truck_model_path"],
        leaseAgreementPath: json["lease_agreement_path"],
        shipmentInspectionPath: json["shipment_inspection_path"],
        drivers: json["drivers"] == null
            ? []
            : List<Driver>.from(
                json["drivers"]!.map((x) => Driver.fromJson(x))),
        devices: json["devices"] == null
            ? []
            : List<Device>.from(
                json["devices"]!.map((x) => Device.fromJson(x))),
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
            : List<dynamic>.from(truckNotes!.map((x) => x)),
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
}

class Device extends DeviceEntity {
  const Device({
    super.id,
    super.type,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}

class Driver extends DriverEntity {
  const Driver({
    super.id,
    super.name,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
