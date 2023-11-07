import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/controllers/meter_charts_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/meters_vm.dart';

class MeterChartsPage extends StatefulWidget {
  final MeterChartsController controller;

  const MeterChartsPage({super.key, required this.controller});

  @override
  _MeterChartsPageState createState() => _MeterChartsPageState();
}

class _MeterChartsPageState extends State<MeterChartsPage> {
  bool _isDataLoaded = false;
  int? selectedYear;
  final monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await widget.controller.initializeData();
    if (mounted) {
      setState(() {
        _isDataLoaded = true;
      });
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );

    final text = value.toInt() >= 0 && value.toInt() < monthNames.length
        ? Text(monthNames[value.toInt()], style: style)
        : Text('', style: style);

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
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
        title: Text(AppLocalizations.of(context)!.meterChartsTitle),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: _showModalBottomSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    selectedYear != null
                        ? AppLocalizations.of(context)!.selectPeriodLabel +
                            (selectedYear.toString())
                        : AppLocalizations.of(context)!.selectPeriodLabelNoYear,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            _isDataLoaded
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: widget.controller.meterDataList.length,
                    itemBuilder: (context, index) {
                      final meterData = widget.controller.meterDataList[index];
                      final chart = buildLineChart(meterData);

                      if (meterData.chartData!.values.isEmpty) {
                        return Container(
                            margin: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.noInvoiceData,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${meterData.meterUID}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.noDataLabel,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentColor),
                                  ),
                                ]));
                      }

                      return Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${meterData.title}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${meterData.meterUID}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.textGrayColor),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: chart,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
