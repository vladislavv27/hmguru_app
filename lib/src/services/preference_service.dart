import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hmguru/src/models/apartment_meter_vm.dart';
import 'package:hmguru/src/models/Invoice_Info_vm.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/models/meters_vm.dart';
import 'package:hmguru/src/models/my_leasehold_vm.dart';
import 'package:hmguru/src/models/payments_vm.dart';
import 'package:hmguru/src/models/user_profile.dart';
import 'package:hmguru/src/models/invoice_details_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  Future<void> saveJwtToken(String jwtToken) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'jwtToken', value: jwtToken);
  }

  Future<String?> loadJwtToken() async {
    final secureStorage = FlutterSecureStorage();
    String? jwtToken = await secureStorage.read(key: 'jwtToken');
    return jwtToken;
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userProfile.userId);
    await prefs.setString('name', userProfile.name);
    await prefs.setString('role', userProfile.role);
    await prefs.setString('fullName', userProfile.fullName);
  }

  Future<UserProfile> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final name = prefs.getString('name') ?? '';
    final role = prefs.getString('role') ?? '';
    final fullName = prefs.getString('fullName') ?? '';
    return UserProfile(
        userId: userId, name: name, role: role, fullName: fullName);
  }

  Future<void> saveLeaseholdData(MyLeaseholdVM leasehold) async {
    final prefs = await SharedPreferences.getInstance();
    final leaseholdJson = jsonEncode(leasehold);
    await prefs.setString('leaseholdData', leaseholdJson);
  }

  Future<MyLeaseholdVM?> loadLeaseholdData() async {
    final prefs = await SharedPreferences.getInstance();
    final leaseholdJson = prefs.getString('leaseholdData');
    if (leaseholdJson != null) {
      return MyLeaseholdVM.fromJson(jsonDecode(leaseholdJson));
    }
    return null;
  }

  Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'jwtToken');
    // await secureStorage.deleteAll();
    await prefs.clear();
  }

  Future<void> saveInvoiceInfo(InvoiceInfoVm invoiceInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceInfoJson = jsonEncode(invoiceInfo);
    await prefs.setString('invoiceInfo', invoiceInfoJson);
  }

  Future<InvoiceInfoVm?> loadInvoiceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceInfoJson = prefs.getString('invoiceInfo');
    if (invoiceInfoJson != null) {
      return InvoiceInfoVm.fromJson(jsonDecode(invoiceInfoJson));
    }
    return null;
  }

  Future<void> saveInvoiceDetails(List<InvoiceDetailVM> invoiceDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceDetailsJson = jsonEncode(invoiceDetails);
    await prefs.setString('invoiceDetails', invoiceDetailsJson);
  }

  Future<List<InvoiceDetailVM>> loadInvoiceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceDetailsJson = prefs.getString('invoiceDetails');
    if (invoiceDetailsJson != null) {
      final List<dynamic> decodedList = jsonDecode(invoiceDetailsJson);
      List<InvoiceDetailVM> invoiceDetails =
          decodedList.map((json) => InvoiceDetailVM.fromJson(json)).toList();
      return invoiceDetails;
    }
    return [];
  }

  Future<void> saveInvoiceList(List<InvoiceListVm> invoiceList) async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceListJson = jsonEncode(invoiceList);
    await prefs.setString('invoiceList', invoiceListJson);
  }

  Future<List<InvoiceListVm>> loadInvoiceList() async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceListJson = prefs.getString('invoiceList');
    if (invoiceListJson != null) {
      final List<dynamic> decodedList = jsonDecode(invoiceListJson);
      List<InvoiceListVm> invoiceList = decodedList
          .map((json) => InvoiceListVm.fromJson(json as Map<String, dynamic>))
          .toList();
      return invoiceList;
    }

    return [];
  }

  Future<void> saveApartmentMeterData(List<ApartmentMeterVM> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = data.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonData);
    await prefs.setString('apartmentMeterData', jsonString);
  }

  Future<List<ApartmentMeterVM>?> loadApartmentMeterData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('apartmentMeterData');
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      List<ApartmentMeterVM> data =
          jsonData.map((item) => ApartmentMeterVM.fromJson(item)).toList();
      return data;
    }
    return null;
  }

  Future<void> clearInvoiceList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('invoiceList');
  }

  Future<void> saveMetersData(List<MetersVM> metersDataList) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataToSave =
        metersDataList.map((meterData) => meterData.toJson()).toList();
    await prefs.setString('metersData', jsonEncode(dataToSave));
  }

  Future<List<MetersVM>> loadMetersData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('metersData');
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      final metersData =
          jsonData.map((item) => MetersVM.fromJson(item)).toList();
      metersData.forEach((element) {});
      return metersData;
    } else {
      return [];
    }
  }

  Future<void> saveMyMeterPeriods(List<int> years) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('years', years.map((year) => year.toString()).toList());
  }

  Future<List<int>> loadMyMeterPeriods() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? yearStrings = prefs.getStringList('years');
    if (yearStrings == null) {
      return [];
    }
    return yearStrings.map((yearString) => int.parse(yearString)).toList();
  }

  Future<bool> IfdataExists(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<void> savePaymentList(List<PaymentListVM> paymentList) async {
    final prefs = await SharedPreferences.getInstance();
    final paymentListJson =
        paymentList.map((payment) => payment.toJson()).toList();
    final paymentListString = jsonEncode(paymentListJson);
    await prefs.setString('paymentList', paymentListString);
  }

  Future<List<PaymentListVM>?> loadPaymentList() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentListString = prefs.getString('paymentList');

    if (paymentListString != null) {
      final List<dynamic> decodedList = jsonDecode(paymentListString);
      List<PaymentListVM> paymentList = decodedList
          .map((json) => PaymentListVM.fromJson(json as Map<String, dynamic>))
          .toList();
      return paymentList;
    }

    return null;
  }

  Future<void> savePaymentDetails(PaymentDetailVM paymentDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final paymentDetailsJson = jsonEncode(paymentDetails);
    await prefs.setString('paymentDetails', paymentDetailsJson);
  }

  Future<PaymentDetailVM?> loadPaymentDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentDetailJson = prefs.getString('paymentDetails');
    if (paymentDetailJson != null) {
      final Map<String, dynamic> decodedData = jsonDecode(paymentDetailJson);
      return PaymentDetailVM.fromJson(decodedData);
    }
    return null;
  }
}
