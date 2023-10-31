import 'package:hmguru/src/models/residents_vm.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class ResidentsViewController {
  final _prefService = PreferenceService();
  final _apiService = ApiService();

  Future<List<ResidentTableVM>?> loadResidentList() async {
    if (await _prefService.IfdataExists('residentTable')) {
      final residents = await _prefService.loadResidentTableVM();
      return residents;
    } else {
      await _apiService.getLeaseholdResidents();
      final residents = await _prefService.loadResidentTableVM();
      return residents;
    }
  }
}
