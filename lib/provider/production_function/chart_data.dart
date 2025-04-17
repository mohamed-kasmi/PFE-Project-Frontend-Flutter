import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartData buildBarChartData() {
  return BarChartData(
    alignment: BarChartAlignment.spaceAround,
    maxY: 100,
    barTouchData: BarTouchData(enabled: true),
    gridData: FlGridData(show: true, horizontalInterval: 10),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, _) => Text('Day ${value.toInt() + 1}'),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, _) => Text('${value.toInt()}%'),
        ),
      ),
    ),
    borderData: FlBorderData(show: false),
    barGroups: [
      makeGroupData(0, 50, 45),
      makeGroupData(1, 70, 60),
      makeGroupData(2, 65, 55),
      makeGroupData(3, 80, 75),
      makeGroupData(4, 90, 85),
    ],
  );
}

BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(fromY: 0, toY: y1, width: 20, color: Colors.blue),
      BarChartRodData(fromY: 0, toY: y2, width: 20, color: Colors.green),
    ],
    barsSpace: 4,
  );
}
