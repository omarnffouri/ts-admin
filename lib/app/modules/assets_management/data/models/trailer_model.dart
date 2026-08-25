import '../../domain/entities/note_entity.dart';
import '../../domain/entities/trailer_entity.dart';
import 'note_model.dart';

class TrailerModel extends TrailerEntity {
  const TrailerModel({
    super.id,
    super.type,
    super.identifier,
    super.ownerType,
    super.maker,
    super.model,
    super.makingYear,
    super.vin,
    super.titleNumber,
    super.licencePlateNumber,
    super.stateId,
    super.stateName,
    super.purchaseDate,
    super.purchasePrice,
    super.saleDate,
    super.salePrice,
    super.financedBy,
    super.leasingCompany,
    super.leaseReference,
    super.inServiceOn,
    super.nextInspectionOn,
    super.ownedBy,
    super.deactivatedOn,
    super.deactivationReason,
    super.tagsExpiresOn,
    super.lastMove,
    super.assetId,
    super.status,
    super.statusText,
    super.notes,
    super.trailerNotes,
    super.noteCount,
    super.expirationDate,
    super.createdAt,
    super.trailerModelPath,
    super.shipmentInspectionPath,
  });

  factory TrailerModel.fromJson(Map<String, dynamic> json) => TrailerModel(
        id: json["id"],
        type: json["type"],
        identifier: json["identifier"],
        ownerType: json["owner_type"],
        maker: json["maker"],
        model: json["model"],
        makingYear: json["making_year"],
        vin: json["vin"],
        titleNumber: json["title_number"],
        licencePlateNumber: json["licence_plate_number"],
        stateId: json["state_id"],
        stateName: json["state_name"],
        purchaseDate: json["purchase_date"] == null
            ? null
            : DateTime.parse(json["purchase_date"]),
        purchasePrice: json["purchase_price"],
        saleDate: json["sale_date"] == null
            ? null
            : DateTime.parse(json["sale_date"]),
        salePrice: json["sale_price"],
        financedBy: json["financed_by"],
        leasingCompany: json["leasing_company"],
        leaseReference: json["lease_reference"],
        inServiceOn: json["in_service_on"] == null
            ? null
            : DateTime.parse(json["in_service_on"]),
        nextInspectionOn: json["next_inspection_on"] == null
            ? null
            : DateTime.parse(json["next_inspection_on"]),
        ownedBy: json["owned_by"],
        deactivatedOn: json["deactivated_on"],
        deactivationReason: json["deactivation_reason"],
        tagsExpiresOn: json["tags_expires_on"],
        lastMove: json["last_move"],
        assetId: json["asset_id"],
        status: json["status"],
        statusText: json["status_text"],
        notes: json["notes"],
        trailerNotes: json["trailer_notes"] == null
            ? []
            : List<NoteDataEntity>.from(
                json["trailer_notes"]!.map((x) => NoteDataModel.fromJson(x))),
        noteCount: json["note_count"],
        expirationDate: json["expiration_date"] == null
            ? null
            : DateTime.parse(json["expiration_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        trailerModelPath: json["trailer_model_path"],
        shipmentInspectionPath: json["shipment_inspection_path"],
      );

  Map<String, dynamic> toJson() => {
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
}
