import 'package:flutter/material.dart';
import '../../../models/machine.dart';
import '../../../widget/machinecard.dart';
import 'stop_dialog.dart';

class StopMachineCard extends StatelessWidget {
  final Machine machine;

  const StopMachineCard({required this.machine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showStopDialog(context, machine),
      child: MachineCard(
        machineName: machine.topic.replaceAll("testtopic", "PRESS "),
        machine: machine,
        isStopped: true,
      ),
    );
  }
}
