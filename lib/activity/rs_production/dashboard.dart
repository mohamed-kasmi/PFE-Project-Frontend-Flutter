import 'package:flutter/material.dart';
import '../../provider/production_function/combined_chart.dart';
import '../../provider/production_function/runtime_chart.dart';
import '../../provider/production_function/production_table.dart';
import '../../provider/production_function/date_selector.dart';
import '../../provider/production_function/machine_dropdown.dart';
import '../../provider/production_function/granularitydropdownwidget.dart';
import '../../models/machinedata.dart';
import '../../api/apimachinedata.dart';
import '../../widget/side_bar.dart';
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedMachine;
  String? selectedGranularity;
  List<MachineData> machineDataList = [];
  List<String> machineList = [];
  List<String> granularityList = ['Day', 'Week', 'Month'];
  @override
  void initState() {
    super.initState();
    _fetchMachineNames();
  }
  void _selectDate(DateTime? date, bool isStartDate) {
    setState(() {
      if (isStartDate) {
        startDate = date;
      } else {
        endDate = date;
      }
    });
  }
  Future<void> _fetchMachineData() async {
    if (startDate != null && endDate != null && selectedMachine != null && selectedGranularity != null) {
      if (startDate!.isBefore(endDate!) ) {
        final formattedStart = startDate!.toIso8601String().substring(0, 10);
        final formattedEnd = endDate!.toIso8601String().substring(0, 10);
        final data = await Apimachinedata.getMachineByGranularity(
          formattedStart,
          formattedEnd,
          selectedMachine!,
          selectedGranularity!,
        );
        setState(() {
          machineDataList = data;
        });
        print("Fetched ${data.length} machine records.");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please insert a valid date range.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Select all before submitting.")),
      );
    }
  }
  Future<void> _fetchMachineNames() async {
    final names = await Apimachinedata.getMachineNames();
    setState(() {
      machineList = names;
    });
  }
  @override
  Widget build(BuildContext context) {
    final maxQuantity = machineDataList.isNotEmpty
        ? machineDataList.map((e) => e.goodQtyDay + 10000).reduce((a, b) => a > b ? a : b).toDouble() : 0.0;
    final maxRuntime = machineDataList.isNotEmpty
        ? machineDataList.map((e) => e.runHoursDay + e.downHoursDay).reduce((a, b) => a > b ? a : b) : 0.0;
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text("Production Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                return isMobile
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateSelectorWidget(
                          startDate: startDate,
                          endDate: endDate,
                          onDateSelected: (date, isStartDate) => _selectDate(date, isStartDate),
                        ),
                        SizedBox(height: 10),
                        MachineDropdownWidget(
                          machineList: machineList,
                          selectedMachine: selectedMachine,
                          onChanged: (value) => setState(() => selectedMachine = value),
                        ),
                        SizedBox(height: 10),
                        GranularityDropdownWidget(
                          granularityOptions: granularityList,
                          selectedGranularity: selectedGranularity,
                          onChanged: (value) => setState(() => selectedGranularity = value),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _fetchMachineData,
                          child: Text("Submit"),
                        ),
                      ],
                    )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DateSelectorWidget(
                              startDate: startDate,
                              endDate: endDate,
                              onDateSelected: (date, isStartDate) => _selectDate(date, isStartDate),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: MachineDropdownWidget(
                              machineList: machineList,
                              selectedMachine: selectedMachine,
                              onChanged: (value) => setState(() => selectedMachine = value),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GranularityDropdownWidget(
                              granularityOptions: granularityList,
                              selectedGranularity: selectedGranularity,
                              onChanged: (value) => setState(() => selectedGranularity = value),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _fetchMachineData,
                              child: Text("Submit"),
                            ),
                          ),
                        ],
                      );
              },
            ),
            machineDataList.isNotEmpty
                ? Column(
                  children: [
                      SizedBox(height: 30),
                      CombinedChartWidget(data: machineDataList, maxY: maxQuantity),
                      SizedBox(height: 30),
                      RuntimeChartWidget(data: machineDataList, maxY: maxRuntime),
                      SizedBox(height: 30),
                      ProductionTableWidget(data: machineDataList),
                    ],
                )
                : Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      "Submit your search.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}