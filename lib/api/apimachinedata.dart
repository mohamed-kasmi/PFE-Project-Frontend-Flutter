import 'package:http/http.dart'as http;
import 'dart:convert';
import '../models/machinedata.dart';
import '../service/SharedPreferences/shared_pref_service.dart';

class Apimachinedata{
  static const String baseurl='http://127.0.0.1:8000/machinedata';

  static Future<List<MachineData>> getMachineByGranularity(
      String startDate, String endDate, String name, String granularity) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.get(
          Uri.parse(
            '$baseurl/machinegranularity/?start_date=$startDate&end_date=$endDate&name=$name&granularity=$granularity',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      http.Response response = await makeRequest(accessT ?? '');

      if (response.statusCode == 401) {
        accessT = await SharedPrefService.refreshAccessToken();
        if (accessT != null) {
          response = await makeRequest(accessT);
        } else {
          return [];
        }
      }

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => MachineData.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<List<String>> getMachineNames() async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.get(
          Uri.parse('$baseurl/machinenames/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      http.Response response = await makeRequest(accessT ?? '');

      if (response.statusCode == 401) {
        accessT = await SharedPrefService.refreshAccessToken();
        if (accessT != null) {
          response = await makeRequest(accessT);
        } else {
          return [];
        }
      }

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((names) => names.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

}