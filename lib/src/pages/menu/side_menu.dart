import 'package:flutter/material.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/pages/login_view.dart';
import 'package:hmguru/src/services/preference_service.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final _prefservice = PreferenceService();
  MyLeaseholdVM? leaseholdData;
  String userName = '';
  String userMail = '';

  @override
  void initState() {
    super.initState();
    _loadLeaseholdData();
    _prefservice.loadUserProfile().then((userProfile) {
      setState(() {
        userName = userProfile.fullName;
        userMail = userProfile.name;
      });
    });
  }

  Future<void> _loadLeaseholdData() async {
    try {
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      if (myLeaseholdVM != null) {
        setState(() {
          leaseholdData = myLeaseholdVM;
        });
      }
    } catch (e) {
      print(e);
    }
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
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            accountEmail: Text(userMail),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.apartment),
            title: const Text(
              'My apartment',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              if (leaseholdData != null) {
                _openMyApartmentPageAsDialog(context, leaseholdData!);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text(
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
    await _prefservice.clearAllPreferences();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginView(),
      ),
      (Route<dynamic> route) => false, // Clear the navigation stack
    );
  }

  void _openMyApartmentPageAsDialog(
      BuildContext context, MyLeaseholdVM leaseholdData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apartment information'),
          content: Text(
            '${leaseholdData.address}\nApartment number:${leaseholdData.fullNumber}\n'
            'Owner: ${leaseholdData.owners.isNotEmpty ? leaseholdData.owners.join(", ") : ""}\n'
            'Floor: ${leaseholdData.floor}\n'
            'Resident count: ${leaseholdData.residentCount}\n'
            'Area: ${leaseholdData.fullArea.toStringAsFixed(2)}\n'
            'Balcony area: ${leaseholdData.balconyArea.toStringAsFixed(2)}\n'
            'Bill delivery type: ${leaseholdData.billDeliveryType.name}\n'
            'Access code: ${leaseholdData.accessCode}',
            style: TextStyle(
              color: Color(0xFF464646),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
