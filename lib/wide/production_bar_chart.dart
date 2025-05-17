import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdcs_frontend/models/machine.dart';

class ProductionBarChart extends StatelessWidget {
      final Machine data;
      const ProductionBarChart({super.key, required this.data});

      @override
      Widget build(BuildContext context) {
            final screenWidth = MediaQuery.of(context).size.width;
            final isSmallScreen = screenWidth < 600;

            final chart = BarChart(
                  BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: data.qtPlanifier.toDouble() + 5000,
                        titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, _) {
                                                switch (value.toInt()) {
                                                      case 0:
                                                            return const Text('Planned');
                                                      case 1:
                                                            return const Text('Good');
                                                      case 2:
                                                            return const Text('Rejected');
                                                      case 3:
                                                            return const Text('To Do');
                                                      default:
                                                            return const Text('');
                                                }
                                          },
                                    ),
                              ),
                              leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                              ),
                              rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                              ),
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
                                    barRods: data.toDo <= 0
                                        ? []
                                        : [
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
            );

            if (kIsWeb) {
                  // Web version
                  return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: chart,
                        ),
                  );
            } else {
                  // Android version (or other platforms)
                  return Center(
                        child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isSmallScreen ? double.infinity : 600),
                              child: Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: AspectRatio(
                                                aspectRatio: isSmallScreen ? 1 : 1.5,
                                                child: chart,
                                          ),
                                    ),
                              ),
                        ),
                  );
            }
      }
}
