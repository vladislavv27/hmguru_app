import 'package:hmguru/src/models/payments_vm.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class PaymentListController {
  final _prefService = PreferenceService();
  final _apiService = ApiService();

  Future<List<PaymentListVM>?> loadPaymentList() async {
    try {
      if (await _prefService.IfdataExists('paymentList')) {
        return await _prefService.loadPaymentList();
      } else {
        await _apiService
            .getLeaseholdPayments(); // Fetch payment data from your API
        return await _prefService.loadPaymentList();
      }
    } catch (e) {
      print(e);
      return []; // You can return an empty list or handle the error as needed.
    }
  }
}
