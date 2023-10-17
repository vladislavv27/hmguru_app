import 'package:flutter/material.dart';
import 'package:hmguru/src/models/invoice_details.dart';

class InvoiceDetailPage extends StatefulWidget {
  final List<InvoiceDetailVM> data;

  InvoiceDetailPage({required this.data});

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Detail'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _previousScale = _scale;
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Transform.scale(
              scale: _scale,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Text('SERVICE')),
                  DataColumn(label: Text('PRICE')),
                  DataColumn(label: Text('TAX')),
                  DataColumn(label: Text('DEBT')),
                  DataColumn(label: Text('TO PAY')),
                  DataColumn(label: Text('PAID')),
                  DataColumn(label: Text('PENALTY FOR PERIOD')),
                  DataColumn(label: Text('PENALTY')),
                  DataColumn(label: Text('RECALCULATION')),
                  DataColumn(label: Text('FORMULA')),
                ],
                rows: widget.data.map((rowData) {
                  return DataRow(
                    cells: [
                      DataCell(Text(rowData.serviceTitle)),
                      DataCell(Text(rowData.priceForService)),
                      DataCell(Text(rowData.priceTaxTotal)),
                      DataCell(Text(rowData.debtForService)),
                      DataCell(Text(rowData.priceForServiceTotal)),
                      DataCell(Text(rowData.payedForService)),
                      DataCell(Text(rowData.penaltyForService)),
                      DataCell(Text(rowData.penaltyForServiceTotal)),
                      DataCell(Text(rowData.debtRecalculationValue)),
                      DataCell(Text(rowData.rateFormula)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
