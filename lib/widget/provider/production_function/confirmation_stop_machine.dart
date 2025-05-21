import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import '../../../../models/machine.dart';
import '../../../mqtt/mqttservice.dart';
import 'dart:convert';

void showStopDialog(BuildContext context, Machine machine) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Arrêter ${machine.topic.replaceAll("testtopic", "PRESS ")}"),
      content: kIsWeb
          ? const Text("Voulez-vous arrêter cette machine ?") // Web version
          : LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 600 ? 400 : double.infinity,
            ),
            child: const Text("Do you want to stop this machine?"), // Android version
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            final payload = {
              "stop": true,
              "machine": machine.topic.replaceAll("testtopic", "misk01"),
            };
            MqttService().publishMsg(machine.topic, payload,false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Machine stopped")),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("STOP"),
        ),
      ],
    ),
  );
}
