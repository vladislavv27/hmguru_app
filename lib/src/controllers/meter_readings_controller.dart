import 'package:hmguru/src/models/apartment_meter_vm.dart';
import 'package:hmguru/src/models/Invoice_Info_vm.dart';
import 'package:hmguru/src/models/my_leasehold_vm.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class MeterReadingController {
  final ApiService _apiService = ApiService();
  final PreferenceService _prefService = PreferenceService();

  MyLeaseholdVM? leaseholdData;
  InvoiceInfoVm? invoiceInfoData;
  List<ApartmentMeterVM>? apartmentMeterVM;
  bool isLoading = true;
  DateTime? currentPeriod;
  DateTime? lastDayDate;
  bool allMeterReadingsSet = false;
  bool isTodayValidDateForMetersReading = false;

  Future<void> initializeData() async {
    try {
      await _apiService.getMyMeterReadings();
      final myLeaseholdVM = await _prefService.loadLeaseholdData();
      final myInvoiceInfo = await _prefService.loadInvoiceInfo();
      final myMeterReadings = await _prefService.loadApartmentMeterData();

      if (myLeaseholdVM != null && myInvoiceInfo != null) {
        leaseholdData = myLeaseholdVM;
        invoiceInfoData = myInvoiceInfo;
        isLoading = false;

        if (myMeterReadings != null) {
          apartmentMeterVM = myMeterReadings;
        }

        final period = await _apiService.getCurrentPeriod(leaseholdData!.id);
        currentPeriod = period;

        final isSameMonth = invoiceInfoData!.meterReadingDueDay >
            invoiceInfoData!.meterReadingActivationDay;
        lastDayDate = DateTime(
          currentPeriod!.year,
          isSameMonth ? currentPeriod!.month : currentPeriod!.month + 1,
          invoiceInfoData!.meterReadingDueDay,
        );

        isTodayValidDateForMetersReading =
            checkTodayValidDateForMetersReading();
        allMeterReadingsSet =
            apartmentMeterVM!.every((reading) => reading.consumption >= 0);
      }
    } catch (e) {
      isLoading = false;
    }
  }

  bool checkTodayValidDateForMetersReading() {
    final today = DateTime.now();
    final currentMonth = currentPeriod!.month;
    final meterReadingActivationDate = DateTime(
      currentPeriod!.year,
      currentMonth,
      invoiceInfoData!.meterReadingActivationDay,
    );

    final isSameMonth = invoiceInfoData!.meterReadingDueDay >
        invoiceInfoData!.meterReadingActivationDay;
    final month = isSameMonth ? currentMonth : currentMonth + 1;
    final lastDayDate = DateTime(
      currentPeriod!.year,
      month,
      invoiceInfoData!.meterReadingDueDay,
      23,
      59,
      59,
    );

    return today.isAfter(meterReadingActivationDate) &&
        today.isBefore(lastDayDate);
  }
}
