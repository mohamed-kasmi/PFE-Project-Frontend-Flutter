import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/SharedPreferences/shared_pref_service.dart';
class Apiuser {
  static const String baseurl='http://127.0.0.1:8000/auth';
  static Future<Map<String, dynamic>> auth(String email, String password) async{
    try{
      final response = await http.post(Uri.parse('$baseurl/login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool firstlogin = data['firstlogin'];
        if(firstlogin){
          String email = data['email'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          print("Login successful!");
          return {'success': true, 'firstlogin': firstlogin};
        }else{
          String refresh = data['refresh'];
          String access = data['access'];
          String email = data['email'];
          String role = data['role'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('refreshT', refresh);
          await prefs.setString('accessT', access);
          await prefs.setString('email', email);
          await prefs.setString('role', role);
          print("Login successful!");
          return {'success': true, 'firstlogin': firstlogin};
        }
      } else {
        final errorData = jsonDecode(response.body);
        print("Login failed: ${errorData['error']}");
        return {'success': false};
      }
    }catch(e){
      print("Error: $e");
      return {'success': false};
    }
  }
  static Future<bool> forgotpass(String email) async{
    try{
      final response = await http.post(Uri.parse('$baseurl/forgot_password/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      if (response.statusCode == 200) {
        print("mail sent ");
        return true;
      } else {
        print("not sent " );
        return false;
      }
    }catch(e){
      print("Error: $e");
      return false;
    }
  }
  static Future<bool> restpass(String email,String password) async {
    try{
      final response =await http.put(Uri.parse('$baseurl/reset_password/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email":email,"password":password})
      );
      if (response.statusCode == 200) {
        print("password reset sucssefuly ");
        return true;
      } else {
        print("password didn't reset " );
        return false;
      }
    }catch(e){
      print("Error: $e");
      return false;
    }
  }
  static Future<bool> setpass(String token,String email,String password) async{
    try{
      final response =await http.post(Uri.parse('$baseurl/set_password/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"token":token,"email":email,"password":password})
      );
      if (response.statusCode == 200) {
        print("password set sucssefuly ");
        return true;
      } else {
        print("password didn't set " );
        return false;
      }
    }catch(e){
      print("Error: $e");
      return false;
    }
  }
  static Future<bool> adduser(int matricule, String email, String role) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.post(
          Uri.parse('$baseurl/signup/'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "matricule": matricule,
            "email": email,
            "role": role,
          }),
        );
      }

      http.Response response = await makeRequest(accessT ?? '');

      if (response.statusCode == 401) {
        print("Access token expired. Trying to refresh...");

        accessT = await SharedPrefService.refreshAccessToken();

        if (accessT != null) {
          response = await makeRequest(accessT);
        } else {
          print("Could not refresh access token.");
          return false;
        }
      }

      if (response.statusCode == 201) {
        print("User has been added");
        return true;
      } else {
        print("User already exists or error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchTokenAndEmail(String verificationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseurl/verification/?vid=$verificationId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'email': data['email'],
          'token': data['token'],
        };
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
  static Future<List<User>> getusers() async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.get(
          Uri.parse('$baseurl/getall/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      http.Response response = await makeRequest(accessT ?? '');

      if (response.statusCode == 401) {
        print("Access token expired. Trying to refresh...");

        accessT = await SharedPrefService.refreshAccessToken();

        if (accessT != null) {
          response = await makeRequest(accessT);
        } else {
          print("Could not refresh access token.");
          return [];
        }
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        print("Failed to fetch users: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<bool> deleteuser(int id) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.delete(
          Uri.parse('$baseurl/delete/$id/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      http.Response response = await makeRequest(accessT ?? '');

      if (response.statusCode == 401) {
        print("Access token expired. Trying to refresh...");

        accessT = await SharedPrefService.refreshAccessToken();

        if (accessT != null) {
          response = await makeRequest(accessT);
        } else {
          print("Could not refresh access token.");
          return false;
        }
      }

      if (response.statusCode == 204) {
        return true;
      } else {
        print("Failed to delete user: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

}