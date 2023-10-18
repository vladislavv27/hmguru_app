import 'package:flutter/material.dart';
import 'package:hmguru/src/models/app_colors.dart';
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
    double totalPrice = calculateTotalPrice(); // Calculate the total price
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Detail'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          // Calculate the new scale value based on pinch gestures
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          // Save the scale value when scaling ends
          setState(() {
            _previousScale = _scale;
          });
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Invoice: ${widget.data.isNotEmpty ? widget.data[0].invoiceUID : ""}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'To pay: ${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(200),
                  minScale: 1.0,
                  maxScale: 3.0,
                  scaleEnabled: true, // Allow scaling
                  panEnabled: false, // Allow panning
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
                          DataCell(Text(
                            rowData.debtForService,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppColors.accentColor,
                            ),
                          )),
                          DataCell(Text(
                            rowData.priceForServiceTotal,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          )),
                          DataCell(Text(
                            rowData.payedForService,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppColors.succesColor,
                            ),
                          )),
                          DataCell(Text(rowData.penaltyForService)),
                          DataCell(Text(
                            rowData.penaltyForServiceTotal,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppColors.warningColor,
                            ),
                          )),
                          DataCell(Text(rowData.debtRecalculationValue)),
                          DataCell(Text(rowData.rateFormula)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
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
