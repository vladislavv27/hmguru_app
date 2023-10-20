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
        child: ListView(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ListView.builder(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Tax: ${rowData.priceTaxTotal}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Debt: ${rowData.debtForService}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'To Pay: ${rowData.priceForServiceTotal}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            (double.tryParse(rowData.payedForService) ?? 0) > 0
                                ? 'Paid: +${rowData.payedForService}€'
                                : 'Paid: ${rowData.payedForService}€',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Penalty For Period: ${rowData.penaltyForService}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Penalty: ${rowData.penaltyForServiceTotal}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Recalculation: ${rowData.debtRecalculationValue}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Formula: ${rowData.rateFormula}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
