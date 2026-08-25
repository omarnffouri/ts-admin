import 'package:equatable/equatable.dart';

class TechnicianEntity extends Equatable {
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final bool? isActive;

  const TechnicianEntity({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.isActive,
  });

  factory TechnicianEntity.fromJson(Map<String, dynamic> json) =>
      TechnicianEntity(
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        firstName,
        lastName,
      ];
}
