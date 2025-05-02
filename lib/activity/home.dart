import 'package:flutter/material.dart';
import '../mqtt/mqttservice.dart';
import '../widget/machinecard.dart';
import '../mqtt/machinestream.dart';
import '../models/machine.dart';
import '../widget/side_bar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MqttService _mqttService;
  List<Machine> _machines = [];

  final List<String> _machineTopics = ['testtopic', 'testtopic2', 'testtopic3'];

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService();

    _mqttService.machineStream.listen((data) {
      setState(() {
        _machines = data;
      });
    });

    _mqttService.connect();
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      drawer: SideBar(),
      appBar: AppBar(
        title: Text("Home",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(11),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double cardWidth = 400;
            int cardsPerRow = (screenWidth / cardWidth).floor().clamp(1, 4);
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _machineTopics.map((topic) {
                final machine = _machines.firstWhere(
                      (m) => m.topic == topic,
                  orElse: () => Machine(
                    topic: topic,
                    time: '',
                    qtPlanifier: 0,
                    bon: 0,
                    reject: 0,
                    toDo: 0,
                    total: 0,
                    oee: 0.0,
                    cycleTime: 0.0,
                  ),
                );

                return SizedBox(
                  width: (screenWidth - (cardsPerRow - 1) * 12) / cardsPerRow,
                  child: MachineCard(
                    machineName: topic.replaceAll("testtopic", "PRESS "),
                    machine: machine,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
