import 'package:hmguru/src/models/UserProfile%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> saveJwtToken(String jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', jwtToken);
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
}
