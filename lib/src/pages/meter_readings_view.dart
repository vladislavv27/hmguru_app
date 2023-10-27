import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/l10n/global_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.meterReadingsTitle),
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
                        AppLocalizations.of(context)!.noMeterReadings,
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
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      _buildTextSpan(
                          'The meter readings can be submitted from '),
                      _buildDateTextSpan(
                        meterController.currentPeriod,
                        meterController
                            .invoiceInfoData?.meterReadingActivationDay
                            .toString(),
                      ),
                      _buildTextSpan(' to '),
                      _buildDateTextSpan(
                        meterController.lastDayDate,
                        meterController.invoiceInfoData?.meterReadingDueDay
                            .toString(),
                      ),
                    ],
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
              child: Text(AppLocalizations.of(context)!.submitMeterReadings),
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
              child: Text(AppLocalizations.of(context)!.metersButton),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildDateTextSpan(
    DateTime? date,
    String? text,
  ) {
    return TextSpan(
      text: '${date != null ? DateFormat.MMMM().format(date) : ''} $text',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: AppColors.primaryColor,
      ),
    );
  }

  TextSpan _buildTextSpan(String text) {
    String translatedText = '';

    if (text == 'The meter readings can be submitted from ') {
      translatedText =
          AppLocalizations.of(context)!.themeterreadingscanbesubmittedfrom;
    } else if (text == ' to ') {
      translatedText = AppLocalizations.of(context)!.to;
    }

    return TextSpan(
      text: translatedText,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }
}
