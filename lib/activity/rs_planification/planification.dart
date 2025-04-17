import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PlanificationPage extends StatefulWidget {
  @override
  _PlanificationPageState createState() => _PlanificationPageState();
}
class _PlanificationPageState extends State<PlanificationPage> {
  List<List<String>> rows = [];
  List<List<TextEditingController>> controllers = [];
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      var bytes = result.files.single.bytes;
      if (bytes != null) {
        var excel = Excel.decodeBytes(Uint8List.fromList(bytes));
        var sheet = excel?.tables.values.first;
        if (sheet != null) {
          setState(() {
            rows = [];
            controllers = [];
            for (var row in sheet.rows) {
              List<String> rowData = List<String>.from(row.map((cell) => cell?.value.toString() ?? ''));
              rows.add(rowData);
              List<TextEditingController> rowControllers = rowData.map((data) {
                return TextEditingController(text: data);
              }).toList();
              controllers.add(rowControllers);
            }
          });
        }
      }
    }
  }
  void _resetData() {
    setState(() {
      rows.clear();
      controllers.clear();
    });
  }
  Future<void> _saveData() async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];
    for (int i = 0; i < rows.length; i++) {
      sheet.appendRow(rows[i]);
    }
    final directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/modified_excel.xlsx';
    File(path)..writeAsBytesSync(excel.encode()!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved to $path')));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick Excel File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetData,
              child: Text('Reset Data'),
            ),
            SizedBox(height: 20),
            if (rows.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: rows.isNotEmpty
                        ? List.generate(rows[0].length, (index) => DataColumn(label: Text('')))
                        : [],
                    rows: List.generate(
                      rows.length,
                          (index) => DataRow(
                        cells: List.generate(
                          rows[index].length,
                              (cellIndex) => DataCell(
                            index == 0
                                ? Text(rows[index][cellIndex])
                                : TextField(
                              controller: controllers[index][cellIndex],
                              onChanged: (newValue) {
                                setState(() {
                                  rows[index][cellIndex] = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: rows[index][cellIndex],
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}