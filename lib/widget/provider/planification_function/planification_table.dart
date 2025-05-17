import 'package:flutter/material.dart';
import 'planification_textfield.dart';

class PlanificationTable extends StatelessWidget {
  final List<List<String>> table;
  final List<List<TextEditingController?>> controllers;
  final bool Function(String) isValidWorkCenter;
  final void Function() onChanged;

  const PlanificationTable({
    required this.table,
    required this.controllers,
    required this.isValidWorkCenter,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (table.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
                columns: List.generate(
                  table[0].length + 1,
                      (index) => DataColumn(
                    label: Text(
                      index == table[0].length ? 'Cycle Time' : table[0][index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                rows: List.generate(
                  table.length - 1,
                      (i) => DataRow(
                    cells: List.generate(
                      table[0].length + 1,
                          (j) {
                        if (j == table[0].length) {
                          double remainingHours = double.tryParse(table[i + 1][7]) ?? 0;
                          int remainingQty = int.tryParse(table[i + 1][3]) ?? 1;
                          double cycleTime = remainingQty != 0
                              ? ((remainingHours * 3600) / remainingQty)
                              : 0;
                          return DataCell(Text(
                            cycleTime.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 14),
                          ));
                        }

                        final controller = controllers[i + 1][j];
                        return controller != null
                            ? DataCell(PlanificationTextField(
                          controller: controller,
                          isValid: isValidWorkCenter(controller.text),
                          onChanged: onChanged,
                        ))
                            : DataCell(Text(
                          table[i + 1][j],
                          style: const TextStyle(fontSize: 14),
                        ));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
