// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/data_entity.dart';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel extends DataEntity {
  const DataModel({
    super.id,
    super.title,
    super.name,
    super.createdAt,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        id: json["id"].toString(),
        title: json["title"],
        name: json["name"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "created_at": createdAt,
      };
}
