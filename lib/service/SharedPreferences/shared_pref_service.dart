import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    return email;
  }
}