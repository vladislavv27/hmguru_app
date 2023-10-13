import 'dart:convert';

import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/models/UserProfile%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  Future<void> saveJwtToken(String jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', jwtToken);
  }

  Future<String?> loadJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
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
    await prefs.clear();
    print('All data in preferences has been cleared.');
  }
}
