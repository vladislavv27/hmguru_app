class MetersVM {
  String? title;
  String? meterUID;
  DateTime? expiresOn;
  DateTime? installedOn;
  List<ServiceVM>? services;
  MeterReadingGraphicData? chartData;
  String? apartmentFullAddress;
  String? serviceTitle;

  MetersVM({
    required this.title,
    required this.meterUID,
    required this.expiresOn,
    required this.installedOn,
    required this.services,
    required this.chartData,
    required this.apartmentFullAddress,
    required this.serviceTitle,
  });

  factory MetersVM.fromJson(Map<String, dynamic> json) {
    return MetersVM(
      title: json['title'] ?? '', // Use an empty string as a default value
      meterUID: json['meterUID'] ?? '',
      expiresOn: json['expiresOn'] != null
          ? DateTime.parse(json['expiresOn'])
          : DateTime.now(),
      installedOn: json['installedOn'] != null
          ? DateTime.parse(json['installedOn'])
          : DateTime.now(),
      services: (json['services'] as List<dynamic>?)
              ?.map((service) => ServiceVM.fromJson(service))
              .toList() ??
          [], // Use an empty list as a default value
      chartData: json['chartData'] != null
          ? MeterReadingGraphicData.fromJson(json['chartData'])
          : MeterReadingGraphicData(labels: [], values: []),
      apartmentFullAddress: json['apartmentFullAddress'] ?? '',
      serviceTitle: json['serviceTitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'meterUID': meterUID,
      'expiresOn': expiresOn?.toIso8601String(),
      'installedOn': installedOn?.toIso8601String(),
      'services': services?.map((service) => service.toJson()).toList(),
      'chartData': chartData?.toJson(),
      'apartmentFullAddress': apartmentFullAddress,
      'serviceTitle': serviceTitle,
    };
  }
}

class ServiceVM {
  String title;

  ServiceVM({required this.title});

  factory ServiceVM.fromJson(Map<String, dynamic> json) {
    return ServiceVM(title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}

class MeterReadingGraphicData {
  List<String> labels;
  List<double> values;

  MeterReadingGraphicData({required this.labels, required this.values});

  factory MeterReadingGraphicData.fromJson(Map<String, dynamic> json) {
    return MeterReadingGraphicData(
      labels: List<String>.from(json['labels']),
      values: List<double>.from(json['values']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'values': values,
    };
  }
}
