import 'package:hmguru/src/models/meters_vm.dart';
import 'package:hmguru/src/models/table_queru.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeterChartsController {
  final PreferenceService _preferenceService = PreferenceService();
  final ApiService _apiService = ApiService();
  List<MetersVM> meterDataList = [];
  List<int> meterPeriodList = [];
  bool isLoading = true;

  Function? onDataUpdated = () {};

  Future<void> initializeData() async {
    try {
      final tableQuery = MetersQuery();

      await _apiService.getMyMeterPeriods();
      await _apiService.getMyMeters(tableQuery);

      final myMeterDataList = await _preferenceService.loadMetersData();
      final myMeterPeriodList = await _preferenceService.loadMyMeterPeriods();

      if (myMeterDataList != null) {
        meterDataList = myMeterDataList;
        meterPeriodList = myMeterPeriodList;
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
    }
  }

  Future<void> updateDataForYear(int selectedYear) async {
    MetersQuery query = MetersQuery(
      year: selectedYear,
    );
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('metersData');
    await _apiService.getMyMeters(query);

    await loadUpdatedData();

    isLoading = false;

    if (onDataUpdated != null) {
      onDataUpdated!();
    }
  }

  Future<void> loadUpdatedData() async {
    try {
      final myMeterDataList = await _preferenceService.loadMetersData();
      final myMeterPeriodList = await _preferenceService.loadMyMeterPeriods();

      if (myMeterDataList != null) {
        meterDataList = myMeterDataList;
        meterPeriodList = myMeterPeriodList;
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
    }
  }
}
