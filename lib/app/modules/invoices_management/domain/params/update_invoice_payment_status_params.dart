class UpdateInvoicePaymentStatusParams {
  int invoiceId;
  String status;
  int updatedBy;
  UpdateInvoicePaymentStatusParams({
    required this.invoiceId,
    required this.status,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': invoiceId,
      'status': status,
      'updated_by': updatedBy,
    };
  }
}
