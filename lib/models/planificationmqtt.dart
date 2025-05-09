class PlanificationMqtt {
  final String shopOrderNo;
  final String partNo;
  final String remainingQty;
  final String plannedStartDate;
  final String plannedFinishDate;
  final String workCenter;
  final String remainingMFGHours;
  final String cycleTime;

  PlanificationMqtt({
    required this.shopOrderNo,
    required this.partNo,
    required this.remainingQty,
    required this.plannedStartDate,
    required this.plannedFinishDate,
    required this.workCenter,
    required this.remainingMFGHours,
    required this.cycleTime,
  });

  factory PlanificationMqtt.fromExcelRow(Map<String, String> row) {
    return PlanificationMqtt(
      shopOrderNo: row['Shop Order No'] ?? '',
      partNo: row['Part No'] ?? '',
      remainingQty: row['Remaining Qty'] ?? '',
      plannedStartDate: row['Planned Start Date'] ?? '',
      plannedFinishDate: row['Planned Finish Date'] ?? '',
      workCenter: row['Work Center'] ?? '',
      remainingMFGHours: row['Remaining Mfg Hours'] ?? '',
      cycleTime: row['Cycle Time'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Shop Order No': shopOrderNo,
      'Part No': partNo,
      'Remaining Qty': remainingQty,
      'Planned Start Date': plannedStartDate,
      'Planned Finish Date': plannedFinishDate,
      'Work Center': workCenter,
      'Remaining Mfg Hours': remainingMFGHours,
      'Cycle Time': cycleTime,
    };
  }

}
