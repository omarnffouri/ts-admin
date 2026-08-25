// To parse this JSON data, do
//
//     final pendingDriverModel = pendingDriverModelFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InspectionDriverEntity extends Equatable {
  final String? id;
  final String? name;
  final String? phone;
  final String? requestBy;
  final String? inspectedBy;
  final String? status;
  final String? truckIdentifier;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final isDeleting = false.obs;
  final ExpansibleController tileController = ExpansibleController();

  InspectionDriverEntity({
    this.id,
    this.name,
    this.phone,
    this.requestBy,
    this.inspectedBy,
    this.status,
    this.truckIdentifier,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        requestBy,
        inspectedBy,
        status,
        truckIdentifier,
        createdAt,
        updatedAt,
      ];
}
