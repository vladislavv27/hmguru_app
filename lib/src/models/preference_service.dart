import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const _jwtTokenKey =
      'jwtToken'; // Key for storing JWT token in preferences
  static const _otherPreferenceKey =
      'otherPreference'; // Add other keys as needed

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Getter for the JWT token
  Future<String?> get jwtToken async {
    final prefs = await _prefs;
    return prefs.getString(_jwtTokenKey);
  }

  // Setter for the JWT token
  Future<void> setJwtToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_jwtTokenKey, token);
  }

  // Remove the JWT token from preferences
  Future<void> removeJwtToken() async {
    final prefs = await _prefs;
    await prefs.remove(_jwtTokenKey);
  }

  // Other preference methods as needed
  // Future<String?> getOtherPreference() async {
  //   final prefs = await _prefs;
  //   return prefs.getString(_otherPreferenceKey);
  // }

  // Future<void> setOtherPreference(String value) async {
  //   final prefs = await _prefs;
  //   await prefs.setString(_otherPreferenceKey, value);
  // }
}

// Usage:
// To get and set the JWT token:
// final preferenceService = PreferenceService();
// final token = await preferenceService.jwtToken;
// await preferenceService.setJwtToken('your_jwt_token_here');
