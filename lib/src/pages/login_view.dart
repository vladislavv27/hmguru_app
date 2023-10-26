import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final apiURLAuth = dotenv.env['API_URL_AUTH'];
  final _storage = FlutterSecureStorage();
  final _preferenceService = PreferenceService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    final rememberMe = await _storage.read(key: 'rememberMe');

    if (rememberMe != null && rememberMe == 'true') {
      final storedEmail = await _storage.read(key: 'email');
      final storedPassword = await _storage.read(key: 'password');

      if (storedEmail != null && storedPassword != null) {
        setState(() {
          _emailController.text = storedEmail;
          _passwordController.text = storedPassword;
          _rememberMe = true;
        });
      }
    }
  }

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
                      controller: _emailController,
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
                      controller: _passwordController,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text('Remember Me'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text('Login'),
              ),
              _isLoading ? CircularProgressIndicator() : SizedBox(),
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
          'username': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          await _preferenceService.clearAllPreferences();

          await _storage.write(
              key: 'rememberMe', value: _rememberMe.toString());

          final responseBody = json.decode(response.body);
          final jwtToken = responseBody['access_token'];
          await _storage.write(key: 'jwtToken', value: jwtToken);

          final decodedToken = JwtDecoder.decode(jwtToken);

          final userProfile = UserProfile(
            userId: decodedToken['sub'],
            name: decodedToken['name'],
            role: decodedToken['role'],
            fullName:
                decodedToken['http://hms/claims/authorization/user/fullname'],
          );

          await _preferenceService.saveUserProfile(userProfile);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Success'),
              duration: Duration(seconds: 3),
            ),
          );

          if (mounted) {
            await _apiservice.getLeasehold();
            await _apiservice.getInvoiceDataForHomepage();

            if (_rememberMe) {
              await _storage.write(key: 'email', value: _emailController.text);
              await _storage.write(
                  key: 'password', value: _passwordController.text);
            } else {
              await _storage.delete(key: 'email');
              await _storage.delete(key: 'password');
            }

            Navigator.of(context).pushAndRemoveUntil(
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
