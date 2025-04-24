class ProDatabase {
  final String machineName;
  final int bon, reject, total, toDo, qtPlanifier;
  final double trs, cycleTime;
  final String time;
  final List<int> bonPerDay;

  ProDatabase({
    required this.machineName,
    required this.bon,
    required this.reject,
    required this.total,
    required this.toDo,
    required this.qtPlanifier,
    required this.trs,
    required this.time,
    required this.cycleTime,
    required this.bonPerDay,
  });
}
