import 'package:flutter/material.dart';
import '../../mqtt/machinestream.dart';
import '../../mqtt/mqttservice.dart';
import '../../models/machine.dart';
import '../../widget/side_bar.dart';
import '../../widget/provider/production_function/machine_grid.dart';
import '../../service/SharedPreferences/shared_pref_service.dart';
import '../../widget/notifications.dart';

class StopPage extends StatefulWidget {
  @override
  _StopPageState createState() => _StopPageState();
}

class _StopPageState extends State<StopPage> {
  String? userEmail;
  late MqttService _mqttService;
  List<Machine> _machines = [];

  final List<String> _machineTopics = ['misk01','misk02','bilher03'];

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService();
    _mqttService.machineStream.listen((data) {
      setState(() {
        _machines = data;
      });
    });
    _mqttService.SubscribeMsg();
    loadEmail();
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
      extendBodyBehindAppBar: true, // Extends the body behind the AppBar
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        title: const Text(
          "Stop",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (userEmail != null && userEmail!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: NotificationIcon(userEmail: userEmail!),
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MachineGrid(
                machineTopics: _machineTopics,
                machines: _machines,
              ),
            ),
          ),
        ],
      ),

    );
  }

}
