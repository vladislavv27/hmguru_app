class InvoiceList {
  final String invoiceUID;
  final String payed;
  final String priceRecalculationValueTotal;
  final String sumTotal;
  final String toPayForPeriod;
  final String debt;
  final String penalty;
  final String paymentSum;
  final String paymentAdjustmentSum;
  final String previousBalance;
  final DateTime period;
  final String leaseholdId;
  final String id;
  final DateTime created;
  final String createdById;
  final dynamic createdBy;
  final DateTime modified;
  final String modifiedById;
  final dynamic modifiedBy;
  final bool isDeleted;
  final String rowVersion;

  InvoiceList({
    required this.invoiceUID,
    required this.payed,
    required this.priceRecalculationValueTotal,
    required this.sumTotal,
    required this.toPayForPeriod,
    required this.debt,
    required this.penalty,
    required this.paymentSum,
    required this.paymentAdjustmentSum,
    required this.previousBalance,
    required this.period,
    required this.leaseholdId,
    required this.id,
    required this.created,
    required this.createdById,
    required this.modified,
    required this.modifiedById,
    required this.isDeleted,
    required this.rowVersion,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory InvoiceList.fromJson(Map<String, dynamic> json) {
    return InvoiceList(
      invoiceUID: json['invoiceUID'] ?? '',
      payed: json['payed'] ?? '',
      priceRecalculationValueTotal: json['priceRecalculationValueTotal'] ?? '',
      sumTotal: json['sumTotal'] ?? '',
      toPayForPeriod: json['toPayForPeriod'] ?? '',
      debt: json['debt'] ?? '',
      penalty: json['penalty'] ?? '',
      paymentSum: json['paymentSum'] ?? '',
      paymentAdjustmentSum: json['paymentAdjustmentSum'] ?? '',
      previousBalance: json['previousBalance'] ?? '',
      period: DateTime.parse(json['period']),
      leaseholdId: json['leaseholdId'] ?? '',
      id: json['id'] ?? '',
      created: DateTime.parse(json['created']),
      createdById: json['createdById'] ?? '',
      modified: DateTime.parse(json['modified']),
      modifiedById: json['modifiedById'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      rowVersion: json['rowVersion'] ?? '',
      createdBy: json['createdBy'],
      modifiedBy: json['modifiedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceUID': invoiceUID,
      'payed': payed,
      'priceRecalculationValueTotal': priceRecalculationValueTotal,
      'sumTotal': sumTotal,
      'toPayForPeriod': toPayForPeriod,
      'debt': debt,
      'penalty': penalty,
      'paymentSum': paymentSum,
      'paymentAdjustmentSum': paymentAdjustmentSum,
      'previousBalance': previousBalance,
      'period': period.toIso8601String(),
      'leaseholdId': leaseholdId,
      'id': id,
      'created': created.toIso8601String(),
      'createdById': createdById,
      'modified': modified.toIso8601String(),
      'modifiedById': modifiedById,
      'isDeleted': isDeleted,
      'rowVersion': rowVersion,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }
}
