import 'package:flutter/material.dart';
import '../../widget/side_bar.dart';
import '../../wide/production_bar_chart.dart';
import '../../wide/production_pie_chart.dart';
import '../../wide/trs_gauge_widget.dart';
import '../../wide/info_table_widget.dart';
import '../../wide/stop_button_widget.dart';
import '../../mqtt/mqttservice.dart';
import '../../mqtt/machinestream.dart';
import '../../models/machine.dart';




class ProductionDashboard extends StatefulWidget {
  final Machine machine;
  ProductionDashboard({Key? key, required this.machine}) : super(key: key);
  @override
  _ProductionDashboardState createState() => _ProductionDashboardState();
}
class _ProductionDashboardState extends State<ProductionDashboard> {
  late MqttService _mqttService;
  Machine? _currentMachine;
  @override
  void initState() {
    super.initState();
    _mqttService = MqttService();
    _mqttService.connect();
    _mqttService.machineStream.listen((machines) {
      final updatedMachine = machines.firstWhere(
            (m) => m.topic == widget.machine.topic,
        orElse: () => widget.machine,
      );
      setState(() {
        _currentMachine = updatedMachine;
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
        title: _currentMachine == null
            ? const Text('Loading...')
            : Text('Dashboard Production for ${_currentMachine!.topic}'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      drawer: SideBar(),
      body: _currentMachine == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                  ),
                ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildMainContent(),
                    const SizedBox(height: 16),
                    _buildFooter(),
                ],
              ),
            ),
          ),
       );
  }
  Widget _buildHeader() {
    return Text(
        'TRS en temps réel: ${(_currentMachine!.oee).toStringAsFixed(1)}%',
          style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
    );
  }
  Widget _buildMainContent() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ProductionBarChart(
              data: _currentMachine!,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ProductionPieChart(
                        title: 'Production',
                        labels: ['Bon', 'Rejet'],
                        values: [
                          ((_currentMachine!.bon/_currentMachine!.qtPlanifier)*100).toDouble(),
                          ((_currentMachine!.reject/_currentMachine!.qtPlanifier)*100).toDouble(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TRSGaugeWidget(
                        trsValue: _currentMachine!.oee,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StopButtonWidget(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text('Are you sure you want to stop?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFooter() {
    return Column(
      children: [
        InfoTableWidget(data: _currentMachine!),
        const SizedBox(height: 20),
      ],
    );
  }
}
