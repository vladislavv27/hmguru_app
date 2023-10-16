class InvoiceInfo {
  final String invoiceId;
  final String invoiceUID;
  final double sumTotal;
  final bool isPaid;
  final bool receiveInvoices;
  final String subscriptionId;
  final bool allowAddNewMeterReadings;
  final int meterReadingActivationDay;
  final int meterReadingDueDay;
  final int invoiceDeliveryType;

  InvoiceInfo({
    required this.invoiceId,
    required this.invoiceUID,
    required this.sumTotal,
    required this.isPaid,
    required this.receiveInvoices,
    required this.subscriptionId,
    required this.allowAddNewMeterReadings,
    required this.meterReadingActivationDay,
    required this.meterReadingDueDay,
    required this.invoiceDeliveryType,
  });

  factory InvoiceInfo.fromJson(Map<String, dynamic> json) {
    return InvoiceInfo(
      invoiceId: json['invoiceId'],
      invoiceUID: json['invoiceUID'],
      sumTotal: (json['sumTotal'] as num).toDouble(),
      isPaid: json['isPaid'],
      receiveInvoices: json['receiveInvoices'],
      subscriptionId: json['subscriptionId'],
      allowAddNewMeterReadings: json['allowAddNewMeterReadings'],
      meterReadingActivationDay: json['meterReadingActivationDay'],
      meterReadingDueDay: json['meterReadingDueDay'],
      invoiceDeliveryType: json['invoiceDeliveryType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'invoiceUID': invoiceUID,
      'sumTotal': sumTotal,
      'isPaid': isPaid,
      'receiveInvoices': receiveInvoices,
      'subscriptionId': subscriptionId,
      'allowAddNewMeterReadings': allowAddNewMeterReadings,
      'meterReadingActivationDay': meterReadingActivationDay,
      'meterReadingDueDay': meterReadingDueDay,
      'invoiceDeliveryType': invoiceDeliveryType,
    };
  }
}
