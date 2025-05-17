import 'package:flutter/material.dart';
import '../../../models/machine.dart';
import '../../../activity/rs_production/productionDashbord.dart';
import '../../../mqtt/mqttservice.dart';

void showStopDialog(BuildContext context, Machine machine) {
  final _mqttService = MqttService();

  // Optionally connect if necessary
  _mqttService.connect().then((_) {
    _mqttService.SubscribeMsg(); // if required
  });

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("STOP ${machine.topic.replaceAll("testtopic", "PRESS ")}"),
      content: Text("Do you want to stop this machine?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductionDashboard(machine: machine),
              ),
            );
          },
          child: Text("More Informations"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _mqttService.publishMsg(
              "testtopic/commande/${machine.topic}",
              {
                "command": "stop",
                "machine": machine.topic,
              },
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(" STOP command sent to ${machine.topic}")),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("STOP"),
        ),
      ],
    ),
  );
}
