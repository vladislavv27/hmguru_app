import 'package:hmguru/src/models/payments_vm.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class PaymentDetailController {
  final PreferenceService _prefService = PreferenceService();
  final ApiService _apiService = ApiService();

  Future<PaymentDetailVM?> loadPaymentDetail(String id) async {
    try {
      if (await _prefService.IfdataExists('paymentDetail_$id')) {
        return await _prefService.loadPaymentDetails();
      } else {
        await _apiService.getPaymentDetails(id);
        return await _prefService.loadPaymentDetails();
      }
    } catch (e) {
      print(e);
      return null; // You can handle the error as needed.
    }
  }
}
