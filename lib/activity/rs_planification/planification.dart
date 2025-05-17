import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import '../../models/planificationData.dart';
import '../../api/planificationApi.dart';
import '../../widget/provider/planification_function/planification_buttons.dart';
import '../../widget/provider/planification_function/planification_table.dart';
import '../../widget/side_bar.dart';
import '../../mqtt/mqttservice.dart';
import '../../models/planificationmqtt.dart';
import '../../service/storage_permission.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';


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
    'Part Description',
    'Revised Order Qty',
    'Remaining Qty',
    'Planned Start Date',
    'Planned Finish Date',
    'Work Center',
    'Remaining Mfg Hours',
    'Cycle Time',
  ];

  bool _isValidWorkCenter(String value) {
    final regex = RegExp(r'^[A-Z][0-9]{2}$');
    return regex.hasMatch(value);
  }

  Future<void> _pickFile() async {
    setState(() => isLoading = true);
    try {
      if (!kIsWeb && !(await requestStoragePermission())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission denied!")),
        );
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true, // ensures we get file.bytes on Web and some Android cases
      );

      if (result != null) {
        Uint8List? fileBytes;

        // ✅ Handle web or Android
        if (kIsWeb) {
          fileBytes = result.files.single.bytes;
        } else if (result.files.single.path != null) {
          final filePath = result.files.single.path!;
          fileBytes = await File(filePath).readAsBytes();
        }

        if (fileBytes == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to read file bytes")),
          );
          return;
        }

        var excel = Excel.decodeBytes(fileBytes);
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
    } catch (e) {
      debugPrint("Error reading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading file: $e")),
      );
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

  Future<void> _saveRows() async {
    if (table.length <= 1) return;

    List<String> headers = table.first;
    List<PlanificationData> dataList = [];

    for (int i = 1; i < table.length; i++) {
      Map<String, String> rowMap = {};
      for (int j = 0; j < headers.length; j++) {
        rowMap[headers[j]] = controllers[i][j]?.text ?? table[i][j];
      }

      String workCenter = rowMap['Work Center'] ?? '';
      if (!_isValidWorkCenter(workCenter)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid Work Center in row ${i}: must be 1 letter + 2 digits")),
        );
        return;
      }

      try {
        double remainingHours = double.tryParse(rowMap['Remaining Mfg Hours'] ?? '') ?? 0;
        int remainingQty = int.tryParse(rowMap['Remaining Qty'] ?? '') ?? 1;
        double cycleTime = remainingQty != 0 ? ((remainingHours * 3600) / remainingQty) : 0;

        final data = PlanificationData(
          workcenter: workCenter,
          shopOrderNo: int.tryParse(rowMap['Shop Order No'] ?? '') ?? 0,
          partNo: rowMap['Part No'] ?? '',
          startDate: DateTime.tryParse(rowMap['Planned Start Date'] ?? '') ?? DateTime.now(),
          finishDate: DateTime.tryParse(rowMap['Planned Finish Date'] ?? '') ?? DateTime.now(),
          orderQty: int.tryParse(rowMap['Revised Order Qty'] ?? '') ?? 0,
          remainQty: remainingQty,
          remainingHours: remainingHours,
          cycleTime: double.parse(cycleTime.toStringAsFixed(3)),
        );
        dataList.add(data);
      } catch (e) {
        debugPrint("Invalid row $i: $e");
      }
    }

    try {
      bool result = await PlanificationApi.sendPlanifications(dataList);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ? "All rows sent to backend" : "Failed to send data")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending data: $e")),
      );
    }
  }

  Future<void> _publishRows() async {
    if (table.length <= 1) return;

    List<String> headers = table.first;
    Map<String, List<PlanificationMqtt>> machineDataMap = {};

    for (int i = 1; i < table.length; i++) {
      Map<String, String> rowMap = {};

      for (int j = 0; j < headers.length; j++) {
        rowMap[headers[j]] = controllers[i][j]?.text ?? table[i][j];
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

      List<Map<String, dynamic>> jsonList = dataList.map((model) => model.toJson()).toList();
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
      backgroundColor: Colors.blue[900],
      drawer: SideBar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        title: const Text(
          'Planification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
            opacity: 1,
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFE0ECFF), Color(0xFFBBD3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: PlanificationButtons(
                      onPickFile: _pickFile,
                      onReset: _resetTable,
                      onSave: _saveRows,
                      onPublish: _publishRows,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: PlanificationTable(
                        table: table,
                        controllers: controllers,
                        isValidWorkCenter: _isValidWorkCenter,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
