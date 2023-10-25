import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hmguru/src/models/ApartmentMeterVM.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/meter_reading.dart';
import 'package:hmguru/src/models/meters_vm.dart';
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
  final apiURL = dotenv.env['API_URL'];

  Future<MyLeaseholdVM?> getLeasehold() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(
      Uri.parse(apiURL! + '/my/leasehold'),
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
      Uri.parse(apiURL! + '/my/invoice-info'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final myInvoiceInfo = InvoiceInfo.fromJson(jsonBody);
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
      Uri.parse(apiURL! + '/invoice/$invoiceId/details'),
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
      Uri.parse(apiURL! + '/my/invoices'),
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

  Future<bool> downloadFile(String invoiceId) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    try {
      final response = await http.get(
        Uri.parse(apiURL! + '/invoice/$invoiceId/export'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final contentDisposition = response.headers['content-disposition'];
        final fileName = extractFileName(contentDisposition) ?? 'invoice.docx';

        final directory = "/storage/emulated/0/Download";
        final filePath = '$directory/$fileName';

        File file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        print('File saved at: $filePath');
        return true;
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      print('Error: $e');
      return false;
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
      Uri.parse(apiURL! +
          '/period/current${leaseholdId != null ? '?leaseholdId=' + leaseholdId : ''}'),
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
      Uri.parse(apiURL! + '/my/readings'),
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

  Future<void> saveMeterReading(MeterReadingDTO readingDTO) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final jsonBody = jsonEncode(readingDTO.toJson());
    try {
      final response = await http.post(
        Uri.parse(apiURL! + '/meterreadings'),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Successful response, handle the result if needed
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Meter reading created successfully: $responseData');
      } else {
        print(
            'Failed to create meter reading. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getMyMeters(MetersQuery tableQuery) async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    final response = await http.post(
      Uri.parse(apiURL! + '/my/meters'),
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
      Uri.parse(apiURL! + '/my/meters/periods'),
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
}
