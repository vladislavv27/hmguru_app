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

  factory MeterReadingDTO.fromJson(Map<String, dynamic> json) {
    return MeterReadingDTO(
      consumption: json['consumption'],
      curValue: json['curValue'],
      meterId: json['meterId'],
    );
  }
}
