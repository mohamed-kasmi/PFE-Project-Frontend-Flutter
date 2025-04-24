import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RuntimeChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> productionData;
  final double maxY;

  const RuntimeChartWidget({
    super.key,
    required this.productionData,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return _buildRuntimeChart(maxY);
  }

  Widget _buildRuntimeChart(double maxY) {
    return Container(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: productionData.asMap().entries.map((entry) {
            final runtime = entry.value["runtime"];
            final total = runtime + entry.value["downtime"];
            final runtimePercent = total > 0 ? runtime / total : 0.0;

            return BarChartGroupData(
              x: entry.key,
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
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: _leftTitles(maxY)),
          ),
        ),
      ),
    );
  }

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      final index = value.toInt();
      return Text(productionData[index]["date"].substring(8));
    },
  );

  SideTitles _leftTitles(double maxY) => SideTitles(
    showTitles: true,
    interval: maxY > 20 ? (maxY / 5) : 5,
    getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
  );
}
