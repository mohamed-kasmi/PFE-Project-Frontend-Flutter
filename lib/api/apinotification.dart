import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
import '../service/SharedPreferences/shared_pref_service.dart';
class ApiNotification{
  static const String baseurl='http://10.0.2.2:8000/notifications';
  static Future<bool> sendFcmToken(String fcmToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      String? accessT = await SharedPrefService.getaccesstoken();

      if (email == null || accessT == null) {
        print("Missing email or access token.");
        return false;
      }

      Future<http.Response> makeRequest(String token) {
        return http.post(
          Uri.parse('$baseurl/notification/fcm_tokens/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "token": fcmToken,
            "user_email": email,
          }),
        );
      }

      http.Response response = await makeRequest(accessT);

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
        final data = jsonDecode(response.body);
        final savedToken = FCMToken.fromJson(data['data']);
        print("FCM Token saved successfully: ${savedToken.token}");
        return true;
      } else {
        print("Failed to save FCM token: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error while saving FCM token: $e");
      return false;
    }
  }


  static Future<List<NotificationItem>> getnotifications(String email) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.get(
          Uri.parse('$baseurl/notifications-user/?email=$email'),
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
        return data.map((item) => NotificationItem.fromJson(item)).toList();
      } else {
        print("Failed to fetch notifications: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<bool> deletenotification(String notificationId) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.delete(
          Uri.parse('$baseurl/delete/$notificationId/'),
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
        print("Notification deleted successfully.");
        return true;
      } else {
        print("Failed to delete notification: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }


  static Future<bool> deleteAll(String email) async {
    try {
      String? accessT = await SharedPrefService.getaccesstoken();

      Future<http.Response> makeRequest(String token) {
        return http.delete(
          Uri.parse('$baseurl/deleteAll/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'email': email}),
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
        print("All notifications deleted successfully.");
        return true;
      } else {
        print("Failed to delete all notifications: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }


}