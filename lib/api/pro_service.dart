import '../models/pro_database.dart';

class ProService {
  // Simulated test data
  final List<ProDatabase> testData = [
    ProDatabase(
      machineName: 'Machine 1',
      bon: 80,
      reject: 10,
      total: 90,
      toDo: 10,
      qtPlanifier: 100,
      trs: 90,
      time: '15:01',
      cycleTime: 3.2,
      bonPerDay: [10, 15, 8, 12, 14, 11, 10],
    ),
    ProDatabase(
      machineName: 'Machine 2',
      bon: 60,
      reject: 20,
      total: 80,
      toDo: 20,
      qtPlanifier: 100,
      trs: 80,
      time: '10:01',
      cycleTime: 1.3,
      bonPerDay: [9, 10, 6, 12, 7, 8, 8],
    ),
    ProDatabase(
      machineName: 'Machine 3',
      bon: 50,
      reject: 30,
      total: 80,
      toDo: 20,
      qtPlanifier: 100,
      trs: 70,
      time: '12:03',
      cycleTime: 2.0,
      bonPerDay: [6, 7, 5, 10, 8, 7, 7],
    ),
  ];
}
