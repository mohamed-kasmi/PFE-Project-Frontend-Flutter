import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PlanificationPage extends StatefulWidget {
  @override
  _PlanificationPageState createState() => _PlanificationPageState();
}
class _PlanificationPageState extends State<PlanificationPage> {
  List<List<String>> rows = [];
  List<List<TextEditingController>> controllers = [];
  bool isLoading = false;
  int? editingRow;
  int? editingCol;
  Future<void> _pickFile() async {
    setState(() {
      isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result != null) {
        var bytes = result.files.single.bytes;
        if (bytes != null) {
          var excel = Excel.decodeBytes(Uint8List.fromList(bytes));
          var sheet = excel.tables.values.first;
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _resetData() {
    setState(() {
      rows.clear();
      controllers.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data reset successfully!')));
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
      appBar: AppBar(
        title: const Text('Planification', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildButtonRow(),
            const SizedBox(height: 20),
            rows.isNotEmpty
                ? _buildDataTable()
                : const Center(
                  child: Text(
                  'No data loaded. Please pick an Excel file.',
                    style: TextStyle(fontSize: 16),
                  ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(Icons.file_open, 'Pick File', _pickFile, Colors.blue),
        _actionButton(Icons.save_alt, 'Save', _saveData, Colors.green),
        _actionButton(Icons.refresh, 'Reset', _resetData, Colors.red),
      ],
    );
  }
  Widget _actionButton(IconData icon, String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  Widget _buildDataTable() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
            dataRowColor: MaterialStateProperty.all(Colors.blueGrey.shade50),
            columns: rows.isNotEmpty
                ? List.generate(
              rows[0].length,
                  (index) => DataColumn(
                label: Text(
                  rows[0][index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ): [],
            rows: List.generate(
              rows.length - 1,
                  (rowIndex) {
                final dataRow = rows[rowIndex + 1];
                return DataRow(
                  cells: List.generate(
                    dataRow.length,
                        (cellIndex) {
                      bool isEditing = editingRow == rowIndex && editingCol == cellIndex;
                      return DataCell(
                        isEditing
                            ? TextField(
                          autofocus: true,
                          controller: TextEditingController(text: dataRow[cellIndex]),
                          onSubmitted: (value) {
                            setState(() {
                              rows[rowIndex + 1][cellIndex] = value;
                              editingRow = null;
                              editingCol = null;
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              editingRow = null;
                              editingCol = null;
                            });
                          },
                        )
                            : GestureDetector(
                          onTap: () {
                            setState(() {
                              editingRow = rowIndex;
                              editingCol = cellIndex;
                            });
                          },
                          child: Text(
                            dataRow[cellIndex],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
