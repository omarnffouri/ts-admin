import '../../domain/entities/supplier_entity.dart';

class SupplierModel extends SupplierEntity {
  const SupplierModel({
    super.id,
    super.name,
    super.representative,
    super.taxReference,
    super.phone,
    super.email,
    super.address,
    super.deletedAt,
    super.isActive,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json["id"],
        name: json["name"],
        representative: json["representative"],
        taxReference: json["tax_reference"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        deletedAt: json["deleted_at"],
        isActive: json["status"] == "active",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "representative": representative,
        "tax_reference": taxReference,
        "phone": phone,
        "email": email,
        "address": address,
        "deleted_at": deletedAt,
      };
}
