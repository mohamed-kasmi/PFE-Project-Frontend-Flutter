import 'package:flutter/material.dart';
import 'bar_chart.dart';

Widget buildChartSection() {
  return Row(
    children: [
      Expanded(child: buildBarChart('Heures de Production & TRS')),
      SizedBox(width: 16),
      Expanded(child: buildBarChart('Quantité Produite & TRS')),
    ],
  );
}
