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
      backgroundColor: Colors.blue[900],
      drawer: SideBar(),
      appBar: AppBar(
        title: Text("Stop", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions:[
          if (userEmail != null && userEmail!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: NotificationIcon(userEmail: userEmail!),
            ),
        ],
      ),
      body: MachineGrid(machineTopics: _machineTopics, machines: _machines),
    );
  }
}
