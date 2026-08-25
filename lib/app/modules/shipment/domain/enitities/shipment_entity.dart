import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class ShipmentEntity extends Equatable {
  final int? id;
  final String? shipmentNumber;
  final String? customerReference;
  final String? bolNumber;
  final String? trailerId;
  final String? truckId;
  final String? status;
  final String? customer;
  final String? type;
  final num? revenue;
  final List<Driver>? drivers;
  final isExpanded = false.obs;
  final showDownArrow = false.obs;

  ShipmentEntity({
    this.id,
    this.shipmentNumber,
    this.customerReference,
    this.bolNumber,
    this.trailerId,
    this.truckId,
    this.status,
    this.customer,
    this.type,
    this.revenue,
    this.drivers,
  });

  @override
  List<Object?> get props => [
        id,
        shipmentNumber,
        customerReference,
        bolNumber,
        trailerId,
        truckId,
        status,
        customer,
        type,
        revenue,
        drivers,
      ];
}

class Driver extends Equatable {
  final int? id;
  final String? name;
  final String? type;
  final String? settlementStatus;
  final String? category;
  final int? truck;

  const Driver({
    this.id,
    this.name,
    this.type,
    this.settlementStatus,
    this.category,
    this.truck,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "trip_type": type,
        "settlement_status": settlementStatus,
        "category": category,
        "truck": truck,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        settlementStatus,
        category,
        truck,
      ];
}
