import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/models/ApartmentMeterVM.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/pages/add_meter_view.dart';
import 'package:hmguru/src/pages/menu/bottom_navigation.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:intl/intl.dart';

class MeterReadingPage extends StatefulWidget {
  @override
  _MeterReadingPageState createState() => _MeterReadingPageState();
}

class _MeterReadingPageState extends State<MeterReadingPage> {
  int _currentIndex = 1;
  MyLeaseholdVM? leaseholdData;
  InvoiceInfo? invoiceInfoData;
  List<ApartmentMeterVM>? apartmentMeterVM;
  final _apiservice = ApiService();
  final _prefservice = PreferenceService();
  bool isLoading = true;
  DateTime? currentPeriod;
  DateTime? lastDayDate;
  bool allMeterReadingsSet = false;
  bool isTodayValidDateForMetersReading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Load leasehold data from preferences
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      final myinvoiceInfo = await _prefservice.loadInvoiceInfo();
      final myMeterReadings = await _prefservice.loadApartmentMeterData();

      if (myLeaseholdVM != null && myinvoiceInfo != null) {
        setState(() {
          leaseholdData = myLeaseholdVM;
          invoiceInfoData = myinvoiceInfo;
          isLoading = false;
        });

        if (myMeterReadings != null) {
          setState(() {
            apartmentMeterVM = myMeterReadings;
          });
        }
        print(apartmentMeterVM![0]);
        // Retrieve the period here
        final period = await _apiservice.getCurrentPeriod(leaseholdData!.id);
        if (period != null) {
          setState(() {
            currentPeriod = period;
          });

          bool isSameMonth = invoiceInfoData!.meterReadingDueDay >
              invoiceInfoData!.meterReadingActivationDay;
          lastDayDate = DateTime(
            currentPeriod!.year,
            isSameMonth ? currentPeriod!.month : currentPeriod!.month + 1,
            invoiceInfoData!.meterReadingDueDay,
          );
        }
        isTodayValidDateForMetersReading =
            checkTodayValidDateForMetersReading();
        // Check if all meter readings meet the condition
        allMeterReadingsSet = apartmentMeterVM!.every((reading) =>
            reading.consumption != null && reading.consumption >= 0);
        print('Are all meter readings set? $allMeterReadingsSet');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool checkTodayValidDateForMetersReading() {
    final today = DateTime.now();
    final currentMonth = currentPeriod!.month;
    final meterReadingActivationDate = DateTime(
      currentPeriod!.year,
      currentMonth,
      invoiceInfoData!.meterReadingActivationDay,
    );

    final isSameMonth = invoiceInfoData!.meterReadingDueDay >
        invoiceInfoData!.meterReadingActivationDay;
    final month = isSameMonth ? currentMonth : currentMonth + 1;
    final lastDayDate = DateTime(
      currentPeriod!.year,
      month,
      invoiceInfoData!.meterReadingDueDay,
      23,
      59,
      59,
    );

    return today.isAfter(meterReadingActivationDate) &&
        today.isBefore(lastDayDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter readings'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [
                  SizedBox(height: 30), // Add space between image and text

                  Align(
                    alignment: Alignment.topCenter, // Align to the top
                    child: SvgPicture.asset(
                      'assets/meter-reading.svg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Visibility(
                    visible: !allMeterReadingsSet,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info, color: AppColors.accentColor),
                            Text(
                              'You have no meter readings',
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontSize: 18, // Increase text size
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(
                        10.0), // Add 10 pixels of padding to all sides
                    child: Text(
                      'The meter readings can be submitted from ${currentPeriod != null ? DateFormat.MMMM().format(currentPeriod!) : ''}  ${invoiceInfoData?.meterReadingActivationDay} to ${invoiceInfoData?.meterReadingDueDay} ${lastDayDate != null ? DateFormat.MMMM().format(lastDayDate!) : ''}.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (!invoiceInfoData!.allowAddNewMeterReadings ||
                            !isTodayValidDateForMetersReading)
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMeterView(),
                              ),
                            );
                          },
                    child: Text('Submit Meter Readings'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Meters'),
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
}
