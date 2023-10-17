import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/models/invoice_details.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/models/table_queru.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _preferenceservice = PreferenceService();
// ValidateIssuer = false, IN .NET IDENTITYSTARTAP!!!!!!!!!!!!

class ApiService {
  Future<MyLeaseholdVM?> getLeasehold() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:13016/api/my/leasehold'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(response.body);
      final jsonBody = jsonDecode(response.body);
      final myLeaseholdVM = MyLeaseholdVM.fromJson(jsonBody);
      if (myLeaseholdVM == null) await _preferenceservice.clearAllPreferences();
      _preferenceservice.saveLeaseholdData(myLeaseholdVM);
    }
  }

  Future<MyLeaseholdVM?> getInvoiceDataForHomepage() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:13016/api/my/invoice-info'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final myInvoiceInfo = InvoiceInfo.fromJson(jsonBody);
      _preferenceservice.saveInvoiceInfo(myInvoiceInfo);
    }
  }

  Future<void> getInvoiceDataFormId(String invoiceId) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:13016/api/invoice/$invoiceId/details'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<InvoiceDetailVM> invoiceDetails =
          jsonList.map((json) => InvoiceDetailVM.fromJson(json)).toList();
      _preferenceservice.saveInvoiceDetails(invoiceDetails);
    }
  }

  Future<void> getInvoiceList() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final tableQuery = TableQueryModel();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:13016/api/my/invoices'),
      headers: headers,
      body: jsonEncode(tableQuery.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['list'];
      final List<InvoiceList> invoiceList =
          jsonList.map((json) => InvoiceList.fromJson(json)).toList();
      _preferenceservice.saveInvoiceList(invoiceList);
    }
  }
}
