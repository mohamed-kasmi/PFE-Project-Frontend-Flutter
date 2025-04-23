class MachineData {
  final int id;
  final String machineName;
  final DateTime dateInsertDay;
  final double runHoursDay;
  final double downHoursDay;
  final int goodQtyDay;
  final int rejectsQtyDay;
  final double speedDay;
  final double availabilityRateDay;
  final double performanceRateDay;
  final double qualityRateDay;
  final double oeeDay;

  MachineData({
    required this.id,
    required this.machineName,
    required this.dateInsertDay,
    required this.runHoursDay,
    required this.downHoursDay,
    required this.goodQtyDay,
    required this.rejectsQtyDay,
    required this.speedDay,
    required this.availabilityRateDay,
    required this.performanceRateDay,
    required this.qualityRateDay,
    required this.oeeDay,
  });

  factory MachineData.fromJson(Map<String, dynamic> json) {
    return MachineData(
      id: json['id'],
      machineName: json['Machine_Name'],
      dateInsertDay: DateTime.parse(json['Date_Insert_Day']),
      runHoursDay: json['Run_Hours_Day'].toDouble(),
      downHoursDay: json['Down_Hours_Day'].toDouble(),
      goodQtyDay: json['Good_QTY_Day'],
      rejectsQtyDay: json['Rejects_QTY_Day'],
      speedDay: json['Speed_Day'].toDouble(),
      availabilityRateDay: json['Availability_Rate_Day'].toDouble(),
      performanceRateDay: json['Performance_Rate_Day'].toDouble(),
      qualityRateDay: json['Quality_Rate_Day'].toDouble(),
      oeeDay: json['OEE_Day'].toDouble(),
    );
  }
}