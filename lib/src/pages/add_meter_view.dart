import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmguru/src/controllers/add_meter_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:intl/intl.dart';

class AddMeterView extends StatefulWidget {
  @override
  _AddMeterViewState createState() => _AddMeterViewState();
}

class _AddMeterViewState extends State<AddMeterView> {
  final controller = AddMeterController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.initializeData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Add Meter Readings'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Meter Readings for ${controller.currentPeriod != null ? DateFormat.MMMM().format(controller.currentPeriod!) + ' ' + DateFormat.y().format(controller.currentPeriod!) : ''}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final meter = controller.apartmentMeterVM![index];

                      return Column(
                        children: [
                          ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meter.serviceTitle,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  meter.meterUID,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            children: [
                              ListTile(
                                title: Text(
                                  'Previously: ${meter.prevValue}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textGrayColor),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Consumption',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textGrayColor),
                                ),
                                subtitle: TextFormField(
                                    controller: meter.consumptionController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        final numericValue =
                                            double.tryParse(value);
                                        if (numericValue != null) {
                                          double newConsumptionValue =
                                              numericValue;
                                          double currentlyValue =
                                              meter.prevValue +
                                                  newConsumptionValue;
                                          meter.currentlyController.text =
                                              currentlyValue.toStringAsFixed(2);
                                        }
                                      }
                                    },
                                    onEditingComplete: () {
                                      if (meter.consumptionController.text
                                          .isNotEmpty) {
                                        final numericValue = double.tryParse(
                                            meter.consumptionController.text);
                                        if (numericValue != null &&
                                            numericValue > 0) {
                                          controller.sendDataToFunction(
                                              context, numericValue, meter);
                                        }
                                      }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              ListTile(
                                title: Text(
                                  'Currently',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textGrayColor),
                                ),
                                subtitle: TextFormField(
                                  controller: meter.currentlyController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      final numericValue =
                                          double.tryParse(value);
                                      if (numericValue != null) {
                                        double currentlyValue = numericValue;

                                        if (currentlyValue < meter.prevValue) {
                                          meter.consumptionController.text =
                                              "0.00";
                                        } else {
                                          double consumptionValue =
                                              currentlyValue - meter.prevValue;
                                          meter.consumptionController.text =
                                              consumptionValue
                                                  .toStringAsFixed(2);
                                        }
                                      }
                                    }
                                  },
                                  onEditingComplete: () {
                                    if (meter
                                        .currentlyController.text.isNotEmpty) {
                                      final numericValue = double.tryParse(
                                          meter.currentlyController.text);
                                      if (numericValue != null &&
                                          numericValue > 0) {
                                        controller.sendDataToFunction(
                                            context, numericValue, meter);
                                      }
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                    childCount: controller.apartmentMeterVM!.length,
                  ),
                ),
                if (controller.apartmentMeterVM == null ||
                    controller.apartmentMeterVM!.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text('No data',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                              fontSize: 20)),
                    ),
                  ),
              ],
            ),
    );
  }
}
