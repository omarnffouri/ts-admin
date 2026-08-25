// To parse this JSON data, do
//
//     final invoicePaymentEntity = invoicePaymentEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

InvoicePaymentEntity invoicePaymentEntityFromJson(String str) =>
    InvoicePaymentEntity.fromJson(json.decode(str));

String invoicePaymentEntityToJson(InvoicePaymentEntity data) =>
    json.encode(data.toJson());

class InvoicePaymentEntity extends Equatable {
  final int? id;
  final int? invoicePaymentId;
  final String? shipmentNumber;
  final String? invoiceNumber;
  final double? actualAmount;
  final double? updatedAmount;
  final String? createdBy;
  final DateTime? createdAt;

  const InvoicePaymentEntity(
      {this.id,
      this.invoicePaymentId,
      this.shipmentNumber,
      this.invoiceNumber,
      this.actualAmount,
      this.updatedAmount,
      this.createdBy,
      this.createdAt});

  factory InvoicePaymentEntity.fromJson(Map<String, dynamic> json) =>
      InvoicePaymentEntity(
        id: json["id"],
        invoicePaymentId: json["invoice_payment_id"],
        shipmentNumber: json["shipment_number"],
        invoiceNumber: json["invoice_number"],
        actualAmount: json["actual_amount"].toDouble(),
        updatedAmount: json["updated_amount"].toDouble(),
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_payment_id": invoicePaymentId,
        "shipment_number": shipmentNumber,
        "invoice_number": invoiceNumber,
        "actual_amount": actualAmount,
        "updated_amount": updatedAmount,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        invoicePaymentId,
        shipmentNumber,
        invoiceNumber,
        actualAmount,
        updatedAmount,
        createdBy,
        createdAt
      ];
}
