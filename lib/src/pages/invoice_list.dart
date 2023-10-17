import 'package:flutter/material.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/pages/invoice_details.dart';
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
  double _zoomValue = 1.0; // Initial zoom level

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
          : InteractiveViewer(
              boundaryMargin: EdgeInsets.all(200),
              minScale: 1.0,
              maxScale: 3.0,
              child: ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(label: Text('PERIOD')),
                        DataColumn(label: Text('INVOICE')),
                        DataColumn(label: Text('TO PAY FOR PERIOD')),
                        DataColumn(label: Text('TO PAY')),
                        DataColumn(label: Text('PAID')),
                        DataColumn(label: Text('DEBT')),
                        DataColumn(label: Text('PENALTY')),
                        DataColumn(label: Text('RECALCULATION')),
                        DataColumn(label: Text('')),
                      ],
                      rows: invoiceList.map((rowData) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                  DateFormat('yyyy-MM').format(rowData.period)),
                            ),
                            DataCell(Text(rowData.invoiceUID)),
                            DataCell(
                              Text(
                                rowData.toPayForPeriod,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                rowData.sumTotal,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                (double.tryParse(rowData.paymentSum) ?? 0) > 0
                                    ? '+ €${rowData.paymentSum}'
                                    : '€${rowData.paymentSum}',
                                style: TextStyle(),
                              ),
                            ),
                            DataCell(
                              Text(
                                rowData.debt,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                rowData.penalty,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warningColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(rowData.priceRecalculationValueTotal),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      _openAdditionalInformationPage(
                                          rowData.id);
                                    },
                                    icon: Icon(
                                      Icons.info,
                                      color: AppColors.secondaryColor,
                                    ),
                                    label: Text(''),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
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

  Future<void> _openAdditionalInformationPage(String id) async {
    try {
      // Fetch data using _apiservice.getInvoiceDataFormId
      await _apiservice.getInvoiceDataFormId(id);
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

void main() {
  runApp(MaterialApp(
    home: InvoiceListPage(),
  ));
}
