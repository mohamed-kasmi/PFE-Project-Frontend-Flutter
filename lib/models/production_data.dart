class ProductionData {
  final String time;
  final int qtPlanifier;
  final int bon;
  final int reject;
  final int toDo;
  final int total;
  final double trs;
  final double cycleTime;

  ProductionData({
    required this.time,
    required this.qtPlanifier,
    required this.bon,
    required this.reject,
    required this.toDo,
    required this.total,
    required this.trs,
    required this.cycleTime,
  });

  factory ProductionData.fromJson(Map<String, dynamic> json) {
    return ProductionData(
      time: json['time'],
      qtPlanifier: json['qtplanifier'],
      bon: json['bon'],
      reject: json['reject'],
      toDo: json['to_do'],
      total: json['total'],
      trs: json['TRS'].toDouble(),
      cycleTime: json['cycle_time'].toDouble(),
    );
  }
}
