import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductionPage extends StatelessWidget {
  const ProductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Dashboard'),
        actions: [
          DropdownButton<String>(
            items: <String>['Period 1', 'Period 2'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            ListTile(title: Text('Dashboards')),
            ListTile(title: Text('Analytics')),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('TOTAL', '100%', Colors.green, '300'),
                _buildInfoCard('PREPARER', '30%', Colors.blue, '90'),
                _buildInfoCard('TO DO', '70%', Colors.yellow, '210'),
                _buildInfoCard('REJECT', '0%', Colors.red, '0'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, String badgeValue) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(title, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value, style: GoogleFonts.lato(fontSize: 24, color: color)),
            CircleAvatar(
              backgroundColor: color,
              radius: 12,
              child: Text(badgeValue,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Production Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 12,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('Day ${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    makeGroupData(0, 5, 2),
                    makeGroupData(1, 7, 2.5),
                    makeGroupData(2, 4, 2),
                    makeGroupData(3, 2, 1),
                    makeGroupData(4, 3.5, 2),
                    makeGroupData(5, 4, 2.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: y1 + y2,
          width: 20,
          color: Colors.green,
        ),
        BarChartRodData(
          fromY: 0,
          toY: 3,
          width: 20,
          color: Colors.blue,
        ),

        BarChartRodData(
          fromY: 0,
          toY: y1 +1,
          width: 20,
          color: Colors.yellow,
        ),
        BarChartRodData(
          fromY: 0,
          toY: 1,
          width: 20,
          color: Colors.red,
        ),
      ],
    );
  }
}
