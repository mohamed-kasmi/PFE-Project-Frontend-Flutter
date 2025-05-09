import 'package:flutter/material.dart';
import '../models/machine.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MachineCard extends StatelessWidget {
  final String machineName;
  final Machine machine;
  final bool isStopped;

  const MachineCard({
    Key? key,
    required this.machineName,
    required this.machine,
    this.isStopped = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = machine.qtPlanifier > 0 ? machine.bon / machine.qtPlanifier : 0.0;

    String progressStatus = "Stopped";
    if (machine.bon > 0 && machine.qtPlanifier > 0) {
      if (machine.bon == machine.qtPlanifier) {
        progressStatus = "Done";
      } else {
        progressStatus = "Running";
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 400;

    double titleFontSize = 16 * scaleFactor.clamp(0.8, 1.2);
    double valueFontSize = 16 * scaleFactor.clamp(0.8, 1.4);
    double labelFontSize = 10 * scaleFactor.clamp(0.8, 1.2);
    double circleRadius = 50 * scaleFactor.clamp(0.8, 1.5);
    double circleLineWidth = 8.0 * scaleFactor.clamp(0.8, 1.5);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          machineName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (machine.status == 'offline') ...[
                        Text(
                          'Current machine is offline',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ] else ...[
                        CircularPercentIndicator(
                          radius: circleRadius,
                          lineWidth: circleLineWidth,
                          animation: true,
                          percent: progress.clamp(0.0, 1.0),
                          center: Text(
                            "${(progress * 100).toStringAsFixed(0)}%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.blue,
                          backgroundColor: Colors.grey[300]!,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Progress: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: progressStatus,
                                  style: TextStyle(
                                    color: progressStatus == "Done"
                                        ? Colors.green
                                        : progressStatus == "Running"
                                        ? Colors.blue
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          machine.status ?? 'null',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat("Quantité Planifiée", machine.qtPlanifier.toString(), Colors.black, valueFontSize, labelFontSize),
                            _buildStat("Quantité Bonne", machine.bon.toString(), Colors.blue, valueFontSize, labelFontSize),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat("Quantité Restante", machine.toDo.toString(), Colors.indigo, valueFontSize, labelFontSize),
                            _buildStat("Quantité Rejetée", machine.reject.toString(), Colors.red, valueFontSize, labelFontSize),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat("TRS", "${machine.oee.toStringAsFixed(0)}%", Colors.purple, valueFontSize, labelFontSize),
                            _buildStat("Part number", "0", Colors.grey, valueFontSize, labelFontSize),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat("Chef de post", "-", Colors.grey, valueFontSize, labelFontSize),
                            _buildStat("Ordre de Fabrication", "0", Colors.grey, valueFontSize, labelFontSize),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color, double valueFontSize, double labelFontSize) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: valueFontSize,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
