class InvoiceListVM {
  final String serviceTitle;
  final String priceForService;
  final String priceTaxTotal;
  final String debtForService;
  final String priceForServiceTotal;
  final String payedForService;
  final String penaltyForService;
  final String penaltyForServiceTotal;
  final String debtRecalculationValue;
  final String rateFormula;

  InvoiceListVM({
    required this.serviceTitle,
    required this.priceForService,
    required this.priceTaxTotal,
    required this.debtForService,
    required this.priceForServiceTotal,
    required this.payedForService,
    required this.penaltyForService,
    required this.penaltyForServiceTotal,
    required this.debtRecalculationValue,
    required this.rateFormula,
  });

  factory InvoiceListVM.fromJson(Map<String, dynamic> json) {
    return InvoiceListVM(
      serviceTitle: json['serviceTitle'] ?? '',
      priceForService: json['priceForService'] ?? '',
      priceTaxTotal: json['priceTaxTotal'] ?? '',
      debtForService: json['debtForService'] ?? '',
      priceForServiceTotal: json['priceForServiceTotal'] ?? '',
      payedForService: json['payedForService'] ?? '',
      penaltyForService: json['penaltyForService'] ?? '',
      penaltyForServiceTotal: json['penaltyForServiceTotal'] ?? '',
      debtRecalculationValue: json['debtRecalculationValue'] ?? '',
      rateFormula: json['rateFormula'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceTitle': serviceTitle,
      'priceForService': priceForService,
      'priceTaxTotal': priceTaxTotal,
      'debtForService': debtForService,
      'priceForServiceTotal': priceForServiceTotal,
      'payedForService': payedForService,
      'penaltyForService': penaltyForService,
      'penaltyForServiceTotal': penaltyForServiceTotal,
      'debtRecalculationValue': debtRecalculationValue,
      'rateFormula': rateFormula,
    };
  }
}
