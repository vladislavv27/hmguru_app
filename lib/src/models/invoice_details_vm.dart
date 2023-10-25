class InvoiceDetailVM {
  final String invoiceUID;
  final String serviceTitle;
  final String priceForService;
  final String priceTaxTotal;
  final String priceForServiceTotal;
  final String priceRecalculationValue;
  final String payedForService;
  final String paymentForService;
  final String debtForService;
  final String debtRecalculationValue;
  final String penaltyForService;
  final String penaltyForServiceTotal;
  final String penaltyRecalculationValue;
  final String rateFee;
  final String rateCoeficient;
  final String rateFormula;
  final int apartmentResidentCount;
  final String invoiceId;
  final String serviceId;
  final String leaseholdId;

  InvoiceDetailVM({
    required this.invoiceUID,
    required this.serviceTitle,
    required this.priceForService,
    required this.priceTaxTotal,
    required this.priceForServiceTotal,
    required this.priceRecalculationValue,
    required this.payedForService,
    required this.paymentForService,
    required this.debtForService,
    required this.debtRecalculationValue,
    required this.penaltyForService,
    required this.penaltyForServiceTotal,
    required this.penaltyRecalculationValue,
    required this.rateFee,
    required this.rateCoeficient,
    required this.rateFormula,
    required this.apartmentResidentCount,
    required this.invoiceId,
    required this.serviceId,
    required this.leaseholdId,
  });

  factory InvoiceDetailVM.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailVM(
      invoiceUID: json['invoiceUID'],
      serviceTitle: json['serviceTitle'],
      priceForService: json['priceForService'],
      priceTaxTotal: json['priceTaxTotal'],
      priceForServiceTotal: json['priceForServiceTotal'],
      priceRecalculationValue: json['priceRecalculationValue'],
      payedForService: json['payedForService'],
      paymentForService: json['paymentForService'],
      debtForService: json['debtForService'],
      debtRecalculationValue: json['debtRecalculationValue'],
      penaltyForService: json['penaltyForService'],
      penaltyForServiceTotal: json['penaltyForServiceTotal'],
      penaltyRecalculationValue: json['penaltyRecalculationValue'],
      rateFee: json['rateFee'],
      rateCoeficient: json['rateCoeficient'],
      rateFormula: json['rateFormula'],
      apartmentResidentCount: json['apartmentResidentCount'],
      invoiceId: json['invoiceId'],
      serviceId: json['serviceId'],
      leaseholdId: json['leaseholdId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'invoiceUID': invoiceUID,
      'serviceTitle': serviceTitle,
      'priceForService': priceForService,
      'priceTaxTotal': priceTaxTotal,
      'priceForServiceTotal': priceForServiceTotal,
      'priceRecalculationValue': priceRecalculationValue,
      'payedForService': payedForService,
      'paymentForService': paymentForService,
      'debtForService': debtForService,
      'debtRecalculationValue': debtRecalculationValue,
      'penaltyForService': penaltyForService,
      'penaltyForServiceTotal': penaltyForServiceTotal,
      'penaltyRecalculationValue': penaltyRecalculationValue,
      'rateFee': rateFee,
      'rateCoeficient': rateCoeficient,
      'rateFormula': rateFormula,
      'apartmentResidentCount': apartmentResidentCount,
      'invoiceId': invoiceId,
      'serviceId': serviceId,
      'leaseholdId': leaseholdId,
    };
  }
}
