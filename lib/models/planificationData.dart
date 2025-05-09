class PlanificationData {
  final String workcenter;
  final int shopOrderNo;
  final String partNo;
  final DateTime startDate;
  final DateTime finishDate;
  final int orderQty;
  final int remainQty;
  final double remainingHours;
  final double cycleTime;

  PlanificationData({
    required this.workcenter,
    required this.shopOrderNo,
    required this.partNo,
    required this.startDate,
    required this.finishDate,
    required this.orderQty,
    required this.remainQty,
    required this.remainingHours,
    required this.cycleTime,
  });

  factory PlanificationData.fromJson(Map<String, dynamic> json) {
    return PlanificationData(
      workcenter: json['Work_Center'],
      shopOrderNo: json['Shop_Order_NO'],
      partNo: json['Part_NO'],
      startDate: DateTime.parse(json['Start_Date']),
      finishDate: DateTime.parse(json['Finish_Date']),
      orderQty: json['Order_Qty'],
      remainQty: json['Remain_Qty'],
      remainingHours:json['Remaining_Hours'],
      cycleTime: json['Cycle_Time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Work_Center': workcenter,
      'Shop_Order_NO': shopOrderNo,
      'Part_NO': partNo,
      'Start_Date': startDate.toIso8601String(),
      'Finish_Date': finishDate.toIso8601String(),
      'Order_Qty': orderQty,
      'Remain_Qty': remainQty,
      'Remaining_Hours': remainingHours,
      'Cycle_Time': cycleTime,
    };
  }
}
