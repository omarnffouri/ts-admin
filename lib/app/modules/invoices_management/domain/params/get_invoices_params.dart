class GetInvoicesParams {
  String action;
  String status;
  GetInvoicesParams({
    required this.action,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'action': action, 'status': status};
  }
}
