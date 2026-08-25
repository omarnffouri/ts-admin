import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final String? id;
  final String? companyName;
  final String? contactPerson;
  final String? contactNumber;
  final String? address;
  final String? taxNumber;
  final String? email;
  final bool? isActive;

  const ClientEntity({
    this.id,
    this.companyName,
    this.contactPerson,
    this.contactNumber,
    this.address,
    this.taxNumber,
    this.email,
    this.isActive,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "company_name": companyName,
        "contact_person": contactPerson,
        "contact_number": contactNumber,
        "address": address,
        "tax_number": taxNumber,
        "email": email,
      };

  @override
  List<Object?> get props => [
        id,
        companyName,
        contactPerson,
        contactNumber,
        address,
        taxNumber,
        email,
        isActive,
      ];
}
