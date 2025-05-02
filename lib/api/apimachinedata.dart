import 'package:http/http.dart'as http;
import 'dart:convert';
import '../models/machinedata.dart';

class Apimachinedata{
  static const String baseurl='http://127.0.0.1:8000/machinedata';
  static Future<List<MachineData>> getmachines() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/machines/'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineData.fromJson(e)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    } catch (e) {
    print("Error: $e");
    return [];
    }
  }
  static Future<List<MachineData>> getmachinebyname(String name) async{
    try{
      final response = await http.get(Uri.parse('$baseurl/machinen/?name=$name'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineData.fromJson(e)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    }catch (e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<List<MachineData>> getmachinebydate(String startdate, String enddate) async{
    try{
      final response = await http.get(Uri.parse('$baseurl/machined/?start_date=$startdate&end_date=$enddate'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineData.fromJson(e)).toList();
      } else {
        print("Failed to fetch machines");
        return [];
      }
    }catch (e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<List<MachineData>> getMachineByGranularity(
      String startDate, String endDate, String name, String granularity) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseurl/machinegranularity/?start_date=$startDate&end_date=$endDate&name=$name&granularity=$granularity'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineData.fromJson(e)).toList();
      } else {
        print("Failed to fetch machine data");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<List<String>> getMachineNames() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/machinenames/'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((names) => names.toString()).toList();
      } else {
        print("Failed to fetch machine names");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}