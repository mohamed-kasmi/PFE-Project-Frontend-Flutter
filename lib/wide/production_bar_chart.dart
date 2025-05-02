import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdcs_frontend/models/machine.dart';
import '../../models/production_data.dart';

class ProductionBarChart extends StatelessWidget {
final Machine data;
const ProductionBarChart({super.key, required this.data});

@override
Widget build(BuildContext context) {
      return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BarChart(

                              BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: data.qtPlanifier.toDouble()+3000,
                                    titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, _) {
                                                            switch (value.toInt()) {
                                                                  case 0:
                                                                        return const Text('Planifié');
                                                                  case 1:
                                                                        return const Text('Bon');
                                                                  case 2:
                                                                        return const Text('Rejet');
                                                                  case 3:
                                                                        return const Text('To Do');
                                                                  default:
                                                                        return const Text('');
                                                            }
                                                      },
                                                ),
                                          ),
                                          leftTitles: const AxisTitles(
                                                sideTitles: SideTitles(showTitles: true,reservedSize: 50),
                                          ),
                                          rightTitles: const AxisTitles(
                                                sideTitles: SideTitles(showTitles: false)
                                          ),
                                          topTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false)
                                          )

                                    ),
                                    barGroups: [
                                          BarChartGroupData(
                                                x: 0,
                                                barRods: [
                                                      BarChartRodData(
                                                            toY: data.qtPlanifier.toDouble(),
                                                            color: Colors.orange,
                                                            width: 14,
                                                            borderRadius: BorderRadius.zero,
                                                      )
                                                ],
                                          ),
                                          BarChartGroupData(
                                                x: 1,
                                                barRods: [
                                                      BarChartRodData(
                                                            toY: data.bon.toDouble(),
                                                            color: Colors.green,
                                                            width: 14,
                                                            borderRadius: BorderRadius.zero,
                                                      )
                                                ],
                                          ),
                                          BarChartGroupData(
                                                x: 2,
                                                barRods: [
                                                      BarChartRodData(
                                                            toY: data.reject.toDouble(),
                                                            color: Colors.red,
                                                            width: 14,
                                                            borderRadius: BorderRadius.zero,
                                                      )
                                                ],
                                          ),
                                          BarChartGroupData(
                                                x: 3,
                                                barRods: [
                                                      BarChartRodData(
                                                            toY: data.toDo.toDouble(),
                                                            color: Colors.blue,
                                                            width: 14,
                                                            borderRadius: BorderRadius.zero,
                                                      )
                                                ],
                                          ),
                                    ],
                              ),
                        ),
                  ),
            );
      }
}