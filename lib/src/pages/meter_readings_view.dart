import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/controllers/meter_charts_controller.dart';
import 'package:hmguru/src/controllers/meter_readings_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/pages/add_meter_view.dart';
import 'package:hmguru/src/pages/menu/bottom_navigation.dart';
import 'package:hmguru/src/pages/menu/side_menu.dart';
import 'package:hmguru/src/pages/meters_charts_view.dart';
import 'package:intl/intl.dart';

class MeterReadingPage extends StatefulWidget {
  @override
  _MeterReadingPageState createState() => _MeterReadingPageState();
}

class _MeterReadingPageState extends State<MeterReadingPage> {
  final MeterReadingController meterController = MeterReadingController();
  int _currentIndex = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await meterController.initializeData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Meter readings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildContent(),
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

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/meter-reading.svg',
                width: 120,
                height: 120,
              ),
            ),
            Visibility(
              visible: !meterController.allMeterReadingsSet,
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
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'The meter readings can be submitted from ${meterController.currentPeriod != null ? DateFormat.MMMM().format(meterController.currentPeriod!) : ''}  ${meterController.invoiceInfoData?.meterReadingActivationDay} to ${meterController.lastDayDate != null ? DateFormat.MMMM().format(meterController.lastDayDate!) : ''} ${meterController.invoiceInfoData?.meterReadingDueDay}.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMeterView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
              ),
              child: Text('Submit Meter Readings'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final meterChartsController = MeterChartsController();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeterChartsPage(
                      controller: meterChartsController,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
              ),
              child: Text('Meters'),
            ),
          ],
        ),
      ),
    );
  }
}
