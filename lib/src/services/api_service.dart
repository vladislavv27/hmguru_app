import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hmguru/src/models/apartment_meter_vm.dart';
import 'package:hmguru/src/models/Invoice_Info_vm.dart';
import 'package:hmguru/src/models/meter_reading_vm.dart';
import 'package:hmguru/src/models/meters_vm.dart';
import 'package:hmguru/src/models/my_leasehold_vm.dart';
import 'package:hmguru/src/models/invoice_details_vm.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/models/payments_vm.dart';
import 'package:hmguru/src/models/provided_service_vm.dart';
import 'package:hmguru/src/models/residents_vm.dart';
import 'package:hmguru/src/models/table_querys_vm.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

final _preferenceservice = PreferenceService();
// ValidateIssuer = false, IN .NET IDENTITYSTARTAP!!!!!!!!!!!!

class ApiService {
  final apiURL = dotenv.env['API_URL'];

  Future<MyLeaseholdVM?> getLeasehold() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('${apiURL!}/my/leasehold'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final myLeaseholdVM = MyLeaseholdVM.fromJson(jsonBody);
      _preferenceservice.saveLeaseholdData(myLeaseholdVM);
    }
    return null;
  }

  Future<MyLeaseholdVM?> getInvoiceDataForHomepage() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('${apiURL!}/my/invoice-info'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final myInvoiceInfo = InvoiceInfoVm.fromJson(jsonBody);
      _preferenceservice.saveInvoiceInfo(myInvoiceInfo);
    }
    return null;
  }

  Future<void> getInvoiceDataFormId(String invoiceId) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('${apiURL!}/invoice/$invoiceId/details'),
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
      Uri.parse('${apiURL!}/my/invoices'),
      headers: headers,
      body: jsonEncode(tableQuery.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['list'];
      final List<InvoiceListVm> invoiceList =
          jsonList.map((json) => InvoiceListVm.fromJson(json)).toList();
      _preferenceservice.saveInvoiceList(invoiceList);
    }
  }

  Future<String?> downloadFile(String invoiceId) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    try {
      final response = await http.get(
        Uri.parse('${apiURL!}/invoice/$invoiceId/export'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final contentDisposition = response.headers['content-disposition'];
        final fileName = extractFileName(contentDisposition) ?? 'invoice.docx';

        const directory = "/storage/emulated/0/Download";
        final filePath = '$directory/$fileName';

        File file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        print('File saved at: $filePath');

        return fileName;
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      print('Error: $e');
      return null; // Return null to indicate failure
    }
  }

  String? extractFileName(String? contentDisposition) {
    if (contentDisposition == null) {
      return null;
    }

    final parts = contentDisposition.split('; ');
    for (var part in parts) {
      if (part.startsWith('filename=')) {
        final name = part.substring(10).replaceAll('"', '');
        return Uri.decodeComponent(name);
      }
    }
    return null;
  }

  Future<DateTime> getCurrentPeriod(String? id, {String? leaseholdId}) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse(
          '${apiURL!}/period/current${leaseholdId != null ? '?leaseholdId=$leaseholdId' : ''}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final String period = response.body;
      final RegExp dateRegex =
          RegExp(r'(\d{2}/\d{2}/\d{4}) (\d{2}:\d{2}:\d{2})');

      final Match? match = dateRegex.firstMatch(period);
      if (match != null) {
        final String datePart = match.group(1)!;
        final String timePart = match.group(2)!;

        final List<int> dateComponents =
            datePart.split('/').map(int.parse).toList();
        final List<int> timeComponents =
            timePart.split(':').map(int.parse).toList();

        final currentPeriod = DateTime(
            dateComponents[2],
            dateComponents[0],
            dateComponents[1],
            timeComponents[0],
            timeComponents[1],
            timeComponents[2]);
        return currentPeriod;
      } else {
        throw Exception('Invalid date format: $period');
      }
    } else {
      throw Exception('Could not get the current period');
    }
  }

  Future<void> getMyMeterReadings() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('${apiURL!}/my/readings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Iterable<dynamic> jsonList = json.decode(response.body);
      final List<ApartmentMeterVM> meterReadings =
          jsonList.map((e) => ApartmentMeterVM.fromJson(e)).toList();

      await _preferenceservice.saveApartmentMeterData(meterReadings);
    } else {
      throw Exception('Could not get meter readings');
    }
  }

  Future<bool> saveMeterReading(MeterReadingVM readingDTO) async {
    try {
      final String? jwtToken = await _preferenceservice.loadJwtToken();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final jsonBody = jsonEncode(readingDTO.toJson());

      final response = await http.post(
        Uri.parse('${apiURL!}/meterreadings'),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Meter reading created successfully: $responseData');
        return true;
      } else {
        print(
            'Failed to create meter reading. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> getMyMeters(MetersQuery tableQuery) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    final response = await http.post(
      Uri.parse('${apiURL!}/my/meters'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(tableQuery.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['list'];
      final List<MetersVM> invoiceList =
          jsonList.map((json) => MetersVM.fromJson(json)).toList();
      _preferenceservice.saveMetersData(invoiceList);
    } else {
      print('Unexpected response format: ');
    }
  }

  Future<void> getMyMeterPeriods() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('${apiURL!}/my/meters/periods'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Iterable<dynamic> jsonList = json.decode(response.body);
      final List<int> yearsList = jsonList.map((item) => item as int).toList();

      await _preferenceservice.saveMyMeterPeriods(yearsList);
    } else {
      throw Exception('Could not get meter readings');
    }
  }

  Future<void> getLeaseholdPayments() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
    final tableQuery = TableQueryModel();

    final Map<String, dynamic> requestBody = tableQuery.toJson();

    final response = await http.post(
      Uri.parse('${apiURL!}/my/payments'),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse['list'] is List) {
        final List<PaymentListVM> leaseholdPayments =
            (jsonResponse['list'] as List)
                .map((e) => PaymentListVM.fromJson(e as Map<String, dynamic>))
                .toList();

        await _preferenceservice.savePaymentList(leaseholdPayments);
      } else {
        throw Exception('Invalid response format: "list" is not a list');
      }
    } else {
      throw Exception('Could not get leasehold payments');
    }
  }

  Future<void> getPaymentDetails(String id) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse('${apiURL!}/payment/$id/details'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final PaymentDetailVM paymentDetails =
          PaymentDetailVM.fromJson(jsonResponse);
      await _preferenceservice.savePaymentDetails(paymentDetails);
    }
  }

  Future<void> getLeaseholdResidents() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final tableQuery = TableQueryModel();

    final response = await http.post(
      Uri.parse('${apiURL!}/my/residents'),
      headers: headers,
      body: jsonEncode(tableQuery.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['list'];
      final List<ResidentTableVM> residents =
          jsonList.map((json) => ResidentTableVM.fromJson(json)).toList();
      await _preferenceservice.saveResidentTableVM(residents);
    }
  }

  Future<void> updateDeliveryType(InvoiceDeliveryType deliveryType) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Uri uri = Uri.parse('$apiURL/my/receive-invoices-type-change')
        .replace(
            queryParameters: {'deliveryType': deliveryType.name.toString()});

    final Response response = await http.put(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Delivery type updated successfully');

      await getInvoiceDataForHomepage();
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> getProvidedServices(String LeaseholdId) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
    final tableQuery = RateQueryModel();
    tableQuery.LeaseholdId = LeaseholdId;
    final Map<String, dynamic> requestBody = tableQuery.toJson();

    final response = await http.post(
      Uri.parse('${apiURL!}/my/rates'),
      headers: headers,
      body: json.encode(requestBody),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      final List<ProvidedServiceSimpleVM> providedServices = [];

      final List<dynamic> jsonResponse = json.decode(response.body)['list'];

      providedServices.addAll(
          jsonResponse.map((item) => ProvidedServiceSimpleVM.fromJson(item)));

      await _preferenceservice.saveProvidedService(providedServices);
    }
  }
}
