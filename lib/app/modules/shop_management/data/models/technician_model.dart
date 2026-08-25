import 'dart:convert';

import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';

TechnicianModel technicianModelFromJson(String str) =>
    TechnicianModel.fromJson(json.decode(str));

String technicianModelToJson(TechnicianModel data) =>
    json.encode(data.toJson());

class TechnicianModel extends TechnicianEntity {
  const TechnicianModel({
    super.id,
    super.name,
    super.firstName,
    super.lastName,
    super.isActive,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) =>
      TechnicianModel(
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        isActive: json["status"] == "active",
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
      };
}
