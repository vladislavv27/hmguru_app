import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmguru/src/controllers/home_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/my_leasehold_vm.dart';
import 'package:hmguru/src/view/menu/bottom_navigation.dart';
import 'package:hmguru/src/view/menu/side_menu.dart';
import 'package:hmguru/l10n/global_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  int _currentIndex = 0;
  bool receiveEmailInvoices = false;
  bool receivePrintedInvoices = false;

  @override
  void initState() {
    super.initState();
    _controller.loadLeaseholdData(setState);
    _controller.loadInvoiceData(() {
      setState(() {
        updateEmailCheckbox();
        updatePrintedCheckbox();
      });
    });
  }

  void updateEmailCheckbox() {
    receiveEmailInvoices = _controller.invoiceInfoData?.invoiceDeliveryType ==
            InvoiceDeliveryType.Email.index ||
        _controller.invoiceInfoData?.invoiceDeliveryType ==
            InvoiceDeliveryType.Both.index;
  }

  void updatePrintedCheckbox() {
    receivePrintedInvoices = _controller.invoiceInfoData?.invoiceDeliveryType ==
            InvoiceDeliveryType.Post.index ||
        _controller.invoiceInfoData?.invoiceDeliveryType ==
            InvoiceDeliveryType.Both.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.myApartment),
      ),
      drawer: const SideMenu(),
      body: _controller.isLoading
          ? const Center(
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
            _buildApartmentImage(),
            const SizedBox(height: 20),
            _buildApartmentInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildApartmentImage() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SvgPicture.asset(
            'assets/apartment.svg',
            height: 120,
            width: 120,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildApartmentInfo() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            _controller.leaseholdData != null
                ? '${_controller.leaseholdData!.address}\n${AppLocalizations.of(context)!.apartmentNumber}:${_controller.leaseholdData!.fullNumber}'
                : AppLocalizations.of(context)!.dataNotFound,
            style: TextStyle(
              color: _controller.leaseholdData != null
                  ? const Color(0xFF464646)
                  : AppColors.accentColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            _controller.invoiceInfoData != null
                ? AppLocalizations.of(context)!.lastInvoice
                : '',
            style: const TextStyle(
                color: Color(0xFF464646),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          Text(
            _controller.invoiceInfoData != null
                ? _controller.getPreviousMonthDate()
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
                ? _controller.invoiceInfoData!.invoiceUID
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
                const SizedBox(height: 30),
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.accentColor,
                  size: 48,
                ),
                Text(
                  '${AppLocalizations.of(context)!.youAreDebtor} ${_controller.leaseholdData!.balance}',
                  style: const TextStyle(
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
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(AppLocalizations.of(context)!.readMore),
          ),
          Row(
            children: [
              Checkbox(
                value: receiveEmailInvoices,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      if (value!) {
                        if (receivePrintedInvoices) {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Both);
                        } else {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Email);
                        }
                      } else {
                        if (!receivePrintedInvoices) {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Email);
                        } else {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Email);
                        }
                      }
                      receiveEmailInvoices = value;
                    });
                  }
                },
              ),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.emailInvoice,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrayColor),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: receivePrintedInvoices,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      if (!value!) {
                        if (receiveEmailInvoices) {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Both);
                        } else {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Post);
                        }
                      } else {
                        if (receiveEmailInvoices) {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Post);
                        } else {
                          _controller
                              .updateDeliveryType(InvoiceDeliveryType.Post);
                        }
                      }
                      receivePrintedInvoices = value;
                    });
                  }
                },
              ),
              Flexible(
                child: Text(AppLocalizations.of(context)!.printedInvoice,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGrayColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
