import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/controllers/home_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/pages/menu/bottom_navigation.dart';
import 'package:hmguru/src/pages/menu/side_menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.loadLeaseholdData(setState);
    _controller.loadInvoiceData(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My apartment'),
      ),
      drawer: SideMenu(),
      body: _controller.isLoading
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
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          _controller.leaseholdData != null
                              ? '${_controller.leaseholdData!.address}\nApartment number:${_controller.leaseholdData!.fullNumber}'
                              : 'Sorry, data not found',
                          style: TextStyle(
                            color: _controller.leaseholdData != null
                                ? Color(0xFF464646)
                                : AppColors.accentColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          _controller.invoiceInfoData != null
                              ? 'Last invoice: ${_controller.getPreviousMonthDate()}'
                              : 'No invoice data available',
                          style: TextStyle(
                            color: Color(0xFF464646),
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          _controller.invoiceInfoData != null
                              ? 'Invoice: ${_controller.invoiceInfoData!.invoiceUID}'
                              : 'No invoice data available',
                          style: TextStyle(
                            color: _controller.leaseholdData != null
                                ? Color(0xFF464646)
                                : AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _controller.invoiceInfoData != null
                              ? '${_controller.invoiceInfoData!.sumTotal}€'
                              : 'No invoice data available',
                          style: TextStyle(
                            color: _controller.leaseholdData != null
                                ? AppColors.primaryColor
                                : AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_controller.invoiceInfoData != null &&
                            !_controller.invoiceInfoData!.isPaid)
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
                            _controller.openAdditionalInformationPage(
                                context, setState);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primaryColor,
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
}
