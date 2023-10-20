import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hmguru/src/models/ApartmentMeterVM.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/models/user_profile.dart';
import 'package:hmguru/src/models/invoice_details.dart';
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
    await secureStorage.deleteAll();
    await prefs.clear();
  }

  Future<void> saveInvoiceInfo(InvoiceInfo invoiceInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceInfoJson = jsonEncode(invoiceInfo);
    await prefs.setString('invoiceInfo', invoiceInfoJson);
  }

  Future<InvoiceInfo?> loadInvoiceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceInfoJson = prefs.getString('invoiceInfo');
    if (invoiceInfoJson != null) {
      return InvoiceInfo.fromJson(jsonDecode(invoiceInfoJson));
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

  Future<void> saveInvoiceList(List<InvoiceList> invoiceList) async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceListJson = jsonEncode(invoiceList);
    await prefs.setString('invoiceList', invoiceListJson);
  }

  Future<List<InvoiceList>> loadInvoiceList() async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceListJson = prefs.getString('invoiceList');
    if (invoiceListJson != null) {
      final List<dynamic> decodedList = jsonDecode(invoiceListJson);
      List<InvoiceList> invoiceList = decodedList
          .map((json) => InvoiceList.fromJson(json as Map<String, dynamic>))
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
}
