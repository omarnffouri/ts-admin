// To parse this JSON data, do
//
//     final pendingDriverModel = pendingDriverModelFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class InspectionTrailerTruckEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? requestBy;
  final String? inspectedBy;
  final String? trailerLocation;
  final String? status;
  final String? truckIdentifier;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final isDeleting = false.obs;
  final ExpansibleController tileController = ExpansibleController();

  InspectionTrailerTruckEntity({
    this.id,
    this.userId,
    this.requestBy,
    this.inspectedBy,
    this.trailerLocation,
    this.status,
    this.truckIdentifier,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        requestBy,
        inspectedBy,
        trailerLocation,
        status,
        truckIdentifier,
        createdAt,
        updatedAt,
      ];
}
