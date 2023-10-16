import 'package:flutter/material.dart';
import 'package:hmguru/src/pages/login.dart';
import 'package:hmguru/src/services/preference_service.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final _prefservice = PreferenceService();
  String userName = ''; // Initialize a variable to store the user's name
  String userMail = '';
  @override
  void initState() {
    super.initState();
    // Load user profile data when the widget is initialized
    _prefservice.loadUserProfile().then((userProfile) {
      setState(() {
        userName = userProfile.fullName;
        userMail = userProfile.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            accountEmail: Text(userMail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              _handleLogout(context);
            },
          ),
        ],
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
