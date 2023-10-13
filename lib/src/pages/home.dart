import 'package:flutter/material.dart';
import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/pages/login.dart';
import 'package:hmguru/src/pages/menu.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/auth_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // To keep track of the current menu item index
  final _authService = AuthService();
  final _prefservice = PreferenceService();
  final _apiservice = ApiService();
  MyLeaseholdVM? leaseholdData;

  @override
  void initState() {
    super.initState();
    _loadLeaseholdData();
  }

  Future<void> _loadLeaseholdData() async {
    final myLeaseholdVM = await _prefservice.loadLeaseholdData();
    if (myLeaseholdVM != null) {
      setState(() {
        leaseholdData = myLeaseholdVM;
        print("Home Page");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leaseholdData != null)
              Text('Address: ${leaseholdData!.address}'),
            if (leaseholdData != null)
              Text('Full Address: ${leaseholdData!.fullAddress}'),
            if (leaseholdData != null) Text('Floor: ${leaseholdData!.floor}'),
            if (leaseholdData != null)
              Text('Resident Count: ${leaseholdData!.residentCount}'),
            // Add more fields here as needed
            ElevatedButton(
              onPressed: () {
                _handleLogout(context);
              },
              child: Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () {
                _loadLeaseholdData();
                print(leaseholdData);
              },
              child: Text('Reload Data'),
            ),
          ],
        ),
      ),
      // Add the bottom navigation menu
      bottomNavigationBar: MyBottomNavigationMenu(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle menu item tap
          setState(() {
            _currentIndex = index;
          });
          // You can implement navigation logic based on the index here.
        },
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    // Clear all preferences or do any necessary cleanup
    await _prefservice.clearAllPreferences();

    // Use Navigator to navigate to the LoginView page and remove the current page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginView(),
      ),
      (Route<dynamic> route) => false, // Clear the navigation stack
    );
  }
}
