import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hmguru/src/models/user_profile.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/pages/home_view.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _apiservice = ApiService();
  final _preferenceservice = PreferenceService();
  final apiURLAuth = dotenv.env['API_URL_AUTH'];

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // Save the form fields
                    _submitForm(context); // Pass the context to _submitForm
                  }
                },
                child: Text('Login'),
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(), // Show a loading indicator when loading
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    } else {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiURLAuth!),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'password',
          'client_id': 'client',
          'scope': 'api1 offline_access',
          'username': _email,
          'password': _password,
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          await _preferenceservice.clearAllPreferences();

          final responseBody = json.decode(response.body);
          final jwtToken = responseBody['access_token'];
          await _preferenceservice
              .saveJwtToken(jwtToken); // Use the instance method

          // Decode the JWT token to get profile data
          final Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

          // Extract the profile data from the decoded token
          final userProfile = UserProfile(
            userId: decodedToken['sub'],
            name: decodedToken['name'],
            role: decodedToken['role'],
            fullName:
                decodedToken['http://hms/claims/authorization/user/fullname'],
          );

          // Save the profile data in SharedPreferences
          await _preferenceservice
              .saveUserProfile(userProfile); // Use the instance method
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Success'),
              duration: Duration(seconds: 3),
            ),
          );

          if (mounted) {
            await _apiservice.getLeasehold();
            await _apiservice.getInvoiceDataForHomepage();
            await _apiservice.getInvoiceList();

            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
