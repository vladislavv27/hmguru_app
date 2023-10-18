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
  final _prefservice = PreferenceService();
  final _apiservice = ApiService();
  var _currentIndex = 2;
  bool _dataLoaded = false;
  double _zoomValue = 1.0; // Initial zoom level

  @override
  void initState() {
    super.initState();
    _loadInvoiceList();
  }

  Future<void> _loadInvoiceList() async {
    final updatedInvoices = await _prefservice.loadInvoiceList();
    setState(() {
      invoiceList = updatedInvoices;
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Invoice List'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _dataLoaded
          ? _buildInvoiceTable()
          : Center(child: CircularProgressIndicator()),
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

  Widget _buildInvoiceTable() {
    return ListView(
      children: [
        DataTable(
          columnSpacing:
              8.0, // Set the column spacing to 8.0 (adjust as needed)
          columns: [
            DataColumn(label: Text('PERIOD')),
            DataColumn(label: Text('INVOICE')),
            DataColumn(label: Text('')),
          ],
          rows: invoiceList.map((rowData) {
            return DataRow(
              cells: [
                DataCell(
                  Text(DateFormat('yyyy-MM').format(rowData.period)),
                ),
                DataCell(Text(rowData.invoiceUID)),
                DataCell(
                  Row(
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
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
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
}
