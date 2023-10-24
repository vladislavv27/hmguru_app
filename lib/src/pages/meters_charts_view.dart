import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/meters_vm.dart';
import 'package:hmguru/src/services/preference_service.dart';

class MeterChartsPage extends StatefulWidget {
  @override
  _MeterChartsPageState createState() => _MeterChartsPageState();
}

class _MeterChartsPageState extends State<MeterChartsPage> {
  List<MetersVM> meterDataList = [];
  bool isLoading = true;
  final _preferenceService = PreferenceService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final myMeterDataList = await _preferenceService.loadMetersData();

      if (myMeterDataList != null) {
        setState(() {
          meterDataList = myMeterDataList;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Charts'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: meterDataList.length,
          itemBuilder: (context, index) {
            final meterData = meterDataList[index];
            final LineChart chart = buildLineChart(meterData);

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
        ),
      ),
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
            isCurved: true,
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
}
