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
      }else if(machine.bon >= machine.qtPlanifier){
        progressStatus = "Overload";
      }
      else {
        progressStatus = "Running";
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double scaleFactor = constraints.maxWidth / 400;
              double titleFontSize = 16 * scaleFactor.clamp(0.8, 1.2);
              double valueFontSize = 16 * scaleFactor.clamp(0.8, 1.4);
              double labelFontSize = 10 * scaleFactor.clamp(0.8, 1.2);
              double circleRadius = 70 * scaleFactor.clamp(0.8, 1.5);
              double circleLineWidth = 10.0 * scaleFactor.clamp(0.8, 1.5);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
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
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Status: ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'Offline',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
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
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Progress: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: progressStatus,
                                  style: TextStyle(
                                    color: progressStatus == "Done"
                                        ? Colors.green
                                        : progressStatus == "Running"
                                        ? Colors.blue
                                        : progressStatus == "Overload"
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: machine.status ?? 'null',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    flex: 4,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildStat("Planned Quantity", machine.qtPlanifier.toString(), Colors.black, valueFontSize, labelFontSize),
                        _buildStat("Good Quantity", machine.bon.toString(), Colors.blue, valueFontSize, labelFontSize),
                        _buildStat("Remaining Quantity", machine.toDo.toString(), Colors.indigo, valueFontSize, labelFontSize),
                        _buildStat("Rejected Quantity", machine.reject.toString(), Colors.red, valueFontSize, labelFontSize),
                        _buildStat("OEE", "${machine.oee.toStringAsFixed(0)}%", Colors.purple, valueFontSize, labelFontSize),
                        _buildStat("Part number", "0", Colors.grey, valueFontSize, labelFontSize),
                        _buildStat("Shift Supervisor", "-", Colors.grey, valueFontSize, labelFontSize),
                        _buildStat("Work Order", "0", Colors.grey, valueFontSize, labelFontSize),
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
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 160),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
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
