import 'package:http/http.dart'as http;
import 'dart:convert';
import '../models/machinestop.dart';

class Apimachinedata{
  static const String baseurl='http://10.0.2.2:8000/machinestop';
  static Future<List<MachineStop>> getmachines() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/machines/'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineStop.fromJson(e)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<List<MachineStop>> getmachinebyname(String name) async{
    try{
      final response = await http.get(Uri.parse('$baseurl/machinen/?name=$name'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineStop.fromJson(e)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    }catch (e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<List<MachineStop>> getmachinebydate(String startdate, String enddate) async{
    try{
      final response = await http.get(Uri.parse('$baseurl/machined/?start_date=$startdate&end_date=$enddate'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineStop.fromJson(e)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    }catch (e) {
      print("Error: $e");
      return [];
    }
  }
}