class ProvidedServiceSimpleVM {
  String title;
  double fee;
  String formula;
  double coefficient;
  double penalty;
  bool isHouseRate;
  double taxesFromFee;
  bool forbidResidentInput;

  ProvidedServiceSimpleVM({
    required this.title,
    required this.fee,
    required this.formula,
    required this.coefficient,
    required this.penalty,
    required this.isHouseRate,
    required this.taxesFromFee,
    required this.forbidResidentInput,
  });

  factory ProvidedServiceSimpleVM.fromJson(Map<String, dynamic> json) {
    return ProvidedServiceSimpleVM(
      title: json['title'] as String,
      fee: (json['fee'] as double?) ?? 0.0,
      formula: json['formula'] as String,
      coefficient: (json['coefficient'] as double?) ?? 0.0,
      penalty: (json['penalty'] as double?) ?? 0.0,
      isHouseRate: json['isHouseRate'] as bool,
      taxesFromFee: (json['taxesFromFee'] as double?) ?? 0.0,
      forbidResidentInput: json['forbidResidentInput'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fee': fee,
      'formula': formula,
      'coefficient': coefficient,
      'penalty': penalty,
      'isHouseRate': isHouseRate,
      'taxesFromFee': taxesFromFee,
      'forbidResidentInput': forbidResidentInput,
    };
  }
}
