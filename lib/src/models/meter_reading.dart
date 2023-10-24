class MeterReadingDTO {
  double consumption;
  double curValue;
  String meterId;

  MeterReadingDTO({
    required this.consumption,
    required this.curValue,
    required this.meterId,
  });

  Map<String, dynamic> toJson() {
    return {
      'consumption': consumption,
      'curValue': curValue,
      'meterId': meterId,
    };
  }
}
