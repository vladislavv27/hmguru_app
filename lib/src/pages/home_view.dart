import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/controllers/home_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/pages/menu/bottom_navigation.dart';
import 'package:hmguru/src/pages/menu/side_menu.dart';
import 'package:hmguru/l10n/global_localizations.dart'; // Import localization

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

  Widget _buildApartmentImage() {
    return OrientationBuilder(
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
    );
  }

  Widget _buildApartmentInfo() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            _controller.leaseholdData != null
                ? '${_controller.leaseholdData!.address}\n${AppLocalizations.of(context)!.apartmentNumber}:${_controller.leaseholdData!.fullNumber}'
                : AppLocalizations.of(context)!.dataNotFound,
            style: TextStyle(
              color: _controller.leaseholdData != null
                  ? Color(0xFF464646)
                  : AppColors.accentColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 25),
          Text(
            _controller.invoiceInfoData != null
                ? AppLocalizations.of(context)!.lastInvoice
                : '',
            style: TextStyle(
                color: Color(0xFF464646),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          Text(
            _controller.invoiceInfoData != null
                ? '${_controller.getPreviousMonthDate()}'
                : '',
            style: TextStyle(
              color: _controller.leaseholdData != null
                  ? AppColors.textGrayColor
                  : AppColors.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            _controller.invoiceInfoData != null
                ? '${_controller.invoiceInfoData!.invoiceUID}'
                : AppLocalizations.of(context)!.noInvoiceData,
            style: TextStyle(
              color: _controller.leaseholdData != null
                  ? AppColors.textGrayColor
                  : AppColors.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            _controller.invoiceInfoData != null
                ? '${_controller.invoiceInfoData!.sumTotal}€'
                : AppLocalizations.of(context)!.noInvoiceData,
            style: TextStyle(
              color: _controller.leaseholdData != null
                  ? AppColors.primaryColor
                  : AppColors.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (_controller.leaseholdData!.balance.isNegative)
            Column(
              children: [
                SizedBox(height: 30),
                Icon(
                  Icons.local_fire_department,
                  color: AppColors.accentColor,
                  size: 48,
                ),
                Text(
                  '${AppLocalizations.of(context)!.youAreDebtor} ${_controller.leaseholdData!.balance}',
                  style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              _controller.openAdditionalInformationPage(context, setState);
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.primaryColor,
            ),
            child: Text(AppLocalizations.of(context)!.readMore),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.myApartment),
      ),
      drawer: SideMenu(),
      body: _controller.isLoading
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
            SizedBox(height: 20),
            _buildApartmentImage(),
            SizedBox(height: 20),
            _buildApartmentInfo(),
          ],
        ),
      ),
    );
  }
}
