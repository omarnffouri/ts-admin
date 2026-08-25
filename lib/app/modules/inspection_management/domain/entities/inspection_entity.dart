import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InspectionEntity extends Equatable {
  final int? id;
  final String? type;
  final List<CheckEntity>? checks;
  bool? isSelectedAll;
  final ExpansibleController tileController = ExpansibleController();

  InspectionEntity({
    this.id,
    this.type,
    this.checks,
    this.isSelectedAll,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        checks,
      ];
}

// ignore: must_be_immutable
class CheckEntity extends Equatable {
  final int? id;
  final int? categoryId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final int? value;
  bool? isPassed;

  CheckEntity({
    this.id,
    this.categoryId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.value,
    this.isPassed,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title": title,
        "value": value,
      };

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        createdAt,
        updatedAt,
        title,
        value,
        isPassed,
      ];
}
