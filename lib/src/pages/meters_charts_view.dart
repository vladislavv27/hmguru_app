import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hmguru/src/controllers/meter_charts_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/meters_vm.dart';

class MeterChartsPage extends StatefulWidget {
  final MeterChartsController controller;

  MeterChartsPage({required this.controller});

  @override
  _MeterChartsPageState createState() => _MeterChartsPageState();
}

class _MeterChartsPageState extends State<MeterChartsPage> {
  bool _isDataLoaded = false;
  int? selectedYear;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await widget.controller.initializeData();
    setState(() {
      _isDataLoaded = true;
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      case 11:
        text = const Text('Dec', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Future<void> _showModalBottomSheet() async {
    await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: widget.controller.meterPeriodList.length,
                itemBuilder: (context, index) {
                  final meterPeriod = widget.controller.meterPeriodList[index];
                  return ListTile(
                    title: Text('$meterPeriod'),
                    onTap: () async {
                      Navigator.of(context).pop(meterPeriod);
                      try {
                        await widget.controller.updateDataForYear(meterPeriod);
                        setState(() {
                          selectedYear = meterPeriod;
                        });
                      } catch (error) {
                        print('Error updating data: $error');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  LineChart buildLineChart(MetersVM meterData) {
    final List<FlSpot> spots = [];
    for (int i = 0; i < meterData.chartData!.labels.length; i++) {
      spots.add(FlSpot(
        i.toDouble(),
        meterData.chartData!.values[i].toDouble(),
      ));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            barWidth: 3,
            color: AppColors.chartColor,
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.chartColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Charts'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Container(
                width: 160,
                child: ElevatedButton(
                  onPressed: _showModalBottomSheet,
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                  ),
                  child: Text(
                    selectedYear != null
                        ? 'Select period: $selectedYear'
                        : 'Select period',
                  ),
                ),
              ),
            ),
            _isDataLoaded
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: widget.controller.meterDataList.length,
                    itemBuilder: (context, index) {
                      final meterData = widget.controller.meterDataList[index];
                      final chart = buildLineChart(meterData);

                      if (meterData.chartData!.values.isEmpty) {
                        return Container(
                            margin: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${meterData.title}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${meterData.meterUID}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    ' No Data',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentColor),
                                  ),
                                ]));
                      }

                      return Container(
                        margin: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${meterData.title}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${meterData.meterUID}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 300,
                              child: chart,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
