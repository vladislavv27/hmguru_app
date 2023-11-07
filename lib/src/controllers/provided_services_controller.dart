import 'package:hmguru/src/models/provided_service_vm.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class ProvidedServiceController {
  final PreferenceService _preferenceService = PreferenceService();
  final ApiService _apiService = ApiService();
  final String userId;

  ProvidedServiceController({required this.userId});

  Future<List<ProvidedServiceSimpleVM>> loadProvidedServices() async {
    try {
      if (await _preferenceService.IfdataExists(
          'providedServiceSimpleVMList')) {
        return await _preferenceService.loadProvidedService();
      } else {
        await _apiService.getProvidedServices(
            userId); // Fetch provided service data from your API using userId
        return await _preferenceService.loadProvidedService();
      }
    } catch (e) {
      print(e);
      return <ProvidedServiceSimpleVM>[]; // You can return an empty list or handle the error as needed.
    }
  }
}
