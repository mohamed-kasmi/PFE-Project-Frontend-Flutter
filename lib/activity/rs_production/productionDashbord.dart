import 'package:flutter/material.dart';
import 'package:pdcs_frontend/activity/rs_production/Stop.dart';
import '../../service/SharedPreferences/shared_pref_service.dart';
import '../../widget/notifications.dart';
import '../../widget/side_bar.dart';
import '../../widget/provider/production_function/production_bar_chart.dart';
import '../../widget/provider/production_function/production_pie_chart.dart';
import '../../widget/provider/production_function/trs_gauge_widget.dart';
import '../../widget/provider/production_function/info_table_widget.dart';
import '../../widget/provider/production_function/stop_button_widget.dart';
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
  String? userEmail;
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
      loadEmail();
    });

    _mqttService.SubscribeMsg();
  }
  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }
  Future<void> loadEmail() async {
    final email = await SharedPrefService.getEmail();
    if (email != null && email.isNotEmpty) {
      setState(() {
        userEmail = email;
      });
    }
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
        actions:[
          if (userEmail != null && userEmail!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: NotificationIcon(userEmail: userEmail!),
            ),
        ],
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
              Expanded(  // ✅ This is the key fix
                child: _buildMainContent(),
              ),
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
        'Real-time OEE: ${(_currentMachine!.oee).toStringAsFixed(1)}%',
          style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
    );
  }
  Widget _buildMainContent() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;
          if (isWide) {
            // Desktop or Tablet Layout
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ProductionBarChart(data: _currentMachine!),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildRightPanel(),
                ),
              ],
            );
          } else {
            // Mobile Layout (Vertical Stack)
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProductionBarChart(data: _currentMachine!),
                  const SizedBox(height: 16),
                  _buildRightPanel(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  Widget _buildRightPanel() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProductionPieChart(
                title: 'Production',
                labels: ['Good', 'Rejected'],
                values: [
                  ((_currentMachine!.bon /
                      (_currentMachine!.bon + _currentMachine!.reject)) *
                      100)
                      .toDouble(),
                  ((_currentMachine!.reject /
                      (_currentMachine!.bon + _currentMachine!.reject)) *
                      100)
                      .toDouble(),
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
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StopButtonWidget(
              onPressed: () => _showStopConfirmationDialog(),
            ),
          ],
        ),
      ],
    );
  }
  void _showStopConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to stop?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _mqttService.publishMsg(
                  "testtopic/commande/${_currentMachine!.topic}",
                  {
                    "command": "stop",
                    "machine": _currentMachine!.topic,
                  },
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StopPage(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('STOP command sent')),
                );
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
