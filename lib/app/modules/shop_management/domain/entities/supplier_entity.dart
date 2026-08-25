import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final int? id;
  final String? name;
  final String? representative;
  final String? taxReference;
  final String? phone;
  final String? email;
  final String? address;
  final dynamic deletedAt;
  final bool? isActive;

  const SupplierEntity({
    this.id,
    this.name,
    this.representative,
    this.taxReference,
    this.phone,
    this.email,
    this.address,
    this.deletedAt,
    this.isActive,
  });

  toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      representative: representative,
      taxReference: taxReference,
      phone: phone,
      email: email,
      address: address,
      deletedAt: deletedAt,
      isActive: isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        representative,
        taxReference,
        phone,
        email,
        address,
        deletedAt,
        isActive,
      ];
}
