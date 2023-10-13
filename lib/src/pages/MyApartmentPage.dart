import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/models/MyLeaseholdVM.dart';
import 'package:hmguru/src/pages/login.dart';
import 'package:hmguru/src/pages/menu.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class MyApartmentPage extends StatefulWidget {
  @override
  _MyApartmentPageState createState() => _MyApartmentPageState();
}

class _MyApartmentPageState extends State<MyApartmentPage> {
  int _currentIndex = 0;
  final _prefservice = PreferenceService();
  final _apiservice = ApiService();
  MyLeaseholdVM? leaseholdData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaseholdData();
  }

  Future<void> _loadLeaseholdData() async {
    try {
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      if (myLeaseholdVM != null) {
        setState(() {
          leaseholdData = myLeaseholdVM;
          isLoading = false; // Data loaded, set isLoading to false
        });
      } else {
        setState(() {
          isLoading = false; // Data not found, set isLoading to false
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Error occurred, set isLoading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).primaryColor, // Set app bar background color
        title: Text('My apartment'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/apartment.svg',
                            height: 140,
                            width: 140,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              leaseholdData != null
                                  ? '${leaseholdData!.address}\nApartment number:${leaseholdData!.fullNumber}\n'
                                      '${leaseholdData!.owners.isNotEmpty ? leaseholdData!.owners.join(", ") : ""}\n'
                                  : 'Sorry, data not found',
                              style: TextStyle(
                                color: leaseholdData != null
                                    ? Color(0xFF464646)
                                    : Color.fromARGB(255, 254, 112, 96),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              leaseholdData != null
                                  ? 'Floor: ${leaseholdData!.floor}\n'
                                      'Resident count: ${leaseholdData!.residentCount}\n'
                                      'Area: ${leaseholdData!.fullArea.toStringAsFixed(2)}\n'
                                      'Balcony area: ${leaseholdData!.balconyArea.toStringAsFixed(2)}\n'
                                      'Bill delivery type: ${leaseholdData!.billDeliveryType.name}\n'
                                      'Access code: ${leaseholdData!.accessCode}'
                                  : ':(',
                              style: TextStyle(
                                color: leaseholdData != null
                                    ? Color(0xFF464646)
                                    : Color.fromARGB(255, 254, 112, 96),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _handleLogout(context);
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
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
