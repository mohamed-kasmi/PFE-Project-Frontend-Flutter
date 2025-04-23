class MachineStop {
  final int id;
  final String machineName;
  final DateTime dateInsert;
  final int partNO;
  final String codeStop;
  final DateTime debutStopTime;
  final DateTime finStopTime;
  final String regleurPrenom;


  MachineStop({
    required this.id,
    required this.machineName,
    required this.dateInsert,
    required this.partNO,
    required this.codeStop,
    required this.debutStopTime,
    required this.finStopTime,
    required this.regleurPrenom,
  });

  factory MachineStop.fromJson(Map<String, dynamic> json) {
    return MachineStop(
      id: json['id'],
      machineName: json['Machine_Name'],
      dateInsert: DateTime.parse(json['Date_Insert']),
      partNO: json['Part_NO'],
      codeStop: json['Code_Stop'],
      debutStopTime: DateTime.parse(json['Debut_Stop_Time']),
      finStopTime: DateTime.parse(json['Fin_Stop_Time']),
      regleurPrenom: json['Regleur_Prenom'],
    );
  }
}