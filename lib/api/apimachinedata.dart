import 'package:http/http.dart'as http;
import 'dart:convert';
import '../models/machinedata.dart';

class Apimachinedata{
  static const String baseurl='http://127.0.0.1:8000/machinedata';
  static Future<List<MachineData>> getmachines() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/machines/'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((machines) => MachineData.fromJson(machines)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    } catch (e) {
    print("Error: $e");
    return [];
    }
  }
}