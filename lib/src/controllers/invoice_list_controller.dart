import 'package:hmguru/src/models/invoice_details_vm.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class InvoiceListController {
  final _prefservice = PreferenceService();
  final _apiservice = ApiService();

  Future<List<InvoiceListVm>> loadInvoiceList() async {
    try {
      if (await _prefservice.IfdataExists('invoiceList')) {
        return await _prefservice.loadInvoiceList();
      } else {
        await _apiservice.getInvoiceList();
        return await _prefservice.loadInvoiceList();
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<InvoiceDetailVM>?> openAdditionalInformationPage(
      String id) async {
    try {
      await _apiservice.getInvoiceDataFormId(id);
      return await _prefservice.loadInvoiceDetails();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> downloadFile(String id) async {
    return await _apiservice.downloadFile(id);
  }
}
