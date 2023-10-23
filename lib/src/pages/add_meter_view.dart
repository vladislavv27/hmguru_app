import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmguru/src/models/ApartmentMeterVM.dart';
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
  double consumption = 0.0;
  double currently = 0.0;
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
                      TextEditingController consumptionController =
                          TextEditingController();
                      TextEditingController currentlyController =
                          TextEditingController();

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
                                  controller: consumptionController,
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
                                        currentlyController.text =
                                            currentlyValue.toStringAsFixed(2);

                                        sendDataToFunction(
                                            newConsumptionValue, meter);
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
                                  controller: currentlyController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      final numericValue =
                                          double.tryParse(value);
                                      if (numericValue != null) {
                                        double currentlyValue = numericValue;

                                        if (currentlyValue < meter.prevValue) {
                                          consumptionController.text = "0.00";
                                        } else {
                                          double consumptionValue =
                                              currentlyValue - meter.prevValue;
                                          consumptionController.text =
                                              consumptionValue
                                                  .toStringAsFixed(2);
                                        }
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
      Future.delayed(Duration(seconds: 3), () {
        print('Sending data to function: $newConsumptionValue');
      });
    }
  }
}
