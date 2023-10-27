import 'package:flutter/material.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/my_leasehold_vm.dart';
import 'package:hmguru/src/pages/login_view.dart';
import 'package:hmguru/src/pages/payment_list_view.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.apartment),
            title: Text(
              AppLocalizations.of(context)!.myApartment,
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
            leading: Icon(Icons.payment),
            title: Text(
              AppLocalizations.of(context)!.payments,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentListView(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              AppLocalizations.of(context)!.logout,
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
      (Route<dynamic> route) => false,
    );
  }

  void _openMyApartmentPageAsDialog(
      BuildContext context, MyLeaseholdVM leaseholdData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.apartmentInformation),
          content: Text(
            '${leaseholdData.address}\n${AppLocalizations.of(context)!.apartmentNumber}:${leaseholdData.fullNumber}\n'
            '${AppLocalizations.of(context)!.owner}: ${leaseholdData.owners.isNotEmpty ? leaseholdData.owners.join(", ") : ""}\n'
            '${AppLocalizations.of(context)!.floor}: ${leaseholdData.floor}\n'
            '${AppLocalizations.of(context)!.residentCount}: ${leaseholdData.residentCount}\n'
            '${AppLocalizations.of(context)!.area}: ${leaseholdData.fullArea.toStringAsFixed(2)}\n'
            '${AppLocalizations.of(context)!.balconyArea}: ${leaseholdData.balconyArea.toStringAsFixed(2)}\n'
            '${AppLocalizations.of(context)!.billDeliveryType}: ${leaseholdData.billDeliveryType.name}\n'
            '${AppLocalizations.of(context)!.accessCode}: ${leaseholdData.accessCode}',
            style: TextStyle(
              color: Color(0xFF464646),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }
}
