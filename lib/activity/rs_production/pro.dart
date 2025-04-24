import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/pro_database.dart';
import '../../widget/side_bar.dart';
import 'productionDashbord.dart';
class ProDashboard extends StatefulWidget {
  const ProDashboard({super.key});

  @override
  State<ProDashboard> createState() => _ProDashboardState();
}

class _ProDashboardState extends State<ProDashboard> {
  // Fake data
  final List<ProDatabase> machines = [
    ProDatabase(
      machineName: 'Machine 1',
      bon: 80,
      reject: 10,
      total: 90,
      toDo: 10,
      qtPlanifier: 100,
      trs: 90,
      time: '15:01',
      cycleTime: 3.2,
      bonPerDay: [10, 15, 12, 13, 10, 8, 12],
    ),
    ProDatabase(
      machineName: 'Machine 2',
      bon: 60,
      reject: 20,
      total: 80,
      toDo: 20,
      qtPlanifier: 100,
      trs: 80,
      time: '10:01',
      cycleTime: 1.3,
      bonPerDay: [5, 10, 8, 12, 9, 7, 9],
    ),
    ProDatabase(
      machineName: 'Machine 3',
      bon: 50,
      reject: 30,
      total: 80,
      toDo: 20,
      qtPlanifier: 100,
      trs: 70,
      time: '12:03',
      cycleTime: 2.0,
      bonPerDay: [6, 7, 9, 10, 8, 4, 6],
    ),
  ];

  ProDatabase? selectedMachine;

  @override
  void initState() {
    super.initState();
    selectedMachine = machines.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Pro',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      drawer: SideBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Text(
                  'Données des machines',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 3,
                  child: selectedMachine == null
                      ? const Center(child: Text('Aucune machine sélectionnée'))
                      : _buildCharts(selectedMachine!),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Action')), // New column
                            DataColumn(label: Text('Machine')),
                            DataColumn(label: Text('TRS')),
                            DataColumn(label: Text('Bon')),
                            DataColumn(label: Text('Rejet')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('À faire')),
                            DataColumn(label: Text('Planifié')),
                          ],
                          rows: machines.map((pro) {
                            return DataRow(
                              selected: selectedMachine == pro,
                              onSelectChanged: (_) {
                                setState(() {
                                  selectedMachine = pro;
                                });
                              },
                              cells: [
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ProductionDashboard(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                    child: const Text('Show Real Time Data'),
                                  ),
                                ),
                                DataCell(Text(pro.machineName)),
                                DataCell(Text('${pro.trs.toStringAsFixed(1)}%')),
                                DataCell(Text(pro.bon.toString())),
                                DataCell(Text(pro.reject.toString())),
                                DataCell(Text(pro.total.toString())),
                                DataCell(Text(pro.toDo.toString())),
                                DataCell(Text(pro.qtPlanifier.toString())),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharts(ProDatabase data) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildBarChart(data),
        ),
        const SizedBox(height: 16),
        Expanded(
          flex: 1,
          child: _buildLineChart(data),
        ),
      ],
    );
  }

  Widget _buildBarChart(ProDatabase data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: data.qtPlanifier.toDouble() + 10,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
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
                }),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: data.qtPlanifier.toDouble(), color: Colors.orange, width: 14)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: data.bon.toDouble(), color: Colors.green, width: 14)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: data.reject.toDouble(), color: Colors.red, width: 14)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: data.toDo.toDouble(), color: Colors.blue, width: 14)]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(ProDatabase data) {
    final List<FlSpot> spots = List.generate(
      data.bonPerDay.length,
          (index) => FlSpot(index.toDouble(), data.bonPerDay[index].toDouble()),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                    final dayIndex = value.toInt();
                    if (dayIndex >= 0 && dayIndex < days.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(days[dayIndex]),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: (data.bonPerDay.reduce((a, b) => a > b ? a : b)).toDouble() + 5,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                color: Colors.blue,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
