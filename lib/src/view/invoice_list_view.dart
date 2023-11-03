import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/controllers/invoice_list_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/invoice_list.dart';
import 'package:hmguru/src/view/menu/side_menu.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'invoice_details_view.dart';
import 'menu/bottom_navigation.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

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
    if (mounted) {
      setState(() {
        invoiceList = updatedInvoices;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invoiceListTitle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const SideMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(text, style: const TextStyle(fontSize: 18));
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

    if (downloaded != null && downloaded.isNotEmpty) {
      final message = 'File $downloaded successfully downloaded';
      const color = AppColors.successColor;

      _showSnackBar(message, color);

      const directory = "/storage/emulated/0/Download"; //change !
      final filePath = '$directory/$downloaded';
      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.done) {
        print('File opened successfully');
      } else {
        print('Error opening file: ${result.message}');
      }
    } else {
      final message = AppLocalizations.of(context)!.downloadError;
      const color = AppColors.accentColor;

      _showSnackBar(message, color);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 2),
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
