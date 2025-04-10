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

  // Function to pick and load the Excel file
  Future<void> _pickFile() async {
    // Picking the Excel file
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      // Load the Excel file
      var bytes = result.files.single.bytes;
      if (bytes != null) {
        var excel = Excel.decodeBytes(Uint8List.fromList(bytes));
        var sheet = excel?.tables.values.first; // Get the first sheet

        // Get rows from the sheet and display them
        if (sheet != null) {
          setState(() {
            rows = [];
            controllers = []; // Reset the controllers

            for (var row in sheet.rows) {
              List<String> rowData = List<String>.from(row.map((cell) => cell?.value.toString() ?? ''));
              rows.add(rowData);

              // Create a controller for each cell in the row
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

  // Function to reset data to an empty state
  void _resetData() {
    setState(() {
      rows.clear();
      controllers.clear();
    });
  }

  // Function to save data back to Excel (You can modify this to save to your desired path)
  Future<void> _saveData() async {
    // You can implement saving logic here
    // For simplicity, we'll just save to a local directory
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    // Add data from rows to sheet
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
                            // For the first row, make the TextField non-editable
                            index == 0
                                ? Text(rows[index][cellIndex]) // Just display the text
                                : TextField(
                              controller: controllers[index][cellIndex], // Use unique controller for each cell
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
