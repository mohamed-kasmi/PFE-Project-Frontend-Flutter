import 'package:flutter/material.dart';
import 'package:pdcs_frontend/activity/Home.dart';
import 'activity/auth/Login.dart';
import 'activity/auth/Forget.dart';
import 'activity/auth/reset.dart';
import 'activity/auth/setpassword.dart';
import 'activity/s_administrateur/users.dart';
import 'activity/s_administrateur/ajout.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: (settings) {
      Uri uri = Uri.parse(settings.name!); // Parse the URL

      if (uri.path == '/reset-password') {
        // Extract token and email from query parameters
        String? token = uri.queryParameters['token'];
        String? email = uri.queryParameters['email'];

        return MaterialPageRoute(
          builder: (context) => ResetPasswordPage(token: token, email: email),
        );
      }
      if (uri.path == '/set-password') {
        // Extract token and email from query parameters
        String? token = uri.queryParameters['token'];
        String? email = uri.queryParameters['email'];

        return MaterialPageRoute(
          builder: (context) => SetPasswordPage(token: token, email: email),
        );
      }

      // Default Routes
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => HomePage());
        case '/login':
          return MaterialPageRoute(builder: (context) => Login());
        case '/users':
          return MaterialPageRoute(builder: (context) => UsersPage());
        default:
          return MaterialPageRoute(builder: (context) => HomePage()); // Fallback
      }
    },
  ));
}
