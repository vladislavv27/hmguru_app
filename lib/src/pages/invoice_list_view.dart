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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice List'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: SideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildInvoiceListView(),
      bottomNavigationBar: MyBottomNavigationMenu(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
          _buildCenterText(DateFormat('yyyy-MM').format(rowData.period)),
          _buildCenterText(rowData.invoiceUID),
        ],
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildText("To Pay For Period: ${rowData.toPayForPeriod}"),
            _buildText("To Pay: ${rowData.sumTotal}"),
            _buildText((double.tryParse(rowData.paymentSum) ?? 0) > 0
                ? 'Paid: +${rowData.paymentSum}€'
                : 'Paid: ${rowData.paymentSum}€'),
            _buildText('Debt: ${rowData.debt}'),
            _buildText('Penalty: ${rowData.penalty}'),
            _buildText('Recalculation ${rowData.priceRecalculationValueTotal}'),
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

  Widget _buildCenterText(String text) {
    return Expanded(
      child: Center(
        child: Text(text, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(text, style: TextStyle(fontSize: 18));
  }

  Widget _buildInfoButton(String id) =>
      _buildTextButton(id, Icons.info, AppColors.secondaryColor);

  Widget _buildDownloadButton(String id) =>
      _buildTextButton(id, Icons.download, AppColors.accentColor);

  Widget _buildTextButton(String id, IconData icon, Color color) {
    return TextButton.icon(
      onPressed: () => _handleButton(id, icon),
      icon: Icon(icon, color: color),
      label: Text(''),
    );
  }

  void _handleButton(String id, IconData icon) async {
    if (icon == Icons.info) {
      _openAdditionalInformationPage(id);
    } else if (icon == Icons.download) {
      _handleDownload(id);
    }
  }

  Future<void> _handleDownload(String id) async {
    final downloaded = await _controller.downloadFile(id);
    final message = downloaded ? 'Successfully downloaded' : 'Download error';
    final color = downloaded ? AppColors.successColor : AppColors.accentColor;
    _showSnackBar(message, color);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _openAdditionalInformationPage(String id) async {
    final additionalData = await _controller.openAdditionalInformationPage(id);
    if (additionalData != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InvoiceDetailPage(data: additionalData),
      ));
    }
  }
}
