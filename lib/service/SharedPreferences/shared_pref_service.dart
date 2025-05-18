import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SharedPrefService {
  static const String baseurl='http://127.0.0.1:8000/auth';
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    return email;
  }
  static Future<String?> getaccesstoken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessT = prefs.getString('accessT');
    return accessT;
  }
  static Future<String?> getrefreshtoken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshT = prefs.getString('refreshT');
    return refreshT;
  }
  static Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshT');

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse('$baseurl/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access'];

      await prefs.setString('accessT', newAccessToken);
      if (data.containsKey('refresh')) {
        await prefs.setString('refreshT', data['refresh']);
      }
      return newAccessToken;
    } else {
      print('Refresh failed: ${response.body}');
      return null;
    }
  }
}