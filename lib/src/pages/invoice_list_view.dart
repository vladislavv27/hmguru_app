import 'package:flutter/material.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/pages/invoice_details_view.dart';
import 'package:hmguru/src/pages/menu/bottom_navigation.dart';
import 'package:hmguru/src/pages/menu/side_menu.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:intl/intl.dart';

class InvoiceListPage extends StatefulWidget {
  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  List<InvoiceList> invoiceList = [];
  InvoiceInfo? invoiceInfoData;
  bool _isLoading = true;
  final _prefservice = PreferenceService();
  final _apiservice = ApiService();
  var _currentIndex = 2;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!_dataLoaded) {
      _loadInvoiceList();
    }
  }

  Future<void> _loadInvoiceList() async {
    try {
      setState(() {
        _isLoading = true; // Start loading
      });

      await _apiservice.getInvoiceList();

      final updatedInvoices = await _prefservice.loadInvoiceList();
      setState(() {
        invoiceList = updatedInvoices;
        _dataLoaded = true; // Set this flag to true after loading the data.
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> _openAdditionalInformationPage(String id) async {
    try {
      await _apiservice.getInvoiceDataFormId(id);
      final additionalData = await _prefservice.loadInvoiceDetails();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InvoiceDetailPage(data: additionalData),
      ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Invoice List'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: invoiceList.map((rowData) {
                return Card(
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              DateFormat('yyyy-MM').format(rowData.period),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              rowData.invoiceUID,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "To Pay For Period: ${rowData.toPayForPeriod}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "To Pay: ${rowData.sumTotal}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            (double.tryParse(rowData.paymentSum) ?? 0) > 0
                                ? 'Paid: +${rowData.paymentSum}€'
                                : 'Paid: ${rowData.paymentSum}€',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Debt: ${rowData.debt}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Penalty: ${rowData.penalty}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Recalculation ${rowData.priceRecalculationValueTotal}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              _openAdditionalInformationPage(rowData.id);
                            },
                            icon: Icon(
                              Icons.info,
                              color: AppColors.secondaryColor,
                            ),
                            label: Text(''),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              bool downloaded =
                                  await _apiservice.downloadFile(rowData.id);
                              if (downloaded) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Successfully downloaded'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Download error'),
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.download,
                              color: AppColors.accentColor,
                            ),
                            label: Text(''),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
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

  void main() {
    runApp(MaterialApp(
      home: InvoiceListPage(),
    ));
  }
}
