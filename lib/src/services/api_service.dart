import 'dart:developer';
import 'dart:io';

import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/models/UserVM.dart';
import 'package:hmguru/src/models/UserProfile%20.dart';
import 'package:hmguru/src/services/auth_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final _authService = AuthService(); // Initialize your AuthService
final _preferenceservice = PreferenceService();
// ValidateIssuer = false, IN .NET IDENTITYSTARTAP!!!!!!!!!!!!

class ApiService {
  Future<MyLeaseholdVM?> getLeasehold() async {
    final String? jwtToken = await _authService.loadJwtToken();
    void printWrapped(String text) {
      final pattern = RegExp('.{1,1500}'); // 800 is the size of each chunk
      pattern.allMatches(text).forEach((match) => print(match.group(0)));
    }

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
      printWrapped(response.body);

      final jsonBody = jsonDecode(response.body);
      final myLeaseholdVM = MyLeaseholdVM.fromJson(jsonBody);

      _preferenceservice.saveLeaseholdData(myLeaseholdVM);
    }
  }
}
