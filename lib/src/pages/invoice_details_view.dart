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

  int? selectedRow;

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Detail'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          setState(() {
            _previousScale = _scale;
          });
        },
        child: ListView.builder(
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            final rowData = widget.data[index];
            return Card(
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service: ${rowData.serviceTitle}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Price: ${rowData.priceForService}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                children: [
                  Center(
                    child: Text(
                      "Tax: ${rowData.priceTaxTotal}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Debt: ${rowData.debtForService}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'To Pay: ${rowData.priceForServiceTotal}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      (double.tryParse(rowData.payedForService) ?? 0) > 0
                          ? 'Paid: +${rowData.payedForService}€'
                          : 'Paid: ${rowData.payedForService}€',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Penalty For Period: ${rowData.penaltyForService}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Penalty: ${rowData.penaltyForServiceTotal}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Recalculation: ${rowData.debtRecalculationValue}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Formula: ${rowData.rateFormula}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
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
