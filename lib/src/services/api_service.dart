import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _preferenceservice = PreferenceService();
// ValidateIssuer = false, IN .NET IDENTITYSTARTAP!!!!!!!!!!!!

class ApiService {
  Future<MyLeaseholdVM?> getLeasehold() async {
    final String? jwtToken = await _preferenceservice.loadJwtToken();
    void printWrapped(String text) {}

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
