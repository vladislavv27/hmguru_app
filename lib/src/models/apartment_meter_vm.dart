import 'package:flutter/material.dart';

class MeterReadingValueVM {
  double prevValue;
  double curValue;
  double consumption;

  MeterReadingValueVM({
    required this.prevValue,
    required this.curValue,
    required this.consumption,
  });

  factory MeterReadingValueVM.fromJson(Map<String, dynamic> json) {
    return MeterReadingValueVM(
      prevValue: json['prevValue'].toDouble(),
      curValue: json['curValue'].toDouble(),
      consumption: json['consumption'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prevValue': prevValue,
      'curValue': curValue,
      'consumption': consumption,
    };
  }
}

class ApartmentMeterVM extends MeterReadingValueVM {
  String serviceTitle;
  String meterTitle;
  String meterUID;
  String meterId;
  bool isFilledForThisPeriod;
  bool allowAddNewMeterReadings;
  bool modifiedByMe;
  TextEditingController consumptionController = TextEditingController();
  TextEditingController currentlyController = TextEditingController();
  ApartmentMeterVM({
    required this.serviceTitle,
    required this.meterTitle,
    required this.meterUID,
    required this.meterId,
    required this.isFilledForThisPeriod,
    required this.allowAddNewMeterReadings,
    required this.modifiedByMe,
    required double prevValue,
    required double curValue,
    required double consumption,
  }) : super(
          prevValue: prevValue,
          curValue: curValue,
          consumption: consumption,
        );

  factory ApartmentMeterVM.fromJson(Map<String, dynamic> json) {
    return ApartmentMeterVM(
      serviceTitle: json['serviceTitle'] ?? '',
      meterTitle: json['meterTitle'] ?? '',
      meterUID: json['meterUID'] ?? '',
      meterId: json['meterId'] ?? '',
      isFilledForThisPeriod: json['isFilledForThisPeriod'] ?? false,
      allowAddNewMeterReadings: json['allowAddNewMeterReadings'] ?? false,
      modifiedByMe: json['modifiedByMe'] ?? false,
      prevValue: (json['prevValue'] as num?)?.toDouble() ?? 0.0,
      curValue: (json['curValue'] as num?)?.toDouble() ?? 0.0,
      consumption: (json['consumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(), // Include properties from the base class
      'serviceTitle': serviceTitle,
      'meterTitle': meterTitle,
      'meterUID': meterUID,
      'meterId': meterId,
      'isFilledForThisPeriod': isFilledForThisPeriod,
      'allowAddNewMeterReadings': allowAddNewMeterReadings,
      'modifiedByMe': modifiedByMe,
    };
  }
}
