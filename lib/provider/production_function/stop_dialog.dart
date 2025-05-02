import 'package:flutter/material.dart';
import '../../../models/machine.dart';
import '../../activity/rs_production/productionDashbord.dart';

void showStopDialog(BuildContext context, Machine machine) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Arrêter ${machine.topic.replaceAll("testtopic", "PRESS ")}"),
      content: Text("Voulez-vous arrêter cette machine ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Annuler"),
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
          child: Text("plus detaille"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Machine arrêtée")),
            );
            // Add stop logic here if needed
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("STOP"),
        ),
      ],
    ),
  );
}
