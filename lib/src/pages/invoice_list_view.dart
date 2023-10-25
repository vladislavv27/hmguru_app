import 'package:flutter/material.dart';
import 'package:hmguru/src/controllers/invoice_list_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/pages/menu/side_menu.dart';
import 'package:intl/intl.dart';
import 'invoice_details_view.dart';
import 'menu/bottom_navigation.dart';

class InvoiceListPage extends StatefulWidget {
  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  List<InvoiceListVm> invoiceList = [];
  bool _isLoading = true;
  final _controller = InvoiceListController();
  var _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadInvoiceList();
  }

  Future<void> _loadInvoiceList() async {
    final updatedInvoices = await _controller.loadInvoiceList();
    setState(() {
      invoiceList = updatedInvoices;
      _isLoading = false;
    });
  }

  Future<void> _openAdditionalInformationPage(String id) async {
    final additionalData = await _controller.openAdditionalInformationPage(id);
    if (additionalData != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InvoiceDetailPage(data: additionalData),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice List'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: SideMenu(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildInvoiceListView(),
      bottomNavigationBar: MyBottomNavigationMenu(
        // Add this part
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildInvoiceListView() {
    return ListView(
      children: invoiceList.map((rowData) {
        return Card(
          child: _buildInvoiceExpansionTile(rowData),
        );
      }).toList(),
    );
  }

  Widget _buildInvoiceExpansionTile(InvoiceListVm rowData) {
    return ExpansionTile(
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
            _buildInfoButton(rowData.id),
            _buildDownloadButton(rowData.id),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoButton(String id) {
    return TextButton.icon(
      onPressed: () {
        _openAdditionalInformationPage(id);
      },
      icon: Icon(
        Icons.info,
        color: AppColors.secondaryColor,
      ),
      label: Text(''),
    );
  }

  Widget _buildDownloadButton(String id) {
    return TextButton.icon(
      onPressed: () async {
        bool downloaded = await _controller.downloadFile(id);
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
    );
  }
}
