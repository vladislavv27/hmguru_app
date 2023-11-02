import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart'; // Import your localization file here
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/invoice_details_vm.dart';

class InvoiceDetailPage extends StatefulWidget {
  final List<InvoiceDetailVM> data;

  const InvoiceDetailPage({super.key, required this.data});

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invoiceDetailTitle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        child: ListView(
          children: <Widget>[
            _buildHeaderRow(totalPrice),
            _buildInvoiceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderItem(
            '${AppLocalizations.of(context)!.invoiceLabel}: ${widget.data.isNotEmpty ? widget.data[0].invoiceUID : ""}'),
        _buildHeaderItem(
            '${AppLocalizations.of(context)!.toPayLabel}: ${totalPrice.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildHeaderItem(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildInvoiceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final rowData = widget.data[index];
        return Card(
          child: ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(
                    '${AppLocalizations.of(context)!.serviceLabel}: ${rowData.serviceTitle}'),
                _buildText(
                    '${AppLocalizations.of(context)!.priceLabel}: ${rowData.priceForService}'),
              ],
            ),
            children: _buildInvoiceDetails(rowData),
          ),
        );
      },
    );
  }

  List<Widget> _buildInvoiceDetails(InvoiceDetailVM rowData) {
    return [
      _buildText(
          '${AppLocalizations.of(context)!.taxLabel}: ${rowData.priceTaxTotal}'),
      _buildText(
          '${AppLocalizations.of(context)!.debtLabel}: ${rowData.debtForService}'),
      _buildText(
          '${AppLocalizations.of(context)!.toPayLabel}: ${rowData.priceForServiceTotal}'),
      _buildText((double.tryParse(rowData.payedForService) ?? 0) > 0
          ? '${AppLocalizations.of(context)!.paidLabel}: +${rowData.payedForService}€'
          : '${AppLocalizations.of(context)!.paidLabel}: ${rowData.payedForService}€'),
      _buildText(
          '${AppLocalizations.of(context)!.penaltyPeriodLabel}: ${rowData.penaltyForService}'),
      _buildText(
          '${AppLocalizations.of(context)!.penaltyLabel}: ${rowData.penaltyForServiceTotal}'),
      _buildText(
          '${AppLocalizations.of(context)!.recalculationLabel}: ${rowData.debtRecalculationValue}'),
      _buildText(
          '${AppLocalizations.of(context)!.formulaLabel}: ${rowData.rateFormula}'),
    ];
  }

  Widget _buildText(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var rowData in widget.data) {
      total += double.parse(rowData.priceForServiceTotal);
    }
    return total;
  }
}
