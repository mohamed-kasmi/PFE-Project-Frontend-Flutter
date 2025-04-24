import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CombinedChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double maxY;

  const CombinedChartWidget({
    super.key,
    required this.data,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        children: [
          _buildBarChart(),
          Positioned.fill(child: _buildLineChart()),
        ],
      ),
    );
  }

  BarChart _buildBarChart() {

    return BarChart(

      BarChartData(
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value["quantity"].toDouble(),
                width: 18,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
          leftTitles: AxisTitles(sideTitles: _leftTitles(maxY)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        alignment: BarChartAlignment.spaceEvenly,
        minY: 0,
        maxY: maxY,
      ),
    );
  }

  LineChart _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value["efficiency"].toDouble());
            }).toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.green.shade700,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final item = data[index];
                return LineTooltipItem(
                  'Date: ${item["date"]}\nEfficiency: ${item["efficiency"]}%\nQuantity: ${item["quantity"]}',
                  TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        minX: -1.2,
        maxX: data.length.toDouble()+0.5,
        minY: 0,
        maxY: maxY,
      ),
    );
  }


  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      final index = value.toInt();
      return Text(data[index]["date"].substring(8));
    },
  );

  SideTitles _leftTitles(double maxY) => SideTitles(
    showTitles: true,
    interval: maxY > 20 ? (maxY / 5) : 5,
    getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
  );
}