import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import '../../mqtt/mqttservice.dart';
import '../../models/planificationmqtt.dart';

class PlanificationPage extends StatefulWidget {
  @override
  _PlanificationPageState createState() => _PlanificationPageState();
}

class _PlanificationPageState extends State<PlanificationPage> {
  List<List<String>> table = [];
  List<List<TextEditingController?>> controllers = [];
  bool isLoading = false;

  final List<String> targetHeaders = [
    'Shop Order No',
    'Part No',
    'Remaining Qty',
    'Planned Start Date',
    'Planned Finish Date',
    'Work Center',
    'Remaining Mfg Hours',
    'Cycle Time',
  ];

  Future<void> _pickFile() async {
    setState(() => isLoading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null && result.files.single.bytes != null) {
        var bytes = result.files.single.bytes!;
        var excel = Excel.decodeBytes(Uint8List.fromList(bytes));
        var sheet = excel.tables.values.first;

        List<int> selectedColumns = [0, 3, 6, 7, 8, 9, 10, 13];
        int editableColumnIndex = 6;

        List<List<String>> tempTable = [];
        List<List<TextEditingController?>> tempControllers = [];

        for (var row in sheet.rows) {
          List<String> rowData = selectedColumns
              .map((index) => index < row.length ? row[index]?.value.toString() ?? '' : '')
              .toList();
          tempTable.add(rowData);

          tempControllers.add(List.generate(
            rowData.length,
                (index) => index == editableColumnIndex ? TextEditingController(text: rowData[index]) : null,
          ));
        }

        setState(() {
          table = tempTable;
          controllers = tempControllers;
        });
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _resetTable() {
    setState(() {
      table.clear();
      controllers.clear();
    });
  }

  Future<void> _publishRows() async {
    if (table.length <= 1) return;

    List<String> headers = table.first;
    Map<String, List<PlanificationMqtt>> machineDataMap = {};

    for (int i = 1; i < table.length; i++) {
      Map<String, String> rowMap = {};

      for (String key in targetHeaders) {
        int index = headers.indexOf(key);
        if (index != -1 && index < table[i].length) {
          if (index == 6 && i < controllers.length && index < controllers[i].length && controllers[i][index] != null) {
            rowMap[key] = controllers[i][index]!.text;
          } else {
            rowMap[key] = table[i][index];
          }
        }
      }
      double remainingHours = double.tryParse(rowMap['Remaining Mfg Hours'] ?? '') ?? 0;
      int remainingQty = int.tryParse(rowMap['Remaining Qty'] ?? '') ?? 1;
      double cycleTime = remainingQty != 0 ? ((remainingHours * 3600) / remainingQty) : 0;
      rowMap['Cycle Time'] = cycleTime.toStringAsFixed(2);

      String? workCenter = rowMap['Work Center'];
      if (workCenter != null && workCenter.isNotEmpty) {
        final model = PlanificationMqtt.fromExcelRow(rowMap);
        machineDataMap.putIfAbsent(workCenter, () => []);
        machineDataMap[workCenter]!.add(model);
      }
    }

    for (final entry in machineDataMap.entries) {
      final topic = entry.key;
      final dataList = entry.value;

      List<Map<String, dynamic>> jsonList =
      dataList.map((model) => model.toJson()).toList();
      await MqttService().publishMsg(topic, jsonList);
      print('Published ${dataList.length} rows to $topic');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All rows published grouped by Work Center")),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planification', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _button(Icons.file_open, "Pick File", _pickFile, Colors.blue),
                _button(Icons.refresh, "Reset", _resetTable, Colors.red),
                _button(Icons.save, "Save (N/A)", () {}, Colors.grey),
                _button(Icons.send, "Publish", _publishRows, Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    if (table.isEmpty) {
      return const Center(child: Text("No file selected."));
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: List.generate(
              table[0].length + 1, // Adding one extra column for Cycle Time
                  (index) {
                if (index == table[0].length) {
                  return const DataColumn(
                    label: Text(
                      'Cycle Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return DataColumn(
                  label: Text(
                    table[0][index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
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
                      double cycleTime = remainingQty != 0 ? ((remainingHours * 3600) / remainingQty) : 0;

                      return DataCell(
                        Text(
                          cycleTime.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }

                    final controller = controllers[i + 1][j];
                    final isEditable = controller != null;

                    return DataCell(
                      isEditable
                          ? TextField(
                        controller: controller,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(border: InputBorder.none),
                      )
                          : Text(
                        table[i + 1][j],
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(IconData icon, String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
