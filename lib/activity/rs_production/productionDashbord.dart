import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../api/mqtt_service.dart';
import '../../models/production_data.dart';
import '../../widget/side_bar.dart';

class ProductionDashboard extends StatefulWidget {
  const ProductionDashboard({Key? key}) : super(key: key);

  @override
  _ProductionDashboardState createState() => _ProductionDashboardState();
}

class _ProductionDashboardState extends State<ProductionDashboard> {
  final MqttService _mqttService = MqttService();
  ProductionData? currentData;

  @override
  void initState() {
    super.initState();
    _mqttService.connect();
    _mqttService.stream.listen((data) {
      setState(() {
        currentData = data;
      });
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Production'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      drawer: SideBar(),

      body: currentData == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // TRS
              Text(
                'TRS en temps réel: ${(currentData!.trs).toStringAsFixed(1)}%',
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // BarChart + PieCharts
              Expanded(
                child: Row(
                  children: [
                    // Bar Chart
                    Expanded(child: _buildBarChart(currentData!)),

                    const SizedBox(width: 12),

                    // 2 Pie Charts in Column
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildPieChart(
                              'Production',
                              ['Bon', 'Rejet'],
                              [currentData!.bon.toDouble(), currentData!.reject.toDouble()],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _buildPieChart(
                              'Global',
                              ['Planifié', 'Fait'],
                              [currentData!.qtPlanifier.toDouble(), currentData!.total.toDouble()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Table Info
              _buildInfoTable(currentData!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(ProductionData data) {
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

  Widget _buildPieChart(String title, List<String> labels, List<double> values) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: List.generate(labels.length, (index) {
                    return PieChartSectionData(
                      color: Colors.primaries[index % Colors.primaries.length],
                      value: values[index],
                      title: '${labels[index]}\n${values[index].toStringAsFixed(0)}',
                      radius: 40,
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                    );
                  }),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(ProductionData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('TRS en temps réel', '${data.trs.toStringAsFixed(1)}%'),
            _buildTableRow('Temps', data.time),
            _buildTableRow('Cycle Time (s)', data.cycleTime.toStringAsFixed(2)),
            _buildTableRow('Total produit', data.total.toString()),
            _buildTableRow('À faire', data.toDo.toString()),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(label)),
      Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
    ]);
  }
}
