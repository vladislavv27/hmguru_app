import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.invoiceListTitle),
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
            _buildText(
                '${AppLocalizations.of(context)!.toPayForPeriod}: ${rowData.toPayForPeriod}'),
            _buildText(
                '${AppLocalizations.of(context)!.toPay}: ${rowData.sumTotal}'),
            _buildText((double.tryParse(rowData.paymentSum) ?? 0) > 0
                ? '${AppLocalizations.of(context)!.paid}: +${rowData.paymentSum}€'
                : '${AppLocalizations.of(context)!.paid}: ${rowData.paymentSum}€'),
            _buildText(
                '${AppLocalizations.of(context)!.debt}: ${rowData.debt}'),
            _buildText(
                '${AppLocalizations.of(context)!.penalty}: ${rowData.penalty}'),
            _buildText(
                '${AppLocalizations.of(context)!.recalculation}: ${rowData.priceRecalculationValueTotal}'),
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

  Widget _buildInfoButton(String id) => _buildTextButton(id, Icons.info,
      AppColors.secondaryColor, AppLocalizations.of(context)!.infoButton);

  Widget _buildDownloadButton(String id) => _buildTextButton(id, Icons.download,
      AppColors.accentColor, AppLocalizations.of(context)!.downloadButton);

  Widget _buildTextButton(String id, IconData icon, Color color, String label) {
    return TextButton.icon(
      onPressed: () => _handleButton(id, icon),
      icon: Icon(icon, color: color),
      label: Text(label),
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
    final message = downloaded
        ? AppLocalizations.of(context)!.successfullyDownloaded
        : AppLocalizations.of(context)!.downloadError;
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
