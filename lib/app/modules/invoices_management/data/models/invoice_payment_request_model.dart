// To parse this JSON data, do
//
//     final invoicePaymentEntity = invoicePaymentEntityFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/invoice_payment_request_entity.dart';

InvoicePaymentModel invoicePaymentModelFromJson(String str) =>
    InvoicePaymentModel.fromJson(json.decode(str));

String invoicePaymentModelToJson(InvoicePaymentModel data) =>
    json.encode(data.toJson());

class InvoicePaymentModel extends InvoicePaymentEntity {
  const InvoicePaymentModel(
      {super.id,
      super.invoicePaymentId,
      super.shipmentNumber,
      super.invoiceNumber,
      super.actualAmount,
      super.updatedAmount,
      super.createdBy,
      super.createdAt});

  factory InvoicePaymentModel.fromJson(Map<String, dynamic> json) =>
      InvoicePaymentModel(
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

  @override
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
}
