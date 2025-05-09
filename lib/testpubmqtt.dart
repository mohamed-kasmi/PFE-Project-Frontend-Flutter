import 'package:flutter/material.dart';
import 'dart:convert';
import 'mqtt/mqttservicepub.dart';

class MachineData {
  String machineName;
  String partNo;
  int quantity;
  MachineData({
    required this.machineName,
    required this.partNo,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'machineName': machineName,
      'partNo': partNo,
      'quantity': quantity,
    };
  }
}

class MqttPubPage extends StatefulWidget {
  @override
  _MqttPubPageState createState() => _MqttPubPageState();
}

class _MqttPubPageState extends State<MqttPubPage> {
  final TextEditingController machineNameController = TextEditingController();
  final TextEditingController partNoController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final mqttService = MqttPublisherService();

  @override
  void initState() {
    super.initState();
    _connectMqtt();
  }

  Future<void> _connectMqtt() async {
    await mqttService.connect();
  }

  void sendMessage() async {
    String machineName = machineNameController.text;
    String partNo = partNoController.text;
    int quantity = int.tryParse(quantityController.text) ?? 0;

    MachineData data = MachineData(
      machineName: machineName,
      partNo: partNo,
      quantity: quantity,
    );

    await mqttService.publishMessage('production/topic', data.toJson());
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MQTT Publisher')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: machineNameController,
              decoration: InputDecoration(labelText: 'Machine Name'),
            ),
            TextField(
              controller: partNoController,
              decoration: InputDecoration(labelText: 'Part No'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send Data to MQTT'),
            ),
          ],
        ),
      ),
    );
  }
}
