import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/pages/invoice_details.dart';
import 'package:hmguru/src/pages/menu/bottom_navigation.dart';
import 'package:hmguru/src/pages/menu/side_menu.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _prefservice = PreferenceService();
  final _apiservice = ApiService();
  MyLeaseholdVM? leaseholdData;
  InvoiceInfo? invoiceInfoData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaseholdData();
    _loadInvoiceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My apartment'),
      ),
      drawer: SideMenu(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        OrientationBuilder(
                          builder: (context, orientation) {
                            if (orientation == Orientation.portrait) {
                              return SvgPicture.asset(
                                'assets/apartment.svg',
                                height: 140,
                                width: 140,
                              );
                            } else {
                              return SizedBox(); // Hide the SVG in landscape orientation
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          leaseholdData != null
                              ? '${leaseholdData!.address}\nApartment number:${leaseholdData!.fullNumber}'
                              : 'Sorry, data not found',
                          style: TextStyle(
                            color: leaseholdData != null
                                ? Color(0xFF464646)
                                : AppColors.accentColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          invoiceInfoData != null
                              ? 'Last invoice: ${_getPreviousMonthDate()}'
                              : 'No invoice data available',
                          style: TextStyle(
                            color: Color(0xFF464646),
                            fontSize: 20,
                          ),
                        ),
                        // The Text widget for invoice information goes here
                        Text(
                          invoiceInfoData != null
                              ? 'Invoice: ${invoiceInfoData!.invoiceUID}'
                              : 'No invoice data available',
                          style: TextStyle(
                            color: leaseholdData != null
                                ? Color(0xFF464646)
                                : AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          invoiceInfoData != null
                              ? '${invoiceInfoData!.sumTotal}€'
                              : 'No invoice data available',
                          style: TextStyle(
                            color: leaseholdData != null
                                ? AppColors.primaryColor
                                : AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (invoiceInfoData != null && !invoiceInfoData!.isPaid)
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Icon(
                                Icons.local_fire_department,
                                color: Color(0xFF464646),
                                size: 48,
                              ),
                              Text(
                                'You are a debtor',
                                style: TextStyle(
                                  color: Color(0xFF464646),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            _openAdditionalInformationPage();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors
                                .primaryColor, // Set the background color
                          ),
                          child: Text('Read more'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: MyBottomNavigationMenu(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<void> _openAdditionalInformationPage() async {
    // Ensure invoiceInfoData is not null
    if (invoiceInfoData != null) {
      try {
        // Fetch data using _apiservice.getInvoiceDataFormId
        await _apiservice.getInvoiceDataFormId(invoiceInfoData!.invoiceId);
        final additionalData = await _prefservice.loadInvoiceDetails();

        // Convert the additionalData to the required format

        // Navigate to the new page and pass the data
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InvoiceDetailPage(data: additionalData),
        ));
      } catch (e) {
        print(e);
      }
    }
  }

  String _getPreviousMonthDate() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    final formattedDate = DateFormat.MMMM().format(lastMonth);
    return formattedDate;
  }

  Future<void> _loadLeaseholdData() async {
    try {
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      if (myLeaseholdVM != null) {
        setState(() {
          leaseholdData = myLeaseholdVM;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadInvoiceData() async {
    try {
      final myinvoiceInfo = await _prefservice.loadInvoiceInfo();
      if (myinvoiceInfo != null) {
        setState(() {
          invoiceInfoData = myinvoiceInfo;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
