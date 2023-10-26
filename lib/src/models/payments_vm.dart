class PaymentListVM {
  String? id;
  String submitter;
  double amount;
  String period;
  int numericPeriod;

  PaymentListVM({
    this.id,
    required this.submitter,
    required this.amount,
    required this.period,
    required this.numericPeriod,
  });

  factory PaymentListVM.fromJson(Map<String, dynamic> json) {
    return PaymentListVM(
      id: json['id'],
      submitter: json['submitter'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      period: json['period'] ?? '',
      numericPeriod: json['numericPeriod'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'submitter': submitter,
      'amount': amount,
      'period': period,
      'numericPeriod': numericPeriod,
    };
  }
}

class PaymentDetailVM {
  String id;
  DateTime period;
  double amount;
  String submitter;
  String bankTransactionComment;
  String bankTransactionID;
  String currency;
  DateTime submittedOn;
  DateTime receivedOn;
  String invoiceId;
  String invoiceUID;

  PaymentDetailVM({
    required this.id,
    required this.period,
    required this.amount,
    required this.submitter,
    required this.bankTransactionComment,
    required this.bankTransactionID,
    required this.currency,
    required this.submittedOn,
    required this.receivedOn,
    required this.invoiceId,
    required this.invoiceUID,
  });

  factory PaymentDetailVM.fromJson(Map<String, dynamic> json) {
    return PaymentDetailVM(
      id: json['id'],
      period: DateTime.parse(json['period']),
      amount: json['amount'],
      submitter: json['submitter'],
      bankTransactionComment: json['bankTransactionComment'],
      bankTransactionID: json['bankTransactionID'],
      currency: json['currency'],
      submittedOn: DateTime.parse(json['submittedOn']),
      receivedOn: DateTime.parse(json['receivedOn']),
      invoiceId: json['invoiceId'],
      invoiceUID: json['invoiceUID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'period': period.toIso8601String(),
      'amount': amount,
      'submitter': submitter,
      'bankTransactionComment': bankTransactionComment,
      'bankTransactionID': bankTransactionID,
      'currency': currency,
      'submittedOn': submittedOn.toIso8601String(),
      'receivedOn': receivedOn.toIso8601String(),
      'invoiceId': invoiceId,
      'invoiceUID': invoiceUID,
    };
  }
}
