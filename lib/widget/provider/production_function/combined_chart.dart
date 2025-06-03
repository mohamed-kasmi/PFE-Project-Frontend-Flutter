import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/machinedata.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class CombinedChartWidget extends StatelessWidget {
  final List<MachineData> data;
  final double maxY;

  const CombinedChartWidget({
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
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white, // <-- white background
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _buildBarChart(),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBarChart() {
    Map<int, Color> partNoColors = {};
    List<Color> availableColors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.brown,
      Colors.indigo,
      Colors.cyan,
    ];
    int colorIndex = 0;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 8.0),
            child: Text(
              'Quantity & OEE Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: data.asMap().entries.map((entry) {
                  final item = entry.value;
                  final oee = item.oeeDay * 100;

                  if (!partNoColors.containsKey(item.partNO)) {
                    partNoColors[item.partNO] = availableColors[colorIndex % availableColors.length];
                    colorIndex++;
                  }
                  final barColor = partNoColors[item.partNO]!;

                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: item.goodQtyDay.toDouble(),
                        width: 18,
                        color: barColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                alignment: BarChartAlignment.spaceEvenly,
                minY: 0,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = data[group.x.toInt()];
                      final oee = (item.oeeDay * 100).toStringAsFixed(1);
                      final qty = item.goodQtyDay;
                      final partno = item.partNO;
                      return BarTooltipItem(
                        'OEE: $oee%\nQuantity: $qty\nPart Number: $partno',
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

