import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planificationData.dart';
import '../service/SharedPreferences/shared_pref_service.dart';

class PlanificationApi {
  static Future<bool> sendPlanifications(List<PlanificationData> dataList) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.post(
          Uri.parse('http://10.0.2.2:8000/machineplanification/mplanification/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(dataList.map((e) => e.toJson()).toList()),
        );
      }

      http.Response response = await makeRequest(accessT ?? '');

      if (response.statusCode == 401) {
        accessT = await SharedPrefService.refreshAccessToken();
        if (accessT != null) {
          response = await makeRequest(accessT);
        } else {
          return false;
        }
      }

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error sending planification: $e');
      return false;
    }
  }

}
