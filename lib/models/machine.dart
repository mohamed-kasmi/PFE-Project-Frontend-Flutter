
class Machine {
  final String topic;
  final String time;
  final int qtPlanifier;
  final int bon;
  final int reject;
  final int toDo;
  final int total;
  final double oee;
  final double cycleTime;
  final String? status;

  Machine({
    required this.topic,
    required this.time,
    required this.qtPlanifier,
    required this.bon,
    required this.reject,
    required this.toDo,
    required this.total,
    required this.oee,
    required this.cycleTime,
    this.status,
  });

  factory Machine.fromJson(String topic, Map<String, dynamic> json) {
    return Machine(
      topic: topic,
      time: json['time'] ?? '',
      qtPlanifier: json['qtplanifier'] ?? 0,
      bon: json['bon'] ?? 0,
      reject: json['reject'] ?? 0,
      toDo: json['to_do'] ?? 0,
      total: json['total'] ?? 0,
      oee: (json['OEE'] ?? 0).toDouble(),
      cycleTime: (json['cycle_time'] ?? 0).toDouble(),
      status: json['status'],
    );
  }
}

