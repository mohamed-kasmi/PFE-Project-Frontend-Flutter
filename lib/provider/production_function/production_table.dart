import 'package:flutter/material.dart';

class ProductionTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ProductionTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          _buildTableHeader(),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => _buildTableRow(data[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          _headerCell('Date'),
          _headerCell('Quantity'),
          _headerCell('Efficiency'),
          _headerCell('Runtime'),
          _headerCell('Downtime'),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> item) {
    return Column(
      children: [
        Row(
          children: [
            _dataCell(item["date"]),
            _dataCell(item["quantity"].toString()),
            _dataCell("${item["efficiency"]}%"),
            _dataCell(item["runtime"].toString()),
            _dataCell(item["downtime"].toString()),
          ],
        ),
        Divider(height: 1, color: Colors.grey),
      ],
    );
  }

  Widget _headerCell(String text) => Expanded(
    child: Text(text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center),
  );

  Widget _dataCell(String text) => Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}