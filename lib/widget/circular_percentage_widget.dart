import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CircularPercentageWidget extends StatelessWidget {
  final double percentage;

  CircularPercentageWidget({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(
              value: percentage,
              color: Colors.blueAccent,
              radius: 25,
              title: "${percentage.toInt()}%",
              titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: 100 - percentage,
              color: Colors.grey.shade300,
              radius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
