import 'package:flutter/material.dart';
import '../../models/machinedata.dart';

class ProductionTableWidget extends StatelessWidget {
  final List<MachineData> data;

  const ProductionTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: [
            _buildTableHeader(),
            ...data.map((item) => _buildTableRow(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          _headerCell('Date'),
          _headerCell('Machine'),
          _headerCell('Part Number'),
          _headerCell('Run Hr'),
          _headerCell('Down Hr'),
          _headerCell('Good Qty'),
          _headerCell('Rejects'),
          _headerCell('Speed'),
          _headerCell('Avail. %'),
          _headerCell('Perf. %'),
          _headerCell('Quality %'),
          _headerCell('OEE %'),
        ],
      ),
    );
  }

  Widget _buildTableRow(MachineData item) {
    return Column(
      children: [
        Row(
          children: [
            _dataCell(item.dateInsertDay.toString().split(' ')[0]),
            _dataCell(item.machineName),
            _dataCell(item.partNO.toString()),
            _dataCell(item.runHoursDay.toStringAsFixed(2)),
            _dataCell(item.downHoursDay.toStringAsFixed(2)),
            _dataCell(item.goodQtyDay.toString()),
            _dataCell(item.rejectsQtyDay.toString()),
            _dataCell(item.speedDay.toStringAsFixed(2)),
            _dataCell('${(item.availabilityRateDay * 100).toStringAsFixed(1)}%'),
            _dataCell('${(item.performanceRateDay * 100).toStringAsFixed(1)}%'),
            _dataCell('${(item.qualityRateDay * 100).toStringAsFixed(1)}%'),
            _dataCell('${(item.oeeDay * 100).toStringAsFixed(1)}%'),
          ],
        ),
        Divider(height: 1, color: Colors.grey),
      ],
    );
  }

  Widget _headerCell(String text) => Container(
    width: 100,
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );

  Widget _dataCell(String text) => Container(
    width: 100,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}
