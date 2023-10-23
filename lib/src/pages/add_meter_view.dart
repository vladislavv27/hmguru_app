import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'dart:convert';

import 'package:hmguru/src/models/ApartmentMeterVM.dart';
import 'package:hmguru/src/models/meter_reading.dart';
import 'package:hmguru/src/models/meters_vm.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';
import 'package:intl/intl.dart';

class AddMeterView extends StatefulWidget {
  @override
  _AddMeterViewState createState() => _AddMeterViewState();
}

class _AddMeterViewState extends State<AddMeterView> {
  MyLeaseholdVM? leaseholdData;
  List<ApartmentMeterVM>? apartmentMeterVM;

  DateTime? currentPeriod;
  bool dataLoaded = false;
  final _apiservice = ApiService();
  final _prefservice = PreferenceService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (dataLoaded) {
      return; // Data is already loaded, don't load again.
    }

    try {
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      final myMeterReadings = await _prefservice.loadApartmentMeterData();

      if (myLeaseholdVM != null) {
        setState(() {
          leaseholdData = myLeaseholdVM;
        });

        if (myMeterReadings != null) {
          setState(() {
            apartmentMeterVM = myMeterReadings;
          });
        }
        final period = await _apiservice.getCurrentPeriod(leaseholdData!.id);
        if (period != null) {
          setState(() {
            currentPeriod = period;
          });
        }

        apartmentMeterVM?.forEach((meter) {
          final consumptionValue = meter.consumption ?? 0.0;
          final curValue = meter.curValue ?? 0.0;
          final currentlyValue = curValue;

          meter.consumptionController =
              TextEditingController(text: consumptionValue.toStringAsFixed(2));
          meter.currentlyController =
              TextEditingController(text: currentlyValue.toStringAsFixed(2));
        });

        setState(() {
          dataLoaded = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Add Meter Readings'),
      ),
      body: dataLoaded
          ? CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Meter Readings for ${currentPeriod != null ? DateFormat.MMMM().format(currentPeriod!) : ''} 2023',
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
                      final meter = apartmentMeterVM![index];

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
                                title: Text('Previously ${meter.prevValue}'),
                              ),
                              ListTile(
                                title: Text('Consumption'),
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
                                        sendDataToFunction(numericValue, meter);
                                      }
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text('Currently'),
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
                                        sendDataToFunction(numericValue, meter);
                                      }
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                    childCount: apartmentMeterVM!.length,
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void sendDataToFunction(double newConsumptionValue, ApartmentMeterVM meter) {
    if (newConsumptionValue > 0) {
      final readingDTO = MeterReadingDTO(
        consumption: newConsumptionValue,
        curValue: 0,
        meterId: meter.meterId,
      );
      _apiservice.saveMeterReading(readingDTO);
      Future.delayed(Duration(seconds: 3), () {
        print('Sending data to function: $newConsumptionValue');
        meter.consumption = newConsumptionValue;
        meter.curValue = meter.prevValue + newConsumptionValue;
        _prefservice.saveApartmentMeterData(apartmentMeterVM!);
      });
    }
  }
}
