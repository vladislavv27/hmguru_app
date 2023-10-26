import 'package:flutter/material.dart';
import 'package:hmguru/src/models/apartment_meter_vm.dart';
import 'package:hmguru/src/models/meter_reading_vm.dart';
import 'package:hmguru/src/models/my_leasehold_vm.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class AddMeterController {
  MyLeaseholdVM? leaseholdData;
  List<ApartmentMeterVM>? apartmentMeterVM;
  DateTime? currentPeriod;
  bool dataLoaded = false;
  final _apiservice = ApiService();
  final _prefservice = PreferenceService();

  Future<void> initializeData() async {
    try {
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      final myMeterReadings = await _prefservice.loadApartmentMeterData();

      if (myLeaseholdVM != null) {
        leaseholdData = myLeaseholdVM;
      }

      if (myMeterReadings != null) {
        apartmentMeterVM = myMeterReadings;
      }

      final period = await _apiservice.getCurrentPeriod(leaseholdData!.id);

      if (period != null) {
        currentPeriod = period;
      }

      if (apartmentMeterVM != null) {
        for (var meter in apartmentMeterVM!) {
          final consumptionValue = meter.consumption;
          final curValue = meter.curValue;
          final currentlyValue = curValue;

          meter.consumptionController =
              TextEditingController(text: consumptionValue.toStringAsFixed(2));
          meter.currentlyController =
              TextEditingController(text: currentlyValue.toStringAsFixed(2));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void sendDataToFunction(double newConsumptionValue, ApartmentMeterVM meter) {
    if (newConsumptionValue > 0) {
      final readingDTO = MeterReadingVM(
        consumption: newConsumptionValue,
        curValue: 0,
        meterId: meter.meterId,
      );
      _apiservice.saveMeterReading(readingDTO);
      Future.delayed(Duration(seconds: 3), () {
        meter.consumption = newConsumptionValue;
        meter.curValue = meter.prevValue + newConsumptionValue;
        _prefservice.saveApartmentMeterData(apartmentMeterVM!);
      });
    }
  }
}
