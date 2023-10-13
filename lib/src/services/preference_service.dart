import 'dart:convert';

import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/models/UserVM.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const _jwtTokenKey = 'jwtToken';
  static const _residentDataKey = 'residentData';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String?> get jwtToken async {
    final prefs = await _prefs;
    return prefs.getString(_jwtTokenKey);
  }

  Future<void> setJwtToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_jwtTokenKey, token);
  }

  Future<void> removeJwtToken() async {
    final prefs = await _prefs;
    await prefs.remove(_jwtTokenKey);
  }

  // Future<void> saveResidentData(UserVM resident) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final residentJson = json.encode(resident.toJson());
  //   await prefs.setString('residentData', residentJson);
  // }

  // Future<UserVM?> loadResidentData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final residentJson = prefs.getString(_residentDataKey);
  //   if (residentJson != null) {
  //     final residentMap = json.decode(residentJson);
  //     return UserVM.fromJson(residentMap);
  //   } else {
  //     return null;
  //   }
  // }
  static const String _key = 'MyLeaseholdVM';

  // Save user profile data to SharedPreferences
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

  Future<void> clearLeaseholdData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('leaseholdData');
  }

  // Clear user profile data from SharedPreferences
  Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All data in preferences has been cleared.');
  }
}
