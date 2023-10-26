import 'package:flutter/material.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/invoice_details_vm.dart';

class InvoiceDetailPage extends StatefulWidget {
  final List<InvoiceDetailVM> data;

  InvoiceDetailPage({required this.data});

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Detail'),
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
            'Invoice: ${widget.data.isNotEmpty ? widget.data[0].invoiceUID : ""}'),
        _buildHeaderItem('To pay: ${totalPrice.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildHeaderItem(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildInvoiceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final rowData = widget.data[index];
        return Card(
          child: ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText('Service: ${rowData.serviceTitle}'),
                _buildText('Price: ${rowData.priceForService}'),
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
      _buildText('Tax: ${rowData.priceTaxTotal}'),
      _buildText('Debt: ${rowData.debtForService}'),
      _buildText('To Pay: ${rowData.priceForServiceTotal}'),
      _buildText((double.tryParse(rowData.payedForService) ?? 0) > 0
          ? 'Paid: +${rowData.payedForService}€'
          : 'Paid: ${rowData.payedForService}€'),
      _buildText('Penalty For Period: ${rowData.penaltyForService}'),
      _buildText('Penalty: ${rowData.penaltyForServiceTotal}'),
      _buildText('Recalculation: ${rowData.debtRecalculationValue}'),
      _buildText('Formula: ${rowData.rateFormula}'),
    ];
  }

  Widget _buildText(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
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
