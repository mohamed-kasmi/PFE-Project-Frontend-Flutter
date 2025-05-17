import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Apiuser {
  static const String baseurl='http://192.168.1.14:8000/auth';
  static Future<bool> auth(String email, String password) async{
    try{
      final response = await http.post(Uri.parse('$baseurl/login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        String email = data['email'];
        String role = data['role'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);
        await prefs.setString('role', role);
        print("Login successful!");
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print("Login failed: ${errorData['error']}");
        return false;
      }
    }catch(e){
      print("Error: $e");
      return false;
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
  static Future<bool> restpass(String token,String email,String password) async {
    try{
      final response =await http.put(Uri.parse('$baseurl/reset_password/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"token":token,"email":email,"password":password})
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
  static Future<bool> adduser(int matricule,String email,String role) async{
    try{
      final response =await http.post(Uri.parse('$baseurl/signup/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"matricule":matricule,"email":email,"role":role})
      );
      if(response.statusCode == 201){
        print("user has been added");
        return true;
      }else{
        print("user already exist");
        return false;
      }
    }catch(e){
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
      final response = await http.get(Uri.parse('$baseurl/getall/'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        print("Failed to fetch users");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<bool> deleteuser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseurl/delete/$id/'));
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}