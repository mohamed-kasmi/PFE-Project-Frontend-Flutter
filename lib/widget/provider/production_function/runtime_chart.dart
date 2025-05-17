import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/machinedata.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
class RuntimeChartWidget extends StatelessWidget {
  final List<MachineData> data;
  final double maxY;
  const RuntimeChartWidget({
    super.key,
    required this.data,
    required this.maxY,
  });
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    double chartWidth = kIsWeb
        ? (data.length * 40 < 1880 ? 1880.0 : data.length * 40.0)
        : (data.length * 40 < 400 ? 400.0 : data.length * 40.0);
    bool bar = kIsWeb ? true : false ;
    return SizedBox(
      height: 420,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: bar,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Container(
                  width: chartWidth,
                  child: _buildRuntimeChart(maxY),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRuntimeChart(double maxY) {
    return Container(
      height: 400,
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 8.0),
            child: Text(
              'Runtime & Downtime Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 10,
                barGroups: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final runtime = item.runHoursDay;
                  final downtime = item.downHoursDay;
                  final total = runtime + downtime;
                  final runtimePercent = total > 0 ? runtime / total : 0.0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: total,
                        width: 18,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, runtimePercent, runtimePercent, 1.0],
                          colors: [Colors.green, Colors.green, Colors.grey, Colors.grey],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${value.toInt()}H',
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                      reservedSize: 50,
                    ),
                  ),

                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                alignment: BarChartAlignment.spaceEvenly,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = data[group.x.toInt()];
                      final RH = item.runHoursDay;
                      final DH = item.downHoursDay;

                      final runHours = RH.floor();
                      final runMinutes = ((RH - runHours) * 60).round();

                      final downHours = DH.floor();
                      final downMinutes = ((DH - downHours) * 60).round();

                      String formatTime(int hours, int minutes) =>
                          '${hours.toString().padLeft(0, '0')}H : ${minutes.toString().padLeft(0, '0')}M';

                      return BarTooltipItem(
                        'Run: ${formatTime(runHours, runMinutes)}\n'
                            'Down: ${formatTime(downHours, downMinutes)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 55,
    getTitlesWidget: (value, meta) {
      final index = value.toInt();
      if (index < 0 || index >= data.length) return const SizedBox();
      final currentDate = data[index].dateInsertDay;
      final day = DateFormat('dd').format(currentDate);
      final currentMonth = DateFormat('MMM').format(currentDate);
      final currentYear = DateFormat('yyyy').format(currentDate);
      bool showMonth = true;
      if (index > 0) {
        final previousDate = data[index - 1].dateInsertDay;
        final previousMonth = DateFormat('MMM').format(previousDate);
        if (previousMonth == currentMonth) {
          showMonth = false;
        }
      }
      bool showYear = true;
      if (index > 0) {
        final previousDate = data[index - 1].dateInsertDay;
        final previousYear = DateFormat('yyyy').format(previousDate);
        if (previousYear == currentYear) {
          showYear = false;
        }
      }
      return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Column(
          children: [
            Text(day),
            const SizedBox(height: 2),
            showMonth
                ? SizedBox(
              width: 30,
              child: Center(
                child: Text(currentMonth, style: const TextStyle(fontSize: 10)),
              ),
            )
                : const SizedBox(height: 12),
            const SizedBox(height: 2),
            showYear
                ? SizedBox(
              width: 30,
              child: Center(
                child: Text(currentYear, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            )
                : const SizedBox(height: 12),
          ],
        ),
      );
    },
  );

}
