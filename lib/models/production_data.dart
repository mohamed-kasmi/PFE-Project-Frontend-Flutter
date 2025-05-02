class ProductionData {
  final String time;
  final int qtPlanifier;
  final int bon;
  final int reject;
  final int toDo;
  final int total;
  final double trs;
  final double cycleTime;

  // Constructor
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

  // Factory method to create an instance from JSON
  factory ProductionData.fromJson(Map<String, dynamic> json) {
    // Adding validation for missing or invalid data
    return ProductionData(
      time: json['time'] ?? 'Unknown', // Default to 'Unknown' if time is missing
      qtPlanifier: json['qtplanifier'] ?? 0, // Default to 0 if the value is missing
      bon: json['bon'] ?? 0,
      reject: json['reject'] ?? 0,
      toDo: json['to_do'] ?? 0,
      total: json['total'] ?? 0,
      trs: (json['TRS'] ?? 0).toDouble(), // Ensure it’s a double, default to 0
      cycleTime: (json['cycle_time'] ?? 0).toDouble(), // Same for cycleTime
    );
  }

  // Optional: Convert this object back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'qtplanifier': qtPlanifier,
      'bon': bon,
      'reject': reject,
      'to_do': toDo,
      'total': total,
      'TRS': trs,
      'cycle_time': cycleTime,
    };
  }

  // Method for updating a ProductionData object with new values (Optional)
  ProductionData copyWith({
    String? time,
    int? qtPlanifier,
    int? bon,
    int? reject,
    int? toDo,
    int? total,
    double? trs,
    double? cycleTime,
  }) {
    return ProductionData(
      time: time ?? this.time,
      qtPlanifier: qtPlanifier ?? this.qtPlanifier,
      bon: bon ?? this.bon,
      reject: reject ?? this.reject,
      toDo: toDo ?? this.toDo,
      total: total ?? this.total,
      trs: trs ?? this.trs,
      cycleTime: cycleTime ?? this.cycleTime,
    );
  }
}
