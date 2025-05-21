import 'package:flutter/material.dart';
import '../../../models/machine.dart';
import 'stop_machine_card.dart';

class MachineGrid extends StatelessWidget {
  final List<String> machineTopics;
  final List<Machine> machines;

  const MachineGrid({
    required this.machineTopics,
    required this.machines,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double cardWidth = 400;
          int cardsPerRow = (screenWidth / cardWidth).floor().clamp(1, 4);

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: machineTopics.map((topic) {
              final machine = machines.firstWhere(
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
                  status: 'offline',
                  stop: false,
                ),
              );

              return SizedBox(
                width: (screenWidth - (cardsPerRow - 1) * 12) / cardsPerRow,
                child: StopMachineCard(machine: machine),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
