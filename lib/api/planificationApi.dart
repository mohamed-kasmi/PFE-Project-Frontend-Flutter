import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planificationData.dart';

class PlanificationApi {
  static Future<bool> sendPlanifications(List<PlanificationData> dataList) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.16:8000/machineplanification/mplanification/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataList.map((e) => e.toJson()).toList()),
      );
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
