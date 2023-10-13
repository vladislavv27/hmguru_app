import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/models/UserProfile%20.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _prefservice = PreferenceService();
  final _apiservice = ApiService();
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

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('role');
    await prefs.remove('fullName');
    // Add more data you want to clear, if any
  }

  Future<UserProfile> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final name = prefs.getString('name') ?? '';
    final role = prefs.getString('role') ?? '';
    final fullName = prefs.getString('fullName') ?? '';
    return UserProfile(
        userId: userId, name: name, role: role, fullName: fullName);
  }

  // Future<MyLeaseholdVM?> loadLeaseholdData() async {
  //   final loadedLeaseholdData = await _prefservice.loadLeaseholdData();
  //   if (loadedLeaseholdData != null) {
  //   } else {
  //     final myLeaseholdVM = await _apiservice.getLeasehold();
  //     if (myLeaseholdVM != null) {
  //       await _prefservice.saveLeaseholdData(myLeaseholdVM);
  //     }
  //   }
  // }
}
