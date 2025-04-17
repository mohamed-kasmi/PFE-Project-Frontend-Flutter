import 'package:flutter/material.dart';

Widget buildDataContent() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columns: const [
        DataColumn(label: Text('Machine')),
        DataColumn(label: Text('Date d\'invent')),
        DataColumn(label: Text('Shift')),
        DataColumn(label: Text('Heures de Production')),
        DataColumn(label: Text('Arrêt')),
        DataColumn(label: Text('Qte Bonne')),
        DataColumn(label: Text('Qte Rejetée')),
      ],
      rows: List<DataRow>.generate(
        6,
            (index) => DataRow(
          cells: <DataCell>[
            DataCell(Text('Machine PS0${index + 1}')),
            DataCell(Text('17/10/2023')),
            DataCell(Text('Shift 1')),
            DataCell(Text('7.67')),
            DataCell(Text('0')),
            DataCell(Text('9.47')),
            DataCell(Text('0.5')),
          ],
        ),
      ),
    ),
  );
}
