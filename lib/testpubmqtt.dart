import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_browser_client.dart'; // <-- Important for WebSocket
import 'package:mqtt_client/mqtt_client.dart';

// Define a model to hold machine data
class MachineData {
  String machineName;
  String partNo;
  int quantity;

  MachineData({required this.machineName, required this.partNo, required this.quantity});

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
  late MqttBrowserClient client;
  TextEditingController machineNameController = TextEditingController();
  TextEditingController partNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    client = MqttBrowserClient('ws://192.168.1.15:9001', 'flutter_pub_${DateTime.now().millisecondsSinceEpoch}');
    client.port = 9001;
    client.keepAlivePeriod = 20;
    client.logging(on: true);

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_pub_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    try {
      await client.connect();
    } catch (e) {
      print('Connection Exception: $e');
      client.disconnect();
    }
  }

  void onConnected() {
    print('✅ Connected to MQTT broker');
  }

  void onDisconnected() {
    print('⚠️ Disconnected from MQTT broker');
  }

  void sendMessage() {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      print('Client is not connected!');
      return;
    }

    String machineName = machineNameController.text;
    String partNo = partNoController.text;
    int quantity = int.tryParse(quantityController.text) ?? 0;

    MachineData data = MachineData(
      machineName: machineName,
      partNo: partNo,
      quantity: quantity,
    );

    String jsonMessage = data.toJson().toString();
    String topic = 'production/topic';

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonMessage);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('🚀 Message sent: $jsonMessage');
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTT Publisher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
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
