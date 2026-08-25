import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    super.id,
    super.companyName,
    super.contactPerson,
    super.contactNumber,
    super.address,
    super.taxNumber,
    super.email,
    super.isActive,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"].toString(),
        companyName: json["company_name"],
        contactPerson: json["contact_person"],
        contactNumber: json["contact_number"],
        address: json["address"],
        taxNumber: json["tax_number"],
        email: json["email"],
        isActive: json["status"] == "active",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "contact_person": contactPerson,
        "contact_number": contactNumber,
        "address": address,
        "tax_number": taxNumber,
        "email": email,
      };
}
