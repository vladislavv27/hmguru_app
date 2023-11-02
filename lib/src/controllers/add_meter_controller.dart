import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/models/apartment_meter_vm.dart';
import 'package:hmguru/src/models/app_colors.dart';
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

      currentPeriod = period;

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

  void sendDataToFunction(BuildContext context, double newConsumptionValue,
      ApartmentMeterVM meter) async {
    if (newConsumptionValue > 0) {
      final readingDTO = MeterReadingVM(
        consumption: newConsumptionValue,
        curValue: 0,
        meterId: meter.meterId,
      );

      bool saveSuccess = await _apiservice.saveMeterReading(readingDTO);

      final snackBar = SnackBar(
        content: Text(
          saveSuccess
              ? AppLocalizations.of(context)!.meterReadingSavedSuccessfully
              : AppLocalizations.of(context)!.failedToSaveMeterReading,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor:
            saveSuccess ? AppColors.successColor : AppColors.accentColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      if (saveSuccess) {
        meter.consumption = newConsumptionValue;
        meter.curValue = meter.prevValue + newConsumptionValue;
        _prefservice.saveApartmentMeterData(apartmentMeterVM!);
      }
    }
  }
}
