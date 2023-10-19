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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  final rowData = widget.data[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Service: ${rowData.serviceTitle}'),
                        subtitle: Text('Price: ${rowData.priceForService}'),
                        onTap: () {
                          toggleExpansion(index);
                        },
                      ),
                      if (selectedRow == index)
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tax: ${rowData.priceTaxTotal}'),
                              Text(
                                'Debt: ${rowData.debtForService}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.accentColor,
                                ),
                              ),
                              Text(
                                'To Pay: ${rowData.priceForServiceTotal}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                'Paid: ${rowData.payedForService}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.succesColor,
                                ),
                              ),
                              Text(
                                  'Penalty For Period: ${rowData.penaltyForService}'),
                              Text(
                                'Penalty: ${rowData.penaltyForServiceTotal}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.warningColor,
                                ),
                              ),
                              Text(
                                  'Recalculation: ${rowData.debtRecalculationValue}'),
                              Text('Formula: ${rowData.rateFormula}'),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleExpansion(int index) {
    setState(() {
      if (selectedRow == index) {
        selectedRow = null;
      } else {
        selectedRow = index;
      }
    });
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var rowData in widget.data) {
      total += double.parse(rowData.priceForServiceTotal);
    }
    return total;
  }
}
