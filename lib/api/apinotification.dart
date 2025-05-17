import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
class ApiNotification{
  static const String baseurl='http://127.0.0.1:8000/notifications';
  static Future<bool> sendFcmToken(String fcmToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null) {
        print("No email found in SharedPreferences.");
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseurl/notification/fcm_tokens/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": fcmToken,
          "user_email": email,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final savedToken = FCMToken.fromJson(data['data']);
        print("FCM Token saved successfully: ${savedToken.token}");
        return true;
      } else {
        print("Failed to save FCM token: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error while saving FCM token: $e");
      return false;
    }
  }

  static Future<List<NotificationItem>> getnotifications(String email) async {
    try{
      final response = await http.get(
        Uri.parse('$baseurl/notifications-user/?email=$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => NotificationItem.fromJson(item)).toList();
      } else {
        print("Failed to fetch notifications: ${response.body}");
        return [];
      }
    } catch (e){
      print("Error: $e");
      return [];
    }
  }

  static Future<bool> deletenotification(String notificationId) async {
    try{
        final response = await http.delete(
          Uri.parse('$baseurl/delete/$notificationId/'),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 204) {
          return true;
        } else {
          return false;
        }
    } catch (e){
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> deleteAll(String email) async {
    try{
      final response = await http.delete(
        Uri.parse('$baseurl/deleteAll/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e){
      print("Error: $e");
      return false;
    }
  }

}