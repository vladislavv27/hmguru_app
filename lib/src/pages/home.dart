import 'package:flutter/material.dart';
import 'package:hmguru/src/models/auth_service.dart';
import 'package:hmguru/src/pages/login.dart';
import 'package:hmguru/src/models/UserProfile%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false; // Add a loading indicator variable
  final _authService = AuthService(); // Create an instance of AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: FutureBuilder<UserProfile>(
          future: _loadUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final userProfile = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hello ${userProfile.fullName}'),
                  ElevatedButton(
                    onPressed: () {
                      _handleLogout(context);
                    },
                    child: Text('Logout'),
                  ),
                  // Add more content for the home page
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('No user data found');
            }
          },
        ),
      ),
    );
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

  void _handleLogout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await _authService.clearUserData();

    // Check if the widget is still mounted before navigation
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginView(),
        ),
      );
    }
  }
}
