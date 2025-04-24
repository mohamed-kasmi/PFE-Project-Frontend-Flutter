import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../provider/production_function/combined_chart.dart';
import '../../provider/production_function/runtime_chart.dart';
import '../../provider/production_function/production_table.dart';
import '../../provider/production_function/date_selector.dart';
import '../../provider/production_function/machine_dropdown.dart';

class TrsPage extends StatefulWidget {
  @override
  _TrsPageState createState() => _TrsPageState();
}

class _TrsPageState extends State<TrsPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedMachine;
  List<String> machineList = ['Machine 1', 'Machine 2', 'Machine 3', 'Machine 4'];

  final List<Map<String, dynamic>> productionData = List.generate(30, (index) {
    return {
      "date": "2024-05-${(index + 1).toString().padLeft(2, '0')}",
      "quantity": 50 + (index % 12) * 6,
      "efficiency": 78 + (index % 5) * 4,
      "runtime": (index % 9 + 1).toDouble(),
      "downtime": 9 - (index % 9 + 1).toDouble(),
    };
  });

  @override
  Widget build(BuildContext context) {
    final maxQuantity = productionData.map((e) => e["quantity"] as int).reduce((a, b) => a > b ? a : b).toDouble();
    final maxRuntime = productionData.map((e) => (e["runtime"] + e["downtime"])).reduce((a, b) => a > b ? a : b).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DateSelectorWidget(
              startDate: startDate,
              endDate: endDate,
              onDateSelected: (date, isStartDate) => _selectDate(date, isStartDate),
            ),
            SizedBox(height: 20),
            MachineDropdownWidget(
              machineList: machineList,
              selectedMachine: selectedMachine,
              onChanged: (value) => setState(() => selectedMachine = value),
            ),
            SizedBox(height: 30),
            CombinedChartWidget(data: productionData, maxY: maxQuantity),
            SizedBox(height: 30),
            ProductionTableWidget(data: productionData),
            SizedBox(height: 30),
            RuntimeChartWidget(productionData: productionData, maxY: maxRuntime), // New runtime chart
          ],
        ),
      ),
    );
  }

  void _selectDate(DateTime? date, bool isStartDate) {
    setState(() => isStartDate ? startDate = date : endDate = date);
  }
}
