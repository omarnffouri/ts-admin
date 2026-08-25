// To parse this JSON data, do
//
//     final ruleModel = ruleModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/rule_entity.dart';

RuleModel ruleModelFromJson(String str) => RuleModel.fromJson(json.decode(str));

String ruleModelToJson(RuleModel data) => json.encode(data.toJson());

// ignore: must_be_immutable
class RuleModel extends RuleEntity {
  RuleModel({
    super.id,
    super.name,
  });

  RuleModel copyWith({
    String? id,
    String? name,
  }) =>
      RuleModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory RuleModel.fromJson(Map<String, dynamic> json) => RuleModel(
        id: json["id"].toString(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
