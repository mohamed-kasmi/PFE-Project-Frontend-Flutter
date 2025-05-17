import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductionPieChart extends StatelessWidget {
  final String title;
  final List<String> labels;
  final List<double> values;

  const ProductionPieChart({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'Good': Colors.green,
      'Rejected': Colors.red,
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: List.generate(labels.length, (index) {
                    return PieChartSectionData(
                      color: colorMap[labels[index]] ?? Colors.grey,
                      value: values[index] * 100 /2,
                      title: '${values[index].toStringAsFixed(0)}%',
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ),
            ),
            _buildPieLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: labels.map((label) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: _getColorForLabel(label),
            ),
            const SizedBox(width: 4),
            Text(label),
          ],
        );
      }).toList(),
    );
  }

  Color _getColorForLabel(String label) {
    return {
      'Good': Colors.green,
      'Rejected': Colors.red,
    }[label] ?? Colors.grey;
  }
}