import 'package:equatable/equatable.dart';

import 'note_entity.dart';

class TrailerEntity extends Equatable {
  final int? id;
  final String? type;
  final int? identifier;
  final String? ownerType;
  final String? maker;
  final String? model;
  final String? makingYear;
  final String? vin;
  final String? titleNumber;
  final String? licencePlateNumber;
  final int? stateId;
  final String? stateName;
  final DateTime? purchaseDate;
  final num? purchasePrice;
  final DateTime? saleDate;
  final dynamic salePrice;
  final dynamic financedBy;
  final dynamic leasingCompany;
  final dynamic leaseReference;
  final DateTime? inServiceOn;
  final DateTime? nextInspectionOn;
  final String? ownedBy;
  final dynamic deactivatedOn;
  final dynamic deactivationReason;
  final dynamic tagsExpiresOn;
  final dynamic lastMove;
  final dynamic assetId;
  final String? status;
  final String? statusText;
  final String? notes;
  final List<NoteDataEntity>? trailerNotes;
  final int? noteCount;
  final DateTime? expirationDate;
  final DateTime? createdAt;
  final String? trailerModelPath;
  final String? shipmentInspectionPath;

  const TrailerEntity({
    this.id,
    this.type,
    this.identifier,
    this.ownerType,
    this.maker,
    this.model,
    this.makingYear,
    this.vin,
    this.titleNumber,
    this.licencePlateNumber,
    this.stateId,
    this.stateName,
    this.purchaseDate,
    this.purchasePrice,
    this.saleDate,
    this.salePrice,
    this.financedBy,
    this.leasingCompany,
    this.leaseReference,
    this.inServiceOn,
    this.nextInspectionOn,
    this.ownedBy,
    this.deactivatedOn,
    this.deactivationReason,
    this.tagsExpiresOn,
    this.lastMove,
    this.assetId,
    this.status,
    this.statusText,
    this.notes,
    this.trailerNotes,
    this.noteCount,
    this.expirationDate,
    this.createdAt,
    this.trailerModelPath,
    this.shipmentInspectionPath,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "type": type,
        "identifier": identifier,
        "owner_type": ownerType,
        "maker": maker,
        "model": model,
        "making_year": makingYear,
        "vin": vin,
        "title_number": titleNumber,
        "licence_plate_number": licencePlateNumber,
        "state_id": stateId,
        "state_name": stateName,
        "purchase_date":
            "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}",
        "purchase_price": purchasePrice,
        "sale_date":
            "${saleDate!.year.toString().padLeft(4, '0')}-${saleDate!.month.toString().padLeft(2, '0')}-${saleDate!.day.toString().padLeft(2, '0')}",
        "sale_price": salePrice,
        "financed_by": financedBy,
        "leasing_company": leasingCompany,
        "lease_reference": leaseReference,
        "in_service_on":
            "${inServiceOn!.year.toString().padLeft(4, '0')}-${inServiceOn!.month.toString().padLeft(2, '0')}-${inServiceOn!.day.toString().padLeft(2, '0')}",
        "next_inspection_on":
            "${nextInspectionOn!.year.toString().padLeft(4, '0')}-${nextInspectionOn!.month.toString().padLeft(2, '0')}-${nextInspectionOn!.day.toString().padLeft(2, '0')}",
        "owned_by": ownedBy,
        "deactivated_on": deactivatedOn,
        "deactivation_reason": deactivationReason,
        "tags_expires_on": tagsExpiresOn,
        "last_move": lastMove,
        "asset_id": assetId,
        "status": status,
        "status_text": statusText,
        "notes": notes,
        "trailer_notes": trailerNotes == null
            ? []
            : List<dynamic>.from(trailerNotes!.map((x) => x.toEntity())),
        "note_count": noteCount,
        "expiration_date":
            "${expirationDate!.year.toString().padLeft(4, '0')}-${expirationDate!.month.toString().padLeft(2, '0')}-${expirationDate!.day.toString().padLeft(2, '0')}",
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "trailer_model_path": trailerModelPath,
        "shipment_inspection_path": shipmentInspectionPath,
      };

  @override
  List<Object?> get props => [
        id,
        type,
        identifier,
        ownerType,
        maker,
        model,
        makingYear,
        vin,
        titleNumber,
        licencePlateNumber,
        stateId,
        stateName,
        purchaseDate,
        purchasePrice,
        saleDate,
        salePrice,
        financedBy,
        leasingCompany,
        leaseReference,
        inServiceOn,
        nextInspectionOn,
        ownedBy,
        deactivatedOn,
        deactivationReason,
        tagsExpiresOn,
        lastMove,
        assetId,
        status,
        statusText,
        notes,
        trailerNotes ?? [],
        noteCount,
        expirationDate,
        createdAt,
        trailerModelPath,
        shipmentInspectionPath
      ];
}
